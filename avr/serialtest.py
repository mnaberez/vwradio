#!/usr/bin/env python
import sys
import time
import serial # pyserial

def forever():
    outbuf = 'grgrgrgrgrb' # green/red/both
    ser.write(outbuf)
    ser.flush()

    while True:
        time.sleep(0.1)

        numbytes = ser.in_waiting
        if numbytes:
            sys.stdout.write(ser.read(numbytes))
            sys.stdout.flush()

ser = serial.Serial()
ser.port = '/dev/cu.usbserial-FTHKH0VE'
ser.baud = 9600
ser.open()
try:
    forever()
finally:
    ser.close()
