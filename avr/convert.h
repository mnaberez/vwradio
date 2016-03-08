#ifndef CONVERT_H
#define CONVERT_H

#include <avr/pgmspace.h>

#define KEY_NONE 0
#define KEY_PRESET_1 1
#define KEY_PRESET_2 2
#define KEY_PRESET_3 3
#define KEY_PRESET_4 4
#define KEY_PRESET_5 5
#define KEY_PRESET_6 6
#define KEY_POWER 7
#define KEY_SOUND_BASS 10
#define KEY_SOUND_TREB 11
#define KEY_SOUND_FADE 12
#define KEY_SOUND_BAL 13
#define KEY_SOUND_MID 14
#define KEY_SOUND_FB 15
#define KEY_TUNE_UP 20
#define KEY_TUNE_DOWN 21
#define KEY_SEEK_UP 22
#define KEY_SEEK_DOWN 23
#define KEY_SCAN 24
#define KEY_MODE_CD 30
#define KEY_MODE_AM 31
#define KEY_MODE_FM 32
#define KEY_MODE_TAPE 33
#define KEY_TAPE_SIDE 40
#define KEY_STOP_EJECT 41
#define KEY_MIX_DOLBY 42

uint8_t convert_upd_key_data_to_codes(uint8_t *key_data_in, uint8_t *key_codes_out);
uint8_t convert_code_to_upd_key_data(uint8_t key_code, uint8_t *key_data_out);

#endif
