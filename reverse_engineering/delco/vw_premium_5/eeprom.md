# EEPROM Checksums

## Overview

The M24C04 EEPROM (512 bytes across two I2C pages) contains three independently checksummed regions. The firmware validates each region separately during the EEPROM-to-RAM sync process.  If a checksum fails, the firmware overwrites that region in RAM with defaults from ROM and recomputes the checksum.

The EEPROM is NOT read during early boot.  Cold start loads ROM defaults into RAM.  The EEPROM is read later, after the POWER key is pressed, via a background task that reads the data in chunks over I2C.

## Regions

### Checksum A

| Field | Value |
|-------|-------|
| Data range | EEPROM 0x10 - 0x43 (52 bytes) |
| Stored at | EEPROM 0x44 (lo), 0x45 (hi) |
| RAM range | 0xF1B3 - 0xF1E6 |

Contents: SAFE code, preset frequencies, FM/AM station data.

### Checksum B

| Field | Value |
|-------|-------|
| Data range | EEPROM 0x46 - 0x60 (27 bytes) |
| Stored at | EEPROM 0x61 (lo), 0x62 (hi) |
| RAM range | 0xF1E7 - 0xF201 |

Contents: region code, KWP1281 ID strings, soft coding, workshop code.

Note: EEPROM 0x44-0x45 (checksum A) sit between the two regions and are NOT included in either checksum's data range.

### Checksum C

| Field | Value |
|-------|-------|
| Data range | EEPROM 0x63 - 0xC8 (102 bytes) |
| Stored at | EEPROM 0xC9 (lo), 0xCA (hi) |
| RAM range | 0xF206 - 0xF26B |

Contents: mode, volume, sound settings, preset data, frequency indices.

Checksum C is maintained incrementally by `eeram_f206_wr_byte_hl` (0x4092) during normal operation.  When a byte in this area changes, the old value is subtracted from the checksum and the new value added.

## EEPROM-to-RAM Address Mapping

The EEPROM data is copied into two separate RAM areas.  The mapping is *not* a simple linear offset.  EEPROM 0x44-0x45 (checksum A) and 0x61-0x62 (checksum B) are stored in RAM but are not part of either data region's checksum.

### RAM area 1: 0xF1B3 - 0xF203

| EEPROM | RAM | Bytes | Contents |
|--------|-----|-------|----------|
| 0x10 - 0x43 | 0xF1B3 - 0xF1E6 | 52 | Checksummed data A |
| 0x44 - 0x45 | 0xFED7 - 0xFED8 | 2 | Checksum A (stored in temp during verify) |
| 0x46 - 0x60 | 0xF1E7 - 0xF201 | 27 | Checksummed data B |
| 0x61 - 0x62 | 0xF202 - 0xF203 | 2 | Checksum B |

The gap between data A and data B means EEPROM 0x44-0x45 do NOT occupy RAM addresses 0xF1E7-0xF1E8.  Instead, EEPROM 0x46 maps directly to 0xF1E7.

Effective base addresses:
- EEPROM 0x10-0x43 -> RAM base = 0xF1A3 (RAM = 0xF1A3 + EEPROM_offset)
- EEPROM 0x46-0x62 -> RAM base = 0xF1A1 (RAM = 0xF1A1 + EEPROM_offset)

The 2-byte difference in base addresses is caused by EEPROM 0x44-0x45 being excluded from the contiguous RAM region.

### RAM area 2: 0xF206 - 0xF26D

| EEPROM | RAM | Bytes | Contents |
|--------|-----|-------|----------|
| 0x63 - 0xC8 | 0xF206 - 0xF26B | 102 | Checksummed data C |
| 0xC9 - 0xCA | 0xF26C - 0xF26D | 2 | Checksum C |

Base address: 0xF1A3 (RAM = 0xF1A3 + EEPROM_offset).

## Notable EEPROM Locations

| EEPROM | RAM | Description |
|--------|-----|-------------|
| 0x14-0x15 | 0xF1B7-0xF1B8 | SAFE code (BCD, e.g. 0x08 0x72 = 0872) |
| 0x44-0x45 | (temp) | Checksum A |
| 0x46 | 0xF1E7 | Region code (0-7) |
| 0x4C-0x55 | 0xF1ED-0xF1F6 | Part number string (e.g. "1J0035180B") |
| 0x58-0x59 | 0xF1F9-0xF1FA | KWP1281 soft coding |
| 0x5A-0x5B | 0xF1FB-0xF1FC | KWP1281 workshop code |
| 0x61-0x62 | 0xF202-0xF203 | Checksum B |
| 0x68 | 0xF20B | SAFE attempt counter |
| 0xC9-0xCA | 0xF26C-0xF26D | Checksum C |

## Checksum Algorithm

All three checksums use the same algorithm (Python):

```python
def eeprom_checksum(data):
    x = 0x55
    a = 0x00
    for b in data:
        x += b
        if x > 0xFF:
            a = (a + 1) & 0xFF
            x &= 0xFF
    return x, a  # lo, hi
```

This is implemented in firmware at `eeram_csum` (0x0C15).  The initial value of X is always 0x55.

Given a 256- or 512-byte EEPROM image, calculate all three checksums and store them in their locations:

```python
def fix_eeprom_checksums(data):
    """Recompute all three checksums in a raw EEPROM image.
    data must be a mutable sequence (e.g. bytearray)."""
    for start, end, csum_addr in [(0x10, 0x44, 0x44),
                                   (0x46, 0x61, 0x61),
                                   (0x63, 0xC9, 0xC9)]:
        x = 0x55
        a = 0x00
        for b in data[start:end]:
            x += b
            if x > 0xFF:
                a = (a + 1) & 0xFF
                x &= 0xFF
        data[csum_addr] = x      # lo
        data[csum_addr + 1] = a  # hi
```

An EEPROM image fixed by this function will be accepted by the firmware without falling back to defaults.

## Verification Sequence

The firmware verifies checksums in the background task
`kwp_7c_1b_30_eeprom_csum_related` (0x4109), called from the main
EEPROM sync loop at 0x3F06.  The sequence is:

1. Read EEPROM 0x10-0x43 (52 bytes) into RAM 0xF1B3-0xF1E6
2. Read EEPROM 0x44-0x45 (2 bytes) into temp at 0xFED7
3. Verify checksum A: compute over RAM 0xF1B3-0xF1E6, compare with 0xFED7
4. On failure: reload defaults for 0xF1B3-0xF1E6 from ROM, retry
5. Read EEPROM 0x46-0x62 (29 bytes) into RAM 0xF1E7-0xF203
6. Verify checksum B: compute over RAM 0xF1E7-0xF201, compare with 0xF202
7. On failure: reload defaults for 0xF1E7-0xF201 from ROM
8. The full 79-byte verification (A=0x4F) at 0x3F3D runs later as a
   combined check over both areas

On checksum failure, the firmware loads defaults from ROM tables:
- `mem_0080_ee_0010_defaults` (0x0080): 52 bytes for 0xF1B3-0xF1E6
- `mem_00b4_ee_0046_defaults` (0x00B4): 18 bytes for 0xF1E7-0xF1F8
- `mem_00c6_ee_0058_defaults` (0x00C6): 9 bytes for 0xF1F9-0xF201
