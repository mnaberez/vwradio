#include "convert.h"

// decode: upd16432b key data -> our arbitrary key codes
static const uint8_t _premium4_key_decode[4][8] PROGMEM = {
    {
        KEY_SOUND_TREB,   // byte 0, bit 0
        KEY_PRESET_1,     // byte 0, bit 1
        KEY_PRESET_2,     // byte 0, bit 2
        KEY_PRESET_3,     // byte 0, bit 3
        KEY_SOUND_BASS,   // byte 0, bit 4
        KEY_PRESET_4,     // byte 0, bit 5
        KEY_PRESET_5,     // byte 0, bit 6
        KEY_PRESET_6,     // byte 0, bit 7
    },
    {
        KEY_SOUND_FADE,   // byte 1, bit 0
        KEY_TUNE_DOWN,    // byte 1, bit 1
        KEY_MODE_TAPE,    // byte 1, bit 2
        KEY_MODE_CD,      // byte 1, bit 3
        KEY_SOUND_BAL,    // byte 1, bit 4
        KEY_TUNE_UP,      // byte 1, bit 5
        KEY_MODE_AM,      // byte 1, bit 6
        KEY_MODE_FM,      // byte 1, bit 7
    },
    {
        KEY_SEEK_DOWN,    // byte 2, bit 0
        KEY_SCAN,         // byte 2, bit 1
        KEY_NONE,         // byte 2, bit 2
        KEY_MIX_DOLBY,    // byte 2, bit 3
        KEY_SEEK_UP,      // byte 2, bit 4
        KEY_TAPE_SIDE,    // byte 2, bit 5
        KEY_NONE,         // byte 2, bit 6
        KEY_NONE,         // byte 2, bit 7
    },
    {
        KEY_HIDDEN_SEEK_UP,   // byte 3, bit 0
        KEY_HIDDEN_SEEK_DOWN, // byte 3, bit 1
        KEY_HIDDEN_VOL_UP,    // byte 3, bit 2
        KEY_HIDDEN_VOL_DOWN,  // byte 3, bit 3
        KEY_NONE,             // byte 3, bit 4
        KEY_NONE,             // byte 3, bit 5
        KEY_HIDDEN_INITIAL,   // byte 3, bit 6
        KEY_HIDDEN_NO_CODE,   // byte 3, bit 7
    }
};

// encode: our arbitrary key codes -> upd16432b key data
static const uint8_t _premium4_key_encode[256][4] PROGMEM = {
    {   0,    0,    0,    0}, // 0x00
    {0x02, 0x00, 0x00, 0x00}, // 0x01 KEY_PRESET_1
    {0x04, 0x00, 0x00, 0x00}, // 0x02 KEY_PRESET_2
    {0x08, 0x00, 0x00, 0x00}, // 0x03 KEY_PRESET_3
    {0x20, 0x00, 0x00, 0x00}, // 0x04 KEY_PRESET_4
    {0x40, 0x00, 0x00, 0x00}, // 0x05 KEY_PRESET_5
    {0x80, 0x00, 0x00, 0x00}, // 0x06 KEY_PRESET_6
    {   0,    0,    0,    0}, // 0x07
    {   0,    0,    0,    0}, // 0x08
    {   0,    0,    0,    0}, // 0x09
    {0x10, 0x00, 0x00, 0x00}, // 0x0a KEY_SOUND_BASS
    {0x01, 0x00, 0x00, 0x00}, // 0x0b KEY_SOUND_TREB
    {0x00, 0x01, 0x00, 0x00}, // 0x0c KEY_SOUND_FADE
    {0x00, 0x10, 0x00, 0x00}, // 0x0d KEY_SOUND_BAL
    {   0,    0,    0,    0}, // 0x0e
    {   0,    0,    0,    0}, // 0x0f
    {   0,    0,    0,    0}, // 0x10
    {   0,    0,    0,    0}, // 0x11
    {   0,    0,    0,    0}, // 0x12
    {   0,    0,    0,    0}, // 0x13
    {0x00, 0x20, 0x00, 0x00}, // 0x14 KEY_TUNE_UP
    {0x00, 0x02, 0x00, 0x00}, // 0x15 KEY_TUNE_DOWN
    {0x00, 0x00, 0x10, 0x00}, // 0x16 KEY_SEEK_UP
    {0x00, 0x00, 0x01, 0x00}, // 0x17 KEY_SEEK_DOWN
    {0x00, 0x00, 0x02, 0x00}, // 0x18 KEY_SCAN
    {   0,    0,    0,    0}, // 0x19
    {   0,    0,    0,    0}, // 0x1a
    {   0,    0,    0,    0}, // 0x1b
    {   0,    0,    0,    0}, // 0x1c
    {   0,    0,    0,    0}, // 0x1d
    {0x00, 0x08, 0x00, 0x00}, // 0x1e KEY_MODE_CD
    {0x00, 0x40, 0x00, 0x00}, // 0x1f KEY_MODE_AM
    {0x00, 0x80, 0x00, 0x00}, // 0x20 KEY_MODE_FM
    {0x00, 0x04, 0x00, 0x00}, // 0x21 KEY_MODE_TAPE
    {   0,    0,    0,    0}, // 0x22
    {   0,    0,    0,    0}, // 0x23
    {   0,    0,    0,    0}, // 0x24
    {   0,    0,    0,    0}, // 0x25
    {   0,    0,    0,    0}, // 0x26
    {   0,    0,    0,    0}, // 0x27
    {0x00, 0x00, 0x20, 0x00}, // 0x28 KEY_TAPE_SIDE
    {   0,    0,    0,    0}, // 0x29
    {0x00, 0x00, 0x08, 0x00}, // 0x2a KEY_MIX_DOLBY
    {   0,    0,    0,    0}, // 0x2b
    {   0,    0,    0,    0}, // 0x2c
    {   0,    0,    0,    0}, // 0x2d
    {   0,    0,    0,    0}, // 0x2e
    {   0,    0,    0,    0}, // 0x2f
    {   0,    0,    0,    0}, // 0x30
    {   0,    0,    0,    0}, // 0x31
    {0x00, 0x00, 0x00, 0x40}, // 0x32 KEY_HIDDEN_INITIAL
    {0x00, 0x00, 0x00, 0x80}, // 0x33 KEY_HIDDEN_NO_CODE
    {0x00, 0x00, 0x00, 0x04}, // 0x34 KEY_HIDDEN_VOL_UP
    {0x00, 0x00, 0x00, 0x08}, // 0x35 KEY_HIDDEN_VOL_DOWN
    {0x00, 0x00, 0x00, 0x01}, // 0x35 KEY_HIDDEN_SEEK_UP
    {0x00, 0x00, 0x00, 0x02}, // 0x35 KEY_HIDDEN_SEEK_DOWN
    {   0,    0,    0,    0}, // 0x38
    {   0,    0,    0,    0}, // 0x39
    {   0,    0,    0,    0}, // 0x3a
    {   0,    0,    0,    0}, // 0x3b
    {   0,    0,    0,    0}, // 0x3c
    {   0,    0,    0,    0}, // 0x3d
    {   0,    0,    0,    0}, // 0x3e
    {   0,    0,    0,    0}, // 0x3f
    {   0,    0,    0,    0}, // 0x40
    {   0,    0,    0,    0}, // 0x41
    {   0,    0,    0,    0}, // 0x42
    {   0,    0,    0,    0}, // 0x43
    {   0,    0,    0,    0}, // 0x44
    {   0,    0,    0,    0}, // 0x45
    {   0,    0,    0,    0}, // 0x46
    {   0,    0,    0,    0}, // 0x47
    {   0,    0,    0,    0}, // 0x48
    {   0,    0,    0,    0}, // 0x49
    {   0,    0,    0,    0}, // 0x4a
    {   0,    0,    0,    0}, // 0x4b
    {   0,    0,    0,    0}, // 0x4c
    {   0,    0,    0,    0}, // 0x4d
    {   0,    0,    0,    0}, // 0x4e
    {   0,    0,    0,    0}, // 0x4f
    {   0,    0,    0,    0}, // 0x50
    {   0,    0,    0,    0}, // 0x51
    {   0,    0,    0,    0}, // 0x52
    {   0,    0,    0,    0}, // 0x53
    {   0,    0,    0,    0}, // 0x54
    {   0,    0,    0,    0}, // 0x55
    {   0,    0,    0,    0}, // 0x56
    {   0,    0,    0,    0}, // 0x57
    {   0,    0,    0,    0}, // 0x58
    {   0,    0,    0,    0}, // 0x59
    {   0,    0,    0,    0}, // 0x5a
    {   0,    0,    0,    0}, // 0x5b
    {   0,    0,    0,    0}, // 0x5c
    {   0,    0,    0,    0}, // 0x5d
    {   0,    0,    0,    0}, // 0x5e
    {   0,    0,    0,    0}, // 0x5f
    {   0,    0,    0,    0}, // 0x60
    {   0,    0,    0,    0}, // 0x61
    {   0,    0,    0,    0}, // 0x62
    {   0,    0,    0,    0}, // 0x63
    {   0,    0,    0,    0}, // 0x64
    {   0,    0,    0,    0}, // 0x65
    {   0,    0,    0,    0}, // 0x66
    {   0,    0,    0,    0}, // 0x67
    {   0,    0,    0,    0}, // 0x68
    {   0,    0,    0,    0}, // 0x69
    {   0,    0,    0,    0}, // 0x6a
    {   0,    0,    0,    0}, // 0x6b
    {   0,    0,    0,    0}, // 0x6c
    {   0,    0,    0,    0}, // 0x6d
    {   0,    0,    0,    0}, // 0x6e
    {   0,    0,    0,    0}, // 0x6f
    {   0,    0,    0,    0}, // 0x70
    {   0,    0,    0,    0}, // 0x71
    {   0,    0,    0,    0}, // 0x72
    {   0,    0,    0,    0}, // 0x73
    {   0,    0,    0,    0}, // 0x74
    {   0,    0,    0,    0}, // 0x75
    {   0,    0,    0,    0}, // 0x76
    {   0,    0,    0,    0}, // 0x77
    {   0,    0,    0,    0}, // 0x78
    {   0,    0,    0,    0}, // 0x79
    {   0,    0,    0,    0}, // 0x7a
    {   0,    0,    0,    0}, // 0x7b
    {   0,    0,    0,    0}, // 0x7c
    {   0,    0,    0,    0}, // 0x7d
    {   0,    0,    0,    0}, // 0x7e
    {   0,    0,    0,    0}, // 0x7f
    {   0,    0,    0,    0}, // 0x80
    {   0,    0,    0,    0}, // 0x81
    {   0,    0,    0,    0}, // 0x82
    {   0,    0,    0,    0}, // 0x83
    {   0,    0,    0,    0}, // 0x84
    {   0,    0,    0,    0}, // 0x85
    {   0,    0,    0,    0}, // 0x86
    {   0,    0,    0,    0}, // 0x87
    {   0,    0,    0,    0}, // 0x88
    {   0,    0,    0,    0}, // 0x89
    {   0,    0,    0,    0}, // 0x8a
    {   0,    0,    0,    0}, // 0x8b
    {   0,    0,    0,    0}, // 0x8c
    {   0,    0,    0,    0}, // 0x8d
    {   0,    0,    0,    0}, // 0x8e
    {   0,    0,    0,    0}, // 0x8f
    {   0,    0,    0,    0}, // 0x90
    {   0,    0,    0,    0}, // 0x91
    {   0,    0,    0,    0}, // 0x92
    {   0,    0,    0,    0}, // 0x93
    {   0,    0,    0,    0}, // 0x94
    {   0,    0,    0,    0}, // 0x95
    {   0,    0,    0,    0}, // 0x96
    {   0,    0,    0,    0}, // 0x97
    {   0,    0,    0,    0}, // 0x98
    {   0,    0,    0,    0}, // 0x99
    {   0,    0,    0,    0}, // 0x9a
    {   0,    0,    0,    0}, // 0x9b
    {   0,    0,    0,    0}, // 0x9c
    {   0,    0,    0,    0}, // 0x9d
    {   0,    0,    0,    0}, // 0x9e
    {   0,    0,    0,    0}, // 0x9f
    {   0,    0,    0,    0}, // 0xa0
    {   0,    0,    0,    0}, // 0xa1
    {   0,    0,    0,    0}, // 0xa2
    {   0,    0,    0,    0}, // 0xa3
    {   0,    0,    0,    0}, // 0xa4
    {   0,    0,    0,    0}, // 0xa5
    {   0,    0,    0,    0}, // 0xa6
    {   0,    0,    0,    0}, // 0xa7
    {   0,    0,    0,    0}, // 0xa8
    {   0,    0,    0,    0}, // 0xa9
    {   0,    0,    0,    0}, // 0xaa
    {   0,    0,    0,    0}, // 0xab
    {   0,    0,    0,    0}, // 0xac
    {   0,    0,    0,    0}, // 0xad
    {   0,    0,    0,    0}, // 0xae
    {   0,    0,    0,    0}, // 0xaf
    {   0,    0,    0,    0}, // 0xb0
    {   0,    0,    0,    0}, // 0xb1
    {   0,    0,    0,    0}, // 0xb2
    {   0,    0,    0,    0}, // 0xb3
    {   0,    0,    0,    0}, // 0xb4
    {   0,    0,    0,    0}, // 0xb5
    {   0,    0,    0,    0}, // 0xb6
    {   0,    0,    0,    0}, // 0xb7
    {   0,    0,    0,    0}, // 0xb8
    {   0,    0,    0,    0}, // 0xb9
    {   0,    0,    0,    0}, // 0xba
    {   0,    0,    0,    0}, // 0xbb
    {   0,    0,    0,    0}, // 0xbc
    {   0,    0,    0,    0}, // 0xbd
    {   0,    0,    0,    0}, // 0xbe
    {   0,    0,    0,    0}, // 0xbf
    {   0,    0,    0,    0}, // 0xc0
    {   0,    0,    0,    0}, // 0xc1
    {   0,    0,    0,    0}, // 0xc2
    {   0,    0,    0,    0}, // 0xc3
    {   0,    0,    0,    0}, // 0xc4
    {   0,    0,    0,    0}, // 0xc5
    {   0,    0,    0,    0}, // 0xc6
    {   0,    0,    0,    0}, // 0xc7
    {   0,    0,    0,    0}, // 0xc8
    {   0,    0,    0,    0}, // 0xc9
    {   0,    0,    0,    0}, // 0xca
    {   0,    0,    0,    0}, // 0xcb
    {   0,    0,    0,    0}, // 0xcc
    {   0,    0,    0,    0}, // 0xcd
    {   0,    0,    0,    0}, // 0xce
    {   0,    0,    0,    0}, // 0xcf
    {   0,    0,    0,    0}, // 0xd0
    {   0,    0,    0,    0}, // 0xd1
    {   0,    0,    0,    0}, // 0xd2
    {   0,    0,    0,    0}, // 0xd3
    {   0,    0,    0,    0}, // 0xd4
    {   0,    0,    0,    0}, // 0xd5
    {   0,    0,    0,    0}, // 0xd6
    {   0,    0,    0,    0}, // 0xd7
    {   0,    0,    0,    0}, // 0xd8
    {   0,    0,    0,    0}, // 0xd9
    {   0,    0,    0,    0}, // 0xda
    {   0,    0,    0,    0}, // 0xdb
    {   0,    0,    0,    0}, // 0xdc
    {   0,    0,    0,    0}, // 0xdd
    {   0,    0,    0,    0}, // 0xde
    {   0,    0,    0,    0}, // 0xdf
    {   0,    0,    0,    0}, // 0xe0
    {   0,    0,    0,    0}, // 0xe1
    {   0,    0,    0,    0}, // 0xe2
    {   0,    0,    0,    0}, // 0xe3
    {   0,    0,    0,    0}, // 0xe4
    {   0,    0,    0,    0}, // 0xe5
    {   0,    0,    0,    0}, // 0xe6
    {   0,    0,    0,    0}, // 0xe7
    {   0,    0,    0,    0}, // 0xe8
    {   0,    0,    0,    0}, // 0xe9
    {   0,    0,    0,    0}, // 0xea
    {   0,    0,    0,    0}, // 0xeb
    {   0,    0,    0,    0}, // 0xec
    {   0,    0,    0,    0}, // 0xed
    {   0,    0,    0,    0}, // 0xee
    {   0,    0,    0,    0}, // 0xef
    {   0,    0,    0,    0}, // 0xf0
    {   0,    0,    0,    0}, // 0xf1
    {   0,    0,    0,    0}, // 0xf2
    {   0,    0,    0,    0}, // 0xf3
    {   0,    0,    0,    0}, // 0xf4
    {   0,    0,    0,    0}, // 0xf5
    {   0,    0,    0,    0}, // 0xf6
    {   0,    0,    0,    0}, // 0xf7
    {   0,    0,    0,    0}, // 0xf8
    {   0,    0,    0,    0}, // 0xf9
    {   0,    0,    0,    0}, // 0xfa
    {   0,    0,    0,    0}, // 0xfb
    {   0,    0,    0,    0}, // 0xfc
    {   0,    0,    0,    0}, // 0xfd
    {   0,    0,    0,    0}, // 0xfe
};

/* Convert uPD16432B key data to key codes (the KEY_ constants)
 * key_data_in: array of 4 bytes from uPD16432B
 * key_codes_out: array of 2 bytes for key codes
 * Returns the number keys pressed: 0, 1, or 2
 */
uint8_t convert_upd_key_data_to_codes(
    uint8_t *key_data_in, uint8_t *key_codes_out)
{
    key_codes_out[0] = 0;
    key_codes_out[1] = 0;
    uint8_t num_keys_pressed = 0;

    for (uint8_t bytenum=0; bytenum<4; bytenum++)
    {
        if (key_data_in[bytenum] == 0)
        {
            continue;
        }

        for (uint8_t bitnum=0; bitnum<8; bitnum++)
        {
            if (key_data_in[bytenum] & (1<<bitnum))
            {
                uint8_t key_code = pgm_read_byte(
                    &(_premium4_key_decode[bytenum][bitnum])
                    );

                if ((key_code != KEY_NONE) && (num_keys_pressed < 2))
                {
                    key_codes_out[num_keys_pressed++] = key_code;
                }
            }
        }
    }

    return num_keys_pressed;
}

/* TODO document me
 */
uint8_t convert_code_to_upd_key_data(uint8_t key_code, uint8_t *key_data_out)
{
    key_data_out[0] = pgm_read_byte(&_premium4_key_encode[key_code][0]);
    key_data_out[1] = pgm_read_byte(&_premium4_key_encode[key_code][1]);
    key_data_out[2] = pgm_read_byte(&_premium4_key_encode[key_code][2]);
    key_data_out[3] = pgm_read_byte(&_premium4_key_encode[key_code][3]);

    if (key_data_out[0] | key_data_out[1] | key_data_out[2] | key_data_out[3])
    {
        return 1; // success
    }
    else
    {
        return 0; // failure: key code not found
    }
}
