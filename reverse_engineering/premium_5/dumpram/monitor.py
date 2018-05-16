#!/usr/bin/env python3 -u
import sys
import serial # pyserial

def make_serial():
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    print(names)
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=38400, timeout=None)

def receive_dump():
    ram = {}
    while True:
        while ser.read(1) != b':':
            pass

        high, low, data = ser.read(3)
        address = (high << 8) + low
        ram[address] = data
        if (0xf000 in ram) and (0xfeff in ram):
            break
        sys.stdout.write("\rReceiving %04x\r" % address)
        sys.stdout.flush()
    return ram

def print_ram(ram, old_ram):
    address = 0xf000
    while address < 0xfeff:
        if address == 0xf800: # skip reserved area
            address = 0xfb00

        sys.stdout.write("%04X-%04X: " % (address, address+63))
        for i in range(64):
            b = ram[address+i]
            old_b = old_ram.get(address+i, b)
            if b != old_b:
                sys.stdout.write(chr(27)+'[45m'+chr(27)+'[1m')
                sys.stdout.write("%02x" % ram[address+i])
                sys.stdout.write(chr(27)+'[0m ')
            else:
                sys.stdout.write("%02x " % ram[address+i])

        strdump = ''
        for i in range(64):
            b = ram[address+i]
            if (b >= 0x20) and (b <= 0x7e):  # printable 7-bit ascii
                strdump += chr(b)
            else:
                strdump += '.'
        sys.stdout.write(strdump + "\n")
        sys.stdout.flush()

        address += 64

def clear_screen():
    sys.stdout.write(chr(27)+'[2J')
    sys.stdout.write(chr(27)+'[H')
    sys.stdout.flush()

if __name__ == '__main__':
    ser = make_serial()
    old_ram = {}
    while True:
        ram = receive_dump()
        clear_screen()
        print_ram(ram, old_ram)
        old_ram = ram
