#!/usr/bin/env python3 -u
import sys
import time
import serial # pyserial

def make_serial():
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=115200, timeout=2)

if __name__ == '__main__':
    ser = make_serial()
    while True:
        numbytes = ser.in_waiting
        if numbytes:
            sys.stdout.write(ser.read(numbytes).decode('utf-8'))
        else:
            time.sleep(0.05)
