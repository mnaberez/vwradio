'''
Parse an ASF2MC8 relocatable object file and create a binary file from it.
Assumes the file contains only absolute code.  Unused areas are filled with 0.

Usage: rel2bin <file.lst> [<file.bin>]
'''

import os
import re
import sys

def parse_rel_lines(lines):
    '''Parse REL file lines into a dict of address: value'''
    bytes_by_address = {}
    for line in lines:
        if line.startswith("T"):  # "T E0 27 85 8D 00"
            parts = [ int(s, 16) for s in line.split()[1:] ]
            address = (parts[0] << 8) + parts[1]
            data = parts[2:]
            for i, d in enumerate(data):
                bytes_by_address[address + i] = d
    return bytes_by_address

def build_binary(bytes_by_address):
    '''Build binary data block from dict of address: value'''
    addresses = sorted(bytes_by_address.keys())
    start_address = addresses[0]
    end_address = addresses[-1]

    data = bytearray()
    for address in range(start_address, end_address + 1):
        data.append(bytes_by_address.get(address, 0))

    return start_address, end_address, data

def main(relfile, binfile):
    '''Parse a REL file as input and write a binary file as output'''
    with open(relfile, 'r') as f:
        lines = f.readlines()

    bytes_by_address = parse_rel_lines(lines)
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
        relfile = sys.argv[1]
        if len(sys.argv) == 3:
            binfile = sys.argv[2]
        else:
            binfile = os.path.splitext(relfile)[0] + '.bin'
        main(relfile, binfile)
