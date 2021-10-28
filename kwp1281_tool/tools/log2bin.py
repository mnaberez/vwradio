#!/usr/bin/env python

'''
Parse a log file containing "MEM:" lines from the KWP1281 tool
and write the data to a binary file.

Usage: %s file.log
'''
import os
import sys

def parse_dump_from_log(filename):
    with open(filename, 'r') as f:
        dump = bytearray()
        for line in f.readlines():
            if line.startswith('MEM:'):
                # "MEM: 00A0: 03 31 00 ..." -> [0x03, 0x31, 0x00, ...]
                linedata = [ int(s, 16) for s in line.split()[2:] ]
                dump.extend(linedata)
    return dump

def write_dump(filename, dump):
    with open(filename, 'wb') as f:
        f.write(dump)

def main():
    if len(sys.argv) != 2:
        sys.stderr.write(__doc__ % sys.argv[0])
        sys.exit(1)
    infile = os.path.abspath(sys.argv[1])
    outfile = "%s.bin" % os.path.splitext(infile)[0]
    dump = parse_dump_from_log(infile)
    write_dump(outfile, dump)
    print("Dump written to: %s" % outfile)

if __name__ == "__main__":
    main()
