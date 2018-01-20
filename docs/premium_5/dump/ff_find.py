#!/usr/bin/env python3 -u

'''
Find all flash locations containing 0xFF by trying to write 0xFF
to every location.  If write fails, the location does not contain
0xFF since only a "1" bit can be changed to a "0" bit.
'''

import re
import sys
import serial # pyserial

def make_serial():
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=9600, timeout=2)

class Flashpro(object):
    def __init__(self, ser):
        ser.reset_input_buffer()
        ser.reset_output_buffer()
        self.serial = ser
        self.help()

    def help(self):
        '''Send HLP command, return all text received'''
        return self._command('HLP')

    def status(self):
        '''Send STS command, return all text received'''
        return self._command('STS')

    def program(self, start_address, end_address):
        '''Send flash programming command.  On success, return None.
           On failure, return the address of the failure.'''
        cmd = 'PRG %04x %04x' % (start_address, end_address)
        text = self._command(cmd)
        matches = re.findall('Failed at ([\dA-Fa-f]+)H', text)
        if not matches:
            return None
        return int(matches[0], 16)

    def _command(self, cmd):
        '''Send a command, wait for the prompt to come back,
           return any text received.'''
        cmd += '\r'
        self.serial.write(cmd.encode('utf-8'))
        text = self.wait_for_prompt()
        return text

    def wait_for_prompt(self):
        '''Wait for the prompt, return any text received.'''
        text = ''
        while '<' not in text:
            numbytes = self.serial.in_waiting
            if numbytes:
                try:
                    chars = self.serial.read(numbytes).decode('utf-8')
                except UnicodeDecodeError:
                    chars = '?'
                sys.stdout.write(chars)
                sys.stdout.flush()
                text += chars
        return text


def main():
    ser = make_serial()
    fp = Flashpro(ser)

    ffs = []
    last_failed_address = None
    start = 0x10
    while start < 0xEFFF:
        failed_address = fp.program(start, 0xEFFF)
        if failed_address is not None:
            if last_failed_address is not None:
                i = last_failed_address + 1
                while i < failed_address:
                    ffs.append(i)
                    i += 1
            print("\nFOUND FFs = %r" % ['%04X' % x for x in ffs])
            last_failed_address = failed_address
            start = failed_address + 1

if __name__ == '__main__':
    main()

