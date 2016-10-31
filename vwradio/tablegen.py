from vwradio.constants import Keys
from vwradio.faceplates import (
    Premium4,
    Premium5,
    )

def _print_key_decode_table_for_avr_c(keys):
    '''table of upd16432b key data -> our arbitrary key codes'''
    for bytenum in range(4):
        print('    // byte %d' % bytenum)
        for bitnum in range(8):
            keyval = keys.get((bytenum, bitnum), Keys.NONE)
            line = "    KEY_%s, " % Keys.get_name(keyval)
            line = line.ljust(22, ' ')
            line += '// byte %d, bit %d' % (bytenum, bitnum)
            print(line)

def _print_key_encode_table_for_avr_c(keys):
    '''table of our arbitrary key codes -> upd16432b key data'''
    for keycode in range(256):
        name = Keys.get_name(keycode)
        if name is None:
            name = ''
        else:
            name = 'KEY_%s' % name

        bytenum_bitnum = None
        for k, v in keys.items():
            if v == keycode:
                bytenum_bitnum = k
                break

        if bytenum_bitnum is None:
            line = "    {   0,    0,    0,    0}, // 0x%02x %s" % (
                keycode,
                name,
                )
        else:
            bytenum, bitnum = bytenum_bitnum
            key_data = [0, 0, 0, 0]
            key_data[bytenum] |= 1<<bitnum
            line = "    {0x%02x, 0x%02x, 0x%02x, 0x%02x}, // 0x%02x %s" % (
                key_data[0], key_data[1], key_data[2], key_data[3],
                keycode,
                name,
                )
            line = line.replace("0x00", "   0")
        print(line)


if __name__ == '__main__':
    print("// Premium 4 Key Decoding Table")
    _print_key_encode_table_for_avr_c(Premium4.KEYS)
    print("// Premium 4 Key Encoding Table")
    _print_key_decode_table_for_avr_c(Premium4.KEYS)
    print("// Premium 5 Key Decoding Table")
    _print_key_encode_table_for_avr_c(Premium5.KEYS)
    print("// Premium 5 Key Encoding Table")
    _print_key_decode_table_for_avr_c(Premium5.KEYS)
