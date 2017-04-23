'''
Send an Intel Hex file to the DPROM 2.

Usage: lst2bin <port> <file.hex>
'''

import sys
import serial # pyserial
import time

port = sys.argv[1]
filename = sys.argv[2]

with open(filename, 'r') as f:
    intel_hex_chars = f.read()

ser = serial.Serial(port=port, baudrate=38400, timeout=None)

size = len(intel_hex_chars)
for i, char in enumerate(intel_hex_chars):
    ser.write(char)
    ser.flush()
    time.sleep(0.0002)

    pct = (float(i) / size) * 100
    sys.stdout.write("\rSent %0.0f%% of %r to DPROM 2" % (pct, filename))
    sys.stdout.flush()

sys.stdout.write("\n")
ser.close()
