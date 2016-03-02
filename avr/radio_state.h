#ifndef RADIO_STATE_H
#define RADIO_STATE_H

#include "updemu.h"

#define OPERATION_MODE_UNKNOWN 0
#define OPERATION_MODE_SAFE_ENTRY 10
#define OPERATION_MODE_SAFE_LOCKED 11
#define OPERATION_MODE_TUNER_PLAYING 20
#define OPERATION_MODE_TUNER_SCANNING 21
#define OPERATION_MODE_CD_PLAYING 30
#define OPERATION_MODE_CD_CUEING 31
#define OPERATION_MODE_CD_NO_DISC 32
#define OPERATION_MODE_CD_NO_CHANGER 33
#define OPERATION_MODE_CD_CHECK_MAGAZINE 34
#define OPERATION_MODE_CD_CDX_NO_CD 35
#define OPERATION_MODE_CD_CDX_CD_ERR 36
#define OPERATION_MODE_TAPE_PLAYING 40
#define OPERATION_MODE_TAPE_LOAD 41
#define OPERATION_MODE_TAPE_METAL 42
#define OPERATION_MODE_TAPE_FF 43
#define OPERATION_MODE_TAPE_REW 44
#define OPERATION_MODE_TAPE_MSS_FF 45
#define OPERATION_MODE_TAPE_MSS_REW 46
#define OPERATION_MODE_TAPE_NO_TAPE 47
#define OPERATION_MODE_TAPE_ERROR 48

#define DISPLAY_MODE_UNKNOWN 0
#define DISPLAY_MODE_SHOWING_OPERATION 10
#define DISPLAY_MODE_ADJUSTING_VOLUME 20
#define DISPLAY_MODE_ADJUSTING_BALANCE 21
#define DISPLAY_MODE_ADJUSTING_FADE 22
#define DISPLAY_MODE_ADJUSTING_BASS 23
#define DISPLAY_MODE_ADJUSTING_TREBLE 24
#define DISPLAY_MODE_ADJUSTING_MIDRANGE 25

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
    int8_t sound_midrange; // -9 to 9, Premium 5 only
    int8_t sound_balance; // right -9, center 0, left +9
    int8_t sound_fade; // rear -9, center 0, front +9
    uint8_t tape_side; // 0=none, 1=side a, 2=side b
    uint8_t cd_disc;
    uint8_t cd_track;
    uint16_t cd_cue_pos;
    uint16_t tuner_freq;
    uint8_t tuner_preset;
    uint8_t tuner_band;
} radio_state_t;
radio_state_t radio_state;

void radio_state_init(radio_state_t *state);
void radio_state_process(radio_state_t *state, uint8_t *ram);
void radio_state_update_from_upd_if_dirty(radio_state_t *radio_state, upd_state_t *upd_state);

#endif
