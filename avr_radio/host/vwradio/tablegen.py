from vwradio.constants import (
    Keys,
    Pictographs,
    )
from vwradio.faceplates import (
    Premium4,
    Premium5,
    )

# Pictographs ================================================================

def print_pictograph_decode_table_for_avr_c(keys):
    '''table of upd16432b pictograph data -> our arbitrary pictograph codes'''
    for bytenum in range(8):
        print('    // byte %d' % bytenum)
        print('    {')
        for bitnum in range(8):
            keyval = keys.get((bytenum, bitnum), Pictographs.NONE)
            line = "    PICT_%s, " % Pictographs.get_name(keyval)
            line = line.ljust(28, ' ')
            line += '// byte %d, bit %d' % (bytenum, bitnum)
            print(line)
        print('    },')

def print_pictograph_encode_table_for_avr_c(keys):
    '''table of our arbitrary pictograph codes -> upd16432b pictograph data'''
    for pictcode in range(256):
        name = Pictographs.get_name(pictcode)
        if name is None:
            name = ''
        else:
            name = 'PICT_%s' % name

        bytenum_bitnum = None
        for k, v in keys.items():
            if v == pictcode:
                bytenum_bitnum = k
                break

        if bytenum_bitnum is None:
            line = "    {   0,    0,    0,    0,    0,    0,    0,    0}, // 0x%02x %s" % (
                pictcode,
                name,
                )
        else:
            bytenum, bitnum = bytenum_bitnum
            pict_data = [0, 0, 0, 0, 0, 0, 0, 0]
            pict_data[bytenum] |= 1<<bitnum
            line = "    {0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x, 0x%02x}, // 0x%02x %s" % (
                pict_data[0], pict_data[1], pict_data[2], pict_data[3],
                pict_data[4], pict_data[5], pict_data[6], pict_data[7],
                pictcode,
                name,
                )
            line = line.replace("0x00", "   0")
        print(line)

# Keys =======================================================================

def print_key_decode_table_for_avr_c(keys):
    '''table of upd16432b key data -> our arbitrary key codes'''
    for bytenum in range(4):
        print('    // byte %d' % bytenum)
        for bitnum in range(8):
            keyval = keys.get((bytenum, bitnum), Keys.NONE)
            line = "    KEY_%s, " % Keys.get_name(keyval)
            line = line.ljust(22, ' ')
            line += '// byte %d, bit %d' % (bytenum, bitnum)
            print(line)

def print_key_encode_table_for_avr_c(keys):
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
    # Pictographs
    print("// Premium 4 Pictograph Decoding Table")
    print_pictograph_decode_table_for_avr_c(Premium4.PICTOGRAPHS)
    print("// Premium 4 Pictograph Encoding Table")
    print_pictograph_encode_table_for_avr_c(Premium4.PICTOGRAPHS)
    print("// Premium 5 Pictograph Decoding Table")
    print_pictograph_decode_table_for_avr_c(Premium5.PICTOGRAPHS)
    print("// Premium 5 Pictograph Encoding Table")
    print_pictograph_encode_table_for_avr_c(Premium5.PICTOGRAPHS)
    # Keys
    print("// Premium 4 Key Decoding Table")
    print_key_encode_table_for_avr_c(Premium4.KEYS)
    print("// Premium 4 Key Encoding Table")
    print_key_decode_table_for_avr_c(Premium4.KEYS)
    print("// Premium 5 Key Decoding Table")
    print_key_encode_table_for_avr_c(Premium5.KEYS)
    print("// Premium 5 Key Encoding Table")
    print_key_decode_table_for_avr_c(Premium5.KEYS)
