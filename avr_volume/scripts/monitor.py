#!/usr/bin/env python3
'''
VW Radio Volume Monitor

Receives packets of M62419FP data from the AVR's UART and displays them.
'''

import sys
import time
import serial # pyserial

def make_serial():
    '''Make Serial() instance for first non-Bluetooth serial port'''
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=115200, timeout=None)

def read_packet(ser):
    '''Read a packet from the AVR.  Returns [CH0, CH1]'''
    count = bytearray(ser.read(1))[0]   # read number of bytes to follow
    packet = bytearray(ser.read(count)) # read those bytes
    return packet

inputs = ('CD', 'FM', 'TAPE', 'AM')
fadesels = ('F', 'R')

def main():
    '''Wait for a packet from the AVR, display it, repeat forever'''
    sys.stdout.write('\n')

    ser = make_serial()
    ser.reset_input_buffer()

    try:
        while True:
            packet = read_packet(ser)
            fmt = ('\rCH0=-%d dB (L=%d,I=%s), CH1=-%d dB (L=%d,I=%s),    '
                   'FADER=%d dB (%s) ')
            sys.stdout.write(fmt % (
                packet[2],
                packet[3],
                inputs[packet[4]],
                packet[7],
                packet[8],
                inputs[packet[9]],
                packet[12],
                fadesels[packet[10]]))
            sys.stdout.flush()
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
