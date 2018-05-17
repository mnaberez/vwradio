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

def receive_ram():
    ram = {}
    data = bytearray()
    while True:
        data += ser.read(1)
        sys.stdout.write("\rReceiving header: %r" % data)
        sys.stdout.flush()
        if data[-8:] == b'DUMPRAM:':
            break

    sys.stdout.write(chr(27) + "[2K\rReceiving data...")
    sys.stdout.flush()
    data = ser.read(3072)
    address = 0xf000
    ram = {}
    for d in data:
        ram[address] = d
        address += 1
        if address == 0xf800: # skip reserved area
            address = 0xfb00
    return ram

def ascii_or_dot(b):
    if (b >= 0x20) and (b <= 0x7e):  # printable 7-bit ascii
        return chr(b)
    return '.'

def highlighted(s):
    return chr(27) + '[45m' + chr(27) + '[1m' + s + chr(27) + '[0m'

def print_ram(ram, old_ram):
    base_address = 0xf000
    chunk_size = 64

    while base_address < 0xfeff:
        if base_address == 0xf800: # skip reserved area
            base_address = 0xfb00

        hexdump = ""
        chrdump = ""
        for address in range(base_address, base_address+chunk_size):
            b = ram[address]
            old_b = old_ram.get(address, b)
            if b == old_b:
                hexdump += "%02x" % b + " "
                chrdump += ascii_or_dot(b)
            else:
                hexdump += highlighted("%02x" % b) + " "
                chrdump += highlighted(ascii_or_dot(b))

        sys.stdout.write("%04X-%04X: %s%s" % (base_address, base_address+chunk_size-1, hexdump, chrdump))
        sys.stdout.write("\n")
        sys.stdout.flush()

        base_address += chunk_size

def clear_screen():
    sys.stdout.write(chr(27)+'[2J')
    sys.stdout.write(chr(27)+'[H')
    sys.stdout.flush()

if __name__ == '__main__':
    ser = make_serial()
    old_ram = {}
    while True:
        ram = receive_ram()
        clear_screen()
        print_ram(ram, old_ram)
        old_ram = ram
