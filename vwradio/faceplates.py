import string
from vwradio import charsets
from vwradio.constants import Keys, Pictographs


class Faceplate(object):
    '''Abstract'''
    # uPD16432B display RAM addresses visible on screen in left-to-right order
    VISIBLE_DISPLAY_ADDRESSES = ()
    # uPD16432B character generator ROM contents (1792 bytes)
    ROM_CHARSET = ()
    # uPD16432B byte as key, equiv ASCII char as value
    CHARACTERS = {}
    # uPD16432B byte/bit as key, Pictographs.* as value
    PICTOGRAPHS = {}
    # uPD16432B byte/bit as key, Keys.* as value
    KEYS = {}

    def encode_keys(self, keys_pressed):
        '''Encode a list of keys (Keys.* constants) to four bytes of
        uPD16432B key scan data.  Encode an empty list for no keys pressed.'''
        key_data = [0, 0, 0, 0]
        for key_pressed in keys_pressed:
            found = False
            for byte_bit, key in self.KEYS.items():
                if key == key_pressed:
                    bytenum, bitnum = byte_bit
                    key_data[bytenum] |= (2**bitnum)
                    found = True
                    break
            if not found:
                raise ValueError('Key %d not found' % key_pressed)
        return tuple(key_data)

    def decode_keys(self, key_data, as_names=False):
        '''Decode four bytes of uPD16432B key scan data to a list of
        keys (Keys.*) pressed, or an empty list if nothing pressed'''
        keys = []
        for bytenum, byte in enumerate(key_data):
            for bitnum in range(8):
                if byte & (2**bitnum):
                    key = self.KEYS.get((bytenum, bitnum))
                    if key is None:
                        msg = 'Unrecognized key at byte %d, bit %d'
                        raise ValueError(msg % (bytenum, bitnum))
                    keys.append(key)
        return keys

    def get_key_name(self, key):
        '''Get the string name of a key from a Keys.* constant'''
        return Keys.get_name(key)

    def decode_pictographs(self, pictograph_data):
        '''Decode eight bytes of uPD16432B pictograph data to a list of
        pictographs (Pictographs.*) displayed, or an empty list if none.'''
        pictographs = []
        for bytenum, byte in enumerate(pictograph_data):
            for bitnum in range(8):
                if byte & (2**bitnum):
                    pictograph = self.PICTOGRAPHS.get((bytenum, bitnum))
                    if pictograph is None:
                        msg = 'Unrecognized pictograph at byte %d, bit %d'
                        raise ValueError(msg % (bytenum, bitnum))
                    pictographs.append(pictograph)
        return pictographs

    def get_pictograph_name(self, pictograph):
        '''Get the string name of a pictograph from a Pictographs.* constant'''
        return Pictographs.get_name(pictograph)

    def char_code(self, char):
        '''Convert a character ("a") to its closest equivalent byte for the
        uPD16432B display (65)'''
        if char in string.digits:
            return ord(char)
        for key, value in self.CHARACTERS.items():
            if value == char:
                return key
        return ord(char)


class Premium4(Faceplate):
    VISIBLE_DISPLAY_ADDRESSES = tuple(range(0x0c, 1, -1))
    ROM_CHARSET = charsets.VW_PREMIUM_4
    CHARACTERS = {
        0x10: " ",
        0x11: " ",
        0x12: " ",
        0x13: " ",
        0x14: " ",
        0x15: " ",
        0x16: " ",
        0x17: " ",
        0x18: " ",
        0x19: " ",
        0x1a: " ",
        0x1b: " ",
        0x1c: " ",
        0x1d: " ",
        0x1e: " ",
        0x1f: " ",
        0x20: " ",
        0x21: "!",
        0x22: '"',
        0x23: "#",
        0x24: "$",
        0x25: "%",
        0x26: "&",
        0x27: "'",
        0x28: "(",
        0x29: ")",
        0x2a: "*",
        0x2b: "+",
        0x2c: ",",
        0x2d: "-",
        0x2e: ".",
        0x2f: "/",
        0x30: "0",
        0x31: "1",
        0x32: "2",
        0x33: "3",
        0x34: "4",
        0x35: "5",
        0x36: "6",
        0x37: "7",
        0x38: "8",
        0x39: "9",
        0x3a: ":",
        0x3b: ";",
        0x3c: "<",
        0x3d: "=",
        0x3e: ">",
        0x3f: "?",
        0x40: "@",
        0x41: "A",
        0x42: "B",
        0x43: "C",
        0x44: "D",
        0x45: "E",
        0x46: "F",
        0x47: "G",
        0x48: "H",
        0x49: "I",
        0x4a: "J",
        0x4b: "K",
        0x4c: "L",
        0x4d: "M",
        0x4e: "N",
        0x4f: "O",
        0x50: "P",
        0x51: "Q",
        0x52: "R",
        0x53: "S",
        0x54: "T",
        0x55: "U",
        0x56: "V",
        0x57: "W",
        0x58: "X",
        0x59: "Y",
        0x5a: "Z",
        0x5b: "[",
        0x5c: "\\",
        0x5d: "]",
        0x5e: "^",
        0x5f: "_",
        0x60: "`",
        0x61: "a",
        0x62: "b",
        0x63: "c",
        0x64: "d",
        0x65: "e",
        0x66: "f",
        0x67: "g",
        0x68: "h",
        0x69: "i",
        0x6a: "j",
        0x6b: "k",
        0x6c: "l",
        0x6d: "m",
        0x6e: "n",
        0x6f: "o",
        0x70: "p",
        0x71: "q",
        0x72: "r",
        0x73: "s",
        0x74: "t",
        0x75: "u",
        0x76: "v",
        0x77: "w",
        0x78: "x",
        0x79: "y",
        0x7a: "z",
        0x7b: "{",
        0x7c: "|",
        0x7d: "}",
        0x7e: "~",
        0xe0: "A",
        0xe1: "B",
        0xe2: "N",
        0xe3: "V",
        0xe4: "0",
        0xe5: "1",
        0xe6: "3",
        0xe7: "4",
        0xe8: "5",
        0xe9: "6",
        0xea: "9",
        0xeb: "1", # for FM1
        0xec: "2", # for FM2
        0xed: "2", # for preset 2
        0xee: "3", # for preset 3
        0xef: "4", # for preset 4
        0xf0: "5", # for preset 5
        0xf1: "6",
        0xf2: "6", # for preset 6
        0xf3: "2",
        0xf4: " ",
        0xf5: " ",
        0xf6: " ",
        0xf7: " ",
        0xf8: " ",
        0xf9: " ",
        0xfa: " ",
        0xfb: " ",
        }

    PICTOGRAPHS = {
        # (byte, bit)
        (7, 3): Pictographs.TAPE_METAL,
        (6, 5): Pictographs.TAPE_DOLBY,
        (6, 0): Pictographs.MIX,
        (3, 6): Pictographs.PERIOD,
        (2, 3): Pictographs.HIDDEN_MODE_AMFM,
        (1, 0): Pictographs.HIDDEN_MODE_CD,
        (1, 5): Pictographs.HIDDEN_MODE_TAPE,
        }

    KEYS = {
        # (byte, bit)
        (3, 7): Keys.HIDDEN_NO_CODE,
        (3, 6): Keys.HIDDEN_INITIAL,

        (3, 3): Keys.HIDDEN_VOL_DOWN,
        (3, 2): Keys.HIDDEN_VOL_UP,
        (3, 1): Keys.HIDDEN_SEEK_DOWN,
        (3, 0): Keys.HIDDEN_SEEK_UP,
        (2, 7): Keys.BEETLE_TAPE_REW,   # Beetle only
        (2, 6): Keys.BEETLE_TAPE_FF,    # Beetle only
        (2, 5): Keys.TAPE_SIDE,         # "PROG" on Beetle, same function
        (2, 4): Keys.SEEK_UP,
        (2, 3): Keys.MIX_DOLBY,         # "MIX" on Beetle
        (2, 2): Keys.BEETLE_DOLBY,      # Beetle only
        (2, 1): Keys.SCAN,
        (2, 0): Keys.SEEK_DOWN,
        (1, 7): Keys.MODE_FM,
        (1, 6): Keys.MODE_AM,
        (1, 5): Keys.TUNE_UP,
        (1, 4): Keys.SOUND_BAL,
        (1, 3): Keys.MODE_CD,
        (1, 2): Keys.MODE_TAPE,
        (1, 1): Keys.TUNE_DOWN,
        (1, 0): Keys.SOUND_FADE,
        (0, 7): Keys.PRESET_6,
        (0, 6): Keys.PRESET_5,
        (0, 5): Keys.PRESET_4,
        (0, 4): Keys.SOUND_BASS,
        (0, 3): Keys.PRESET_3,
        (0, 2): Keys.PRESET_2,
        (0, 1): Keys.PRESET_1,
        (0, 0): Keys.SOUND_TREB
        }


class Premium5(Faceplate):
    VISIBLE_DISPLAY_ADDRESSES = tuple(range(11))
    ROM_CHARSET = charsets.VW_PREMIUM_5

    KEYS = {
        # (byte, bit)
        (3, 7): Keys.MODE_AM,
        (3, 6): Keys.PRESET_6,
        (3, 5): Keys.PRESET_5,
        (3, 4): Keys.PRESET_4,
        (3, 3): Keys.SCAN,
        (3, 2): Keys.TUNE_DOWN,
        (3, 1): Keys.TUNE_UP,
        (3, 0): Keys.MIX_DOLBY,
        (2, 7): Keys.MODE_FM,
        (2, 6): Keys.SEEK_UP,
        (2, 5): Keys.SEEK_DOWN,
        (2, 3): Keys.MODE_CD,
        (2, 2): Keys.PRESET_1,
        (2, 1): Keys.PRESET_2,
        (2, 0): Keys.PRESET_3,
        (1, 7): Keys.SOUND_TREB,
        (1, 6): Keys.SOUND_MID,
        (1, 5): Keys.SOUND_BASS,
        (1, 4): Keys.SOUND_FB,
        (1, 3): Keys.MODE_TAPE,
        (1, 0): Keys.TAPE_SIDE,
        }

    PICTOGRAPHS = {
        # (byte, bit)
        (5, 1): Pictographs.MIX,
        (4, 5): Pictographs.PERIOD,
        (2, 7): Pictographs.TAPE_METAL,
        (1, 2): Pictographs.TAPE_DOLBY,
        }

    CHARACTERS = {
        0x20: " ",
        0x2b: "+",
        0x2d: "-",
        0x30: "0",
        0x31: "1",
        0x32: "2",
        0x33: "3",
        0x34: "4",
        0x35: "5",
        0x36: "6",
        0x37: "7",
        0x38: "8",
        0x39: "9",
        0x41: "A",
        0x42: "B",
        0x43: "C",
        0x44: "D",
        0x45: "E",
        0x46: "F",
        0x47: "G",
        0x48: "H",
        0x49: "I",
        0x4b: "K",
        0x4c: "L",
        0x4d: "M",
        0x4e: "N",
        0x4f: "O",
        0x50: "P",
        0x52: "R",
        0x53: "S",
        0x54: "T",
        0x55: "U",
        0x56: "V",
        0x57: "W",
        0x58: "X",
        0x59: "Y",
        0x5a: "Z",
        0x65: "e",
        0x6b: "k",
        0x72: "r",
        0x73: "s",
        0x7a: "z",
        }
