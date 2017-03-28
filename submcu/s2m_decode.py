'''
Decode messages sent from the Sub-CPU on the Sub-to-Main SPI bus
'''

import sys

def binstring(x):
    b = bin(x)[2:]
    s = ''
    i = 0
    for bit in b:
        s += bit
        i += 1
        if i == 8:
            s += ' '
            i = 0
    return s.rstrip()

def parse_file(filename):
    lines = open(filename, 'r').readlines()
    packets = []
    for line in lines:
        if "MOSI" in line:
            packets.append(int(line.split()[-1][2:], 16))
    return packets

packets = parse_file(sys.argv[1])
binstrings = []
for packet in packets:
    if packet == 0x9048002a: # idle state
        continue
    bs = binstring(packet)
    binstrings.append(bs)
    print "%s (%s)" % (bs, hex(packet))

diffs = set()
for i, bs in enumerate(binstrings):
    bs = ''.join(bs.split()).strip()
    for bitnum, bit in enumerate(bs):
            for bs2 in binstrings:
                bs2 = ''.join(bs2.split()).strip()
                if bs2[bitnum] != bit:
                    diffs.add(bitnum)
print sorted(diffs)


#11000101 01001000 00000000 00101010: 0xc548002a
#    4567 8

#  9, 10,11,12,13,14,15,16
# 17, 18,19,20,21,22,23,24
# 25, 26,27,28,29,30,31,32