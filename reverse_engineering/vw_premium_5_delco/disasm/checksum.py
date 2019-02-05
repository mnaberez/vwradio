'''
Premium 5 ROM checksum utility

Calculate the checksum of a ROM.  For "compare", read the
checksum bytes at the end of the ROM file and report if they
match (file is not changed).  For "update", replace the checksum
bytes in the file with the calculated checksum.

Usage: %s [compare|update] <filename.bin>

'''

import sys

def read_rom_file(filename):
    with open(filename, 'rb') as f:
        rom = bytearray(f.read())
    if len(rom) != 0xF000:
        raise Exception("ROM is not expected length")
    return rom

def calculate_checksum(rom):
    checksum = 0x5555
    for address in range(0, 0xEFFE):
        checksum += rom[address]
    checksum &= 0xFFFF
    return checksum

def read_checksum(rom):
    return rom[0xEFFE] + (rom[0xEFFF] << 8)

def main():
    if len(sys.argv) != 3 or sys.argv[1] not in ('compare', 'update'):
        sys.stderr.write(__doc__ % sys.argv[0])
        sys.exit(1)
    mode, filename = sys.argv[1:]

    rom = read_rom_file(filename)
    embedded_checksum = read_checksum(rom)
    calculated_checksum = calculate_checksum(rom)
    print("Calculated checksum = 0x%04x" % calculated_checksum)

    if mode == "compare":
        print("Embedded checksum   = 0x%04x" % embedded_checksum)
        if calculated_checksum == embedded_checksum:
            print("Checksum OK")
            sys.exit(0)
        else:
            sys.stderr.write("ERROR: Checksum mismatch\n")
            sys.exit(1)
    else: # "update"
        # remove last two bytes from the rom (checksum area)
        while len(rom) > 61438:
            rom.pop()
        assert len(rom) == 61438

        # write checksum into image
        low_byte = calculated_checksum & 0xFF
        rom.append(low_byte)
        high_byte = (calculated_checksum >> 8) & 0xFF
        rom.append(high_byte)

        # save file
        with open(filename, 'wb') as f:
            f.write(rom)
        print("Checksum updated")
        sys.exit(0)

if __name__ == '__main__':
    main()
