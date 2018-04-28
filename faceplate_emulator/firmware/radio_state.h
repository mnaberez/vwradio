#ifndef RADIO_STATE_H
#define RADIO_STATE_H

#include "updemu.h"

#define OPERATION_MODE_UNKNOWN 0
#define OPERATION_MODE_SAFE_ENTRY 10
#define OPERATION_MODE_SAFE_LOCKED 11
#define OPERATION_MODE_SAFE_NO_CODE 12
#define OPERATION_MODE_TUNER_PLAYING 20
#define OPERATION_MODE_TUNER_SCANNING 21
#define OPERATION_MODE_CD_PLAYING 30
#define OPERATION_MODE_CD_CUE 31
#define OPERATION_MODE_CD_REV 32
#define OPERATION_MODE_CD_NO_DISC 33
#define OPERATION_MODE_CD_NO_CHANGER 34
#define OPERATION_MODE_CD_NO_MAGAZINE 35
#define OPERATION_MODE_CD_CHECK_MAGAZINE 36
#define OPERATION_MODE_CD_CDX_NO_CD 37
#define OPERATION_MODE_CD_CDX_CD_ERR 38
#define OPERATION_MODE_CD_SCANNING 39
#define OPERATION_MODE_TAPE_PLAYING 40
#define OPERATION_MODE_TAPE_LOAD 41
#define OPERATION_MODE_TAPE_METAL 42
#define OPERATION_MODE_TAPE_FF 43
#define OPERATION_MODE_TAPE_REW 44
#define OPERATION_MODE_TAPE_MSS_FF 45
#define OPERATION_MODE_TAPE_MSS_REW 46
#define OPERATION_MODE_TAPE_NO_TAPE 47
#define OPERATION_MODE_TAPE_ERROR 48
#define OPERATION_MODE_TAPE_SCANNING 49
#define OPERATION_MODE_TAPE_BLS 50
#define OPERATION_MODE_INITIALIZING 60
#define OPERATION_MODE_DIAGNOSTICS 70
#define OPERATION_MODE_MONSOON 80
#define OPERATION_MODE_SETTING_ON_VOL 90
#define OPERATION_MODE_SETTING_CD_MIX 91
#define OPERATION_MODE_SETTING_TAPE_SKIP 92
#define OPERATION_MODE_TESTING_FERN 100
#define OPERATION_MODE_TESTING_RAD 101
#define OPERATION_MODE_TESTING_VER 102
#define OPERATION_MODE_TESTING_SIGNAL 103

#define DISPLAY_MODE_UNKNOWN 0
#define DISPLAY_MODE_SHOWING_OPERATION 10
#define DISPLAY_MODE_ADJUSTING_SOUND_VOLUME 20
#define DISPLAY_MODE_ADJUSTING_SOUND_BALANCE 21
#define DISPLAY_MODE_ADJUSTING_SOUND_FADE 22
#define DISPLAY_MODE_ADJUSTING_SOUND_BASS 23
#define DISPLAY_MODE_ADJUSTING_SOUND_TREBLE 24
#define DISPLAY_MODE_ADJUSTING_SOUND_MIDRANGE 25

#define TUNER_BAND_UNKNOWN 0
#define TUNER_BAND_FM1 1
#define TUNER_BAND_FM2 2
#define TUNER_BAND_AM 3

typedef struct
{
    uint8_t display[11];
    uint8_t operation_mode;
    uint8_t display_mode;
    uint8_t safe_tries;
    uint16_t safe_code;
    int8_t sound_bass; // -9 to 9
    int8_t sound_treble; // -9 to 9
    int8_t sound_midrange; // Premium 5 only, -9 to 9
    int8_t sound_balance; // right -9, center 0, left +9
    int8_t sound_fade; // rear -9, center 0, front +9
    uint8_t tape_side; // 0=none, 1=side a, 2=side b
    uint8_t cd_disc;
    uint8_t cd_track;
    uint16_t cd_track_pos;
    uint16_t tuner_freq;
    uint8_t tuner_preset;
    uint8_t tuner_band;
    uint8_t option_on_vol;
    uint8_t option_cd_mix;
    uint8_t option_tape_skip;
    uint8_t test_fern;
    uint8_t test_rad[7];
    uint8_t test_ver[7];
    uint16_t test_signal_freq; // Premium 5 only, 977=97.7 Mhz, 540=540 KHz
    uint16_t test_signal_strength; // Premium 5 only, 0 to 0xFFFF
} radio_state_t;
radio_state_t radio_state;

void radio_state_init(radio_state_t *state);
void radio_state_parse(radio_state_t *state, uint8_t *ram);
void radio_state_update_from_upd_if_dirty(radio_state_t *radio_state, upd_state_t *upd_state);

#endif
