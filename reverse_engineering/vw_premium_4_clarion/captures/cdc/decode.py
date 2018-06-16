'''
Usage: %s <filename>
'''

import gzip
import re
import sys

def read_file(filename):
    # parse csv into byte stream
    lines = [ l.strip() for l in gzip.open(filename, 'rt').readlines() ]
    byte_stream = []
    for line in lines:
        matches = re.findall('\(0x(.{2})\)$', line)
        if matches:
            byte_stream.append(int(matches[0], 16))

    # parse byte stream into packets
    packets = []
    current_packet = []
    last_byte = None
    for byte in byte_stream:
        if (byte == 0x34) and (last_byte == 0x3c): # 0x34 = start of frame
            current_packet = [0x34]
        else:
            current_packet.append(byte)
            if (byte == 0x3c) and (len(current_packet) == 8): # 0x3c = end of frame
                if (len(packets) == 0) or (packets[-1] != current_packet):
                    packets.append(current_packet)
        last_byte = byte

    def inverted_bcd(byte):
        try:
            return int(hex(0xff - byte)[2:])
        except ValueError:
            return 0

    for packet in packets:
        cd = inverted_bcd(packet[1] | 0xf0)
        track = inverted_bcd(packet[2])
        minutes = inverted_bcd(packet[3])
        seconds = inverted_bcd(packet[4])

        desc = "cd = %d, track = %d, time = %02d:%02d" % (cd, track, minutes, seconds)
        print("[%s] %s" % (''.join(['%02x' % byte for byte in packet]), desc))

if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write((__doc__.strip() + '\n') % sys.argv[0])
        sys.exit(1)
    read_file(sys.argv[1])
