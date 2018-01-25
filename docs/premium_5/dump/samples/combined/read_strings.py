import sys
from collections import OrderedDict

def read_fixed_length_msgs(f, addresses_and_sizes):
    msgs = OrderedDict()
    for address, size in addresses_and_sizes.items():
        f.seek(address)
        msgs[address] = f.read(size).decode('utf-8')
    return msgs

def read_variable_length_msgs(f, start, stop, fixes=None):
    if fixes is None:
        fixes = {} # address: size
    msgs = OrderedDict()
    f.seek(start)
    assert f.tell() == start
    while 1:
        address = f.tell()

        if address >= stop:
            break

        c = f.read(1)
        if address in fixes:
            size = fixes[address]
        else:
            size = bytearray(c)[0]
        data = f.read(size)
        msgs[address] = data.decode('utf-8')
    return msgs

def print_msgs(msgs):
    column = 0
    for address, msg in msgs.items():
        s = ('%04x: %r' % (address, msg)).ljust(25)
        sys.stdout.write(s)
        column += 1
        if column == 4:
            sys.stdout.write('\n')
            column = 0
    sys.stdout.write('\n')

def main():
    print('')
    with open('combined.bin', 'rb') as f:
        msgs = read_fixed_length_msgs(f, {0x2655: 12, 0x2662: 12,
                                          0x266f: 12, 0x267c: 12,
                                          0x2689: 11, 0x2696: 32})
        print_msgs(msgs)
        print('')

        msgs = read_variable_length_msgs(f, start=0x63ac, stop=0x6535,
                                            fixes={0x6743: 12, 0x63be: 12})
        print_msgs(msgs)
        print('')

        msgs = read_variable_length_msgs(f, start=0x6587, stop=0x67be,
                                            fixes={0x674e: 13})
        print_msgs(msgs)
    print('')

if __name__ == '__main__':
    main()
