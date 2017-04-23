'''
Parse an ASF2MC8 listing file and create a binary file from it.

Usage: lst2bin <lstfile> [<binfile>]
'''

import os
import re
import sys

def parse_listing(lines):
    '''Parse listing lines into a dict of address: value'''
    bytes_by_address = {}
    for line in lines:
        # split line: 'E000 21 E0 00' => ['E000', '21', 'E0', '00']
        parts = line[0:20].split()

        # ignore lines without address and data
        if (len(parts) < 2) or (not re.match(r'([A-F\d]{4})', parts[0])):
            continue

        # parse address and each data byte
        address = int(parts[0], 16)
        for i, part in enumerate(parts[1:]):
            bytes_by_address[address + i] = int(part, 16)
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
        print(__doc__)
        sys.exit(1)
    else:
        lstfile = sys.argv[1]
        if len(sys.argv) == 3:
            binfile = sys.argv[2]
        else:
            binfile = os.path.splitext(lstfile)[0] + '.bin'
        main(lstfile, binfile)
