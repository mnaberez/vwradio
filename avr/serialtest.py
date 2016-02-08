#!/usr/bin/env python
import sys
import time
import serial # pyserial

def forever():
    lastwrite = time.time()

    while True:
        now = time.time()
        if now - lastwrite >= 1:
            lastwrite = now
            ser.write('Hello world, this is a lot of text that should be buffered.')
            ser.flush()

        numbytes = ser.in_waiting
        if numbytes:
            sys.stdout.write(ser.read(numbytes))
            sys.stdout.flush()

        time.sleep(0.1)

ser = serial.Serial(port='/dev/cu.usbserial-FTHKH0VE', baudrate=57600)
try:
    forever()
finally:
    ser.close()
