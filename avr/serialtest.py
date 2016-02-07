#!/usr/bin/env python
import sys
import time
import serial # pyserial

def forever():
    outbuf = 'ggrbrg' # green, green, red, both...
    bufpos = 0
    lastwrite = time.time()

    while True:
        time.sleep(0.1)

        numbytes = ser.in_waiting
        if numbytes:
            sys.stdout.write(ser.read(numbytes))
            sys.stdout.flush()

        now = time.time()
        secs = now - lastwrite
        if secs >= 1:
            lastwrite = now
            ser.write(outbuf[bufpos])
            ser.flush()
            bufpos += 1
            if bufpos == len(outbuf):
                bufpos = 0

ser = serial.Serial()
ser.port = '/dev/cu.usbserial-FTHKH0VE'
ser.baud = 9600
ser.open()
try:
    forever()
finally:
    ser.close()
