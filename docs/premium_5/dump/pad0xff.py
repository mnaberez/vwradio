#!/usr/bin/env python3
import sys

filename = sys.argv[1]
kilobytes = int(sys.argv[2])

with open(filename, 'rb') as f:
    data = bytearray(f.read())

padlen = 0
while len(data) < (kilobytes*1024):
    data.append(0xFF)
    padlen += 1

with open(filename, 'wb') as f:
    f.write(data)

print("Padded %r to %dK (%d bytes appended)" % (filename, kilobytes, padlen))
