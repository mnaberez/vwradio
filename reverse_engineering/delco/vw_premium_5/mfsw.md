# MFSW Protocol (Multi-Function Steering Wheel)

As implemented in the VW Premium 5 radio firmware (software23).

## Hardware

The MFSW controller in the steering wheel communicates with the radio over a
single wire, unidirectional (steering wheel to radio), active-low.

On the radio PCB:

    MFSW pin → HEF40106BT pin 12 (in) → pin 13 (out) → P0.0/INTP0

The HEF40106BT is a Schmitt-trigger inverter.  The inversion means:

| MFSW wire | P0.0 | Meaning     |
|-----------|------|-------------|
| HIGH      | LOW  | Idle        |
| LOW       | HIGH | Active      |

P0.0 idles LOW.  INTP0 interrupts on edges.  The firmware toggles the
edge polarity (EGP0/EGN0) during the start bit sequence, then uses
rising-edge-only for all 32 data bits.

## Timer

The firmware uses the free-running 16-bit timer TM01 to measure edge-to-edge
timing.  TM01 is configured with `tmc01 = 0x04`.  Based on the timing
thresholds in the firmware matching real-world values, the timer runs at the
main oscillator frequency fx = 4.19 MHz (one tick ≈ 0.239 µs).  The 16-bit
counter wraps every ~15.6 ms, which is longer than any single measurement.

All timing thresholds in the firmware, converted:

| Threshold   | Ticks  | Time     | Used for                              |
|-------------|--------|----------|---------------------------------------|
| 0x0831      |  2,097 |  0.50 ms | Data bit minimum period               |
| 0x1D7D      |  7,549 |  1.80 ms | Data bit 0/1 threshold; start HIGH min |
| 0x3126      | 12,582 |  3.00 ms | Data bit max; start HIGH new/repeat boundary |
| 0x629B      | 25,243 |  6.03 ms | Start LOW min; start HIGH max          |
| 0xC49C      | 50,332 | 12.01 ms | Start LOW max                          |

## Electrical Protocol

The wire idles HIGH.  A packet consists of a start bit followed by 32 data
bits (4 bytes), transmitted LSB-first.  No stop bit (however, see "trailing
pulse note below).

### Start bit

The start bit has two phases:

    Wire LOW ──────────────────── Wire HIGH ──────────── first data bit
                6–12 ms                3–6 ms

| Phase          | Min     | Max     | Typical | Firmware thresholds      |
|----------------|---------|---------|---------|--------------------------|
| LOW (active)   | 6.03 ms | 12.01 ms | 9 ms  | 0x629B–0xC49C            |
| HIGH (gap)     | 3.00 ms |  6.03 ms | 4.5 ms | 0x3126–0x629B (new frame) |

The firmware also accepts a shorter HIGH period of 1.80–3.00 ms as a
repeat code (key held down).  A repeat skips the 32 data bits and reuses
the previously received key code.

### Data bits

The firmware only triggers INTP0 on the wire's falling edge (start of each
active LOW pulse).  It measures the total period from one falling edge to
the next — the full bit cycle:

    Wire ──┐         ┌─────────────────┐           ┌──
           │   LOW   │      HIGH       │    LOW    │
           └─────────┘                 └───────────┘
           │← ──── one bit period ────→│

| Bit | Total period | Firmware range        | Firmware threshold |
|-----|--------------|-----------------------|--------------------|
| 0   | ~1.2 ms      | 0.50–1.80 ms (< 0x1D7D) | CY=0 after `not1` |
| 1   | ~2.3 ms      | 1.80–3.00 ms (≥ 0x1D7D) | CY=1 after `not1` |

The LOW pulse width is not independently validated.  Only the total
edge-to-edge period determines the bit value.  The LOW pulse just needs
to be long enough for the Schmitt trigger to detect it.

### Trailing pulse

After the last data bit's HIGH gap, a short LOW pulse is required.
This provides the rising edge the firmware needs to measure the last
bit's period.

The firmware's state machine consumes one rising edge during the
state 0x02->0x03 transition (validating the start HIGH duration)
without processing a data bit.  This means 33 rising edges are needed
to receive 32 data bits.  The 32 data bit LOW pulses provide 32 rising
edges; the trailing pulse provides the 33rd.

After the trailing pulse, the wire returns to idle (HIGH).

## Packet Format

4 bytes, each transmitted LSB-first:

| Byte | Value        | Description                    |
|------|--------------|--------------------------------|
| 0    | 0x82         | Header byte 1                  |
| 1    | 0x17         | Header byte 2                  |
| 2    | key code     | Key code (see table below)     |
| 3    | 0xFF - code  | Checksum (one's complement)    |

The firmware validates the header after receiving the first 16 bits
(at state 0x12).  After all 32 bits (at state 0x22), it verifies the
checksum: `(checksum XOR 0xFF) == key_code`.

### Shift register

The firmware uses a 16-bit right-rotate-through-carry to receive bits:

```
rorc low_byte   ; CY → low[7], low[0] → CY
rorc high_byte  ; CY → high[7], high[0] → (discarded)
```

New bits enter at `low[7]` and shift right.  After 8 bits, the first
bit received is at `low[0]`.  After 16 bits, the first byte occupies
the high byte (A) and the second byte the low byte (X).

This naturally decodes LSB-first transmission: the first bit transmitted
(LSB) ends up at the correct LSB position in the received byte.

## Key Codes

Key code values as stored in `mfsw_key` (0xF197) after reception:

|Complete Packet        | Code | MFSW button | Firmware equivalent | `mfsw_equivs` value  |
|-----------------------|------|-------------|---------------------|----------------------|
| 0x82  0x17  0x00  0xFF| 0x00 | Volume Down | Volume Down (0x1F)  | 0x1F                 |
| 0x82  0x17  0x01  0xFE| 0x01 | Volume Up   | Volume Up (0x1E)    | 0x1E                 |
| 0x82  0x17  0x0A  0xF5| 0x0A | Up          | Seek Up (0x21)      | 0x21                 |
| 0x82  0x17  0x0B  0xF4| 0x0B | Down        | Seek Down (0x20)    | 0x20                 |

The firmware looks up the key code in `mfsw_codes` (0xB3AC) to find its
index, then reads the corresponding faceplate-equivalent from `mfsw_equivs`
(0xB3B1).  Unrecognized key codes are silently ignored.

The "Up" and "Down" buttons perform the version of "seek" for each mode:

|Button| AM/FM Mode |  CD Mode   |Tape Mode |
|------|------------|------------|----------|
|Down  | Seek Down  | Track Down | MSS REW  |
|Up    | Seek Up    | Track Up   | MSS FF   |

In CD mode, "Track Down" works like the faceplate.  Pressing it once returns to 0:00 on the current track.  Pressing it again quickly performs track down.

## Inter-packet Timing

After a successful packet, the firmware sets a rate-limiter counter
(`cntr_0_mfsw_timeout`) to 0x9F (159).  This counter decrements over time.
Any new INTP0 edge while the counter is above 0x7A (122) is rejected
as too soon.  This enforces a minimum gap of approximately 37 counter
decrements between packets.

After an error, the counter is cleared to 0 (no delay before retry).

## Firmware State Machine Detail

The receiver is interrupt-driven on INTP0.  `mem_fe34` tracks the current
state.  The firmware alternates INTP0 edge polarity during the start bit,
then uses rising-edge-only for all data bits.

| State | Waiting for                 | P0.0 edge | INTP0 config       | Action on entry                              |
|-------|-----------------------------|-----------|---------------------|----------------------------------------------|
| 0x00  | Start (wire goes LOW)       | Rising    | EGP0=1, EGN0=0     | Record TM01, set timeout counter to 14, → 0x01 |
| 0x01  | End of start LOW            | Falling   | EGP0=0, EGN0=1     | Validate LOW duration (6.0–12.0 ms), → 0x02  |
| 0x02  | End of start HIGH           | Rising    | EGP0=1, EGN0=0     | Validate HIGH duration (3.0–6.0 ms), → 0x03. If 1.8–3.0 ms → repeat code |
| 0x03  | Bit 0 period end            | Rising    | (unchanged)         | Decode bit, shift into rx buffer              |
| 0x04  | Bit 1 period end            | Rising    | (unchanged)         | Decode bit, shift into rx buffer              |
| ...   | ...                         | Rising    | (unchanged)         | ...                                           |
| 0x12  | Bit 15 period end           | Rising    | (unchanged)         | Decode bit, validate header = 0x82 0x17       |
| 0x13  | Bit 16 period end           | Rising    | (unchanged)         | Decode bit, shift into rx buffer (fresh)      |
| ...   | ...                         | Rising    | (unchanged)         | ...                                           |
| 0x22  | Bit 31 period end           | Rising    | (unchanged)         | Decode bit, validate checksum, save key code   |

States 0x03–0x22 represent 32 data bits (4 bytes × 8 bits).  The header
(bytes 0–1) is validated after state 0x12 (16 bits).  The rx buffer is
then reused for bytes 2–3.  The key code and checksum are validated after
state 0x22 (32 bits).

Note: The state 0x02 transition consumes one rising edge without
processing a data bit (it validates the start HIGH duration).  This means
33 rising edges are needed: 1 for state 0x02 + 32 for data bits.  The 32
data LOW pulses provide 32 edges; the trailing pulse provides the 33rd.

Each state has a timeout counter (`cntr_0_fb05`) that is refreshed on
every valid edge.  If the counter reaches 0 before the next edge, the
state machine resets on the next edge.

On error at any point, the state machine resets to 0x00, clears flags,
and re-enables rising-edge-only detection.
