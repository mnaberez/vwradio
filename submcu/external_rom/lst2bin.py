'''
Parse an ASF2MC8 listing file and create a binary file from it.

Usage: lst2bin <file.lst> [<file.bin>]
'''

import os
import sys

def parse_listing(lines):
    '''Parse listing lines into a dict of address: value'''
    bytes_by_address = {}
    last_address = 0
    for line in lines:
        # ignore header lines
        if ('ASxxxx Assembler') in line or ('Hexadecimal [16-Bits]') in line:
            continue

        # symbol table indicates listing is complete
        if 'Symbol Table' in line:
            break

        # split line: 'E000 21 E0 00' => ['E000', '21', 'E0', '00']
        parts = line[0:27].split('[')[0].split()
        if not parts:
            continue

        # parse address and find index of data bytes
        if len(parts[0]) == 4:
            address = int(parts[0], 16)
            data_index = 1
        else:
            # long .byte list continues on next line without address
            address = last_address + 6
            data_index = 0
        last_address = address

        # parse data bytes
        for i, part in enumerate(parts[data_index:]):
            if len(part) == 2:  # hex number like "A5"
                bytes_by_address[address + i] = int(part, 16)
    return bytes_by_address

def build_binary(bytes_by_address):
    '''Build binary data block from dict of address: value'''
    data = bytearray()
    addresses = sorted(bytes_by_address.keys())
    if addresses:
        start_address, end_address = addresses[0], addresses[-1]
        for address in range(start_address, end_address + 1):
            data.append(bytes_by_address.get(address, 0))
    else:
        start_address, end_address = 0, 0
    return start_address, end_address, data

def main(lstfile, binfile):
    '''Parse a listing file as input and write a binary file as output'''
    with open(lstfile, 'r') as f:
        lines = f.readlines()

    bytes_by_address = parse_listing(lines)
    start_address, end_address, data = build_binary(bytes_by_address)

    with open(binfile, 'wb') as f:
        f.write(data)

    print("Start address = 0x%04X" % start_address)
    print("End address   = 0x%04X" % end_address)
    print("Wrote %d bytes to file %r" % (len(data), binfile))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.stderr.write("%s\n" % __doc__)
        sys.exit(1)
    else:
        lstfile = sys.argv[1]
        if len(sys.argv) == 3:
            binfile = sys.argv[2]
        else:
            binfile = os.path.splitext(lstfile)[0] + '.bin'
        main(lstfile, binfile)
