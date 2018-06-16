'''
Premium 5 ROM checksum utility

Calculates the checksum of a ROM and then compares it to
the checksum stored in the last two bytes of the ROM.

Usage: %s rom.bin

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
    if len(sys.argv) != 2:
        sys.stderr.write(__doc__ % sys.argv[0])
        sys.exit(1)

    rom = read_rom_file(sys.argv[1])
    embedded = read_checksum(rom)
    print("Embedded checksum   = 0x%04x" % embedded)
    calculated = calculate_checksum(rom)
    print("Calculated checksum = 0x%04x" % calculated)

    if calculated == embedded:
        print("Checksum OK")
        sys.exit(0)
    else:
        sys.stderr.write("ERROR: Checksum mismatch\n")
        sys.exit(1)

if __name__ == '__main__':
    main()
