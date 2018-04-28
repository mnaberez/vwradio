#include "main.h"
#include "radio_state.h"
#include "updemu.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <avr/io.h>

/*************************************************************************
 * Radio State
 *************************************************************************/

static void _parse_unknown(radio_state_t *state, uint8_t *display)
{
    // unknown displays are ignored
}

static void _parse_sound_volume(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_VOLUME;
}

static void _parse_sound_bass(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_BASS;

    if (isdigit(display[8]))
    {
        state->sound_bass = display[8] & 0x0F;
        if (display[6] == '-')
        {
            state->sound_bass = state->sound_bass * -1;
        }
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_sound_treble(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_TREBLE;

    if (isdigit(display[8]))
    {
        state->sound_treble = display[8] & 0x0F;
        if (display[6] == '-')
        {
            state->sound_treble = state->sound_treble * -1;
        }
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_midrange(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_MIDRANGE;

    if (isdigit(display[8]))
    {
        state->sound_midrange = display[8] & 0x0F;
        if (display[6] == '-')
        {
            state->sound_midrange = state->sound_midrange * -1;
        }
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_sound_balance(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_BALANCE;

    if (display[4] == 'C')
    {
        state->sound_balance = 0; // Center
    }
    else if ((display[4] == 'R') && isdigit(display[10]))
    {
        state->sound_balance = display[10] & 0x0F; // Right
    }
    else if ((display[4] == 'L') && isdigit(display[10]))
    {
        state->sound_balance = (display[10] & 0x0F) * -1; // Left
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_sound_fade(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_SOUND_FADE;

    if (display[4] == 'C')
    {
        state->sound_fade = 0; // Center
    }
    else if ((display[4] == 'F') && isdigit(display[10]))
    {
        state->sound_fade = display[10] & 0x0F; // Front
    }
    else if ((display[4] == 'R') && isdigit(display[10]))
    {
        state->sound_fade = (display[10] & 0x0F) * -1; // Rear
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_tape(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if ((memcmp(display, "TAPE PLAY A", 11) == 0) ||
        (memcmp(display, "TAPE PLAY B", 11) == 0))
    {
        state->operation_mode = OPERATION_MODE_TAPE_PLAYING;
        if (display[10] == 'A')
        {
            state->tape_side = 1;
        }
        else // 'B'
        {
            state->tape_side = 2;
        }
    }
    else if ((memcmp(display, "TAPE SCAN A", 11) == 0) ||
        (memcmp(display, "TAPE SCAN B", 11) == 0))
    {
        state->operation_mode = OPERATION_MODE_TAPE_SCANNING;
        if (display[10] == 'A')
        {
            state->tape_side = 1;
        }
        else // 'B'
        {
            state->tape_side = 2;
        }
    }
    else if ((memcmp(display, "TAPE  FF   ", 11) == 0) ||
             (memcmp(display, "TAPE  REW  ", 11) == 0))
    {
        if (memcmp(display+6, "REW", 3) == 0)
        {
            state->operation_mode = OPERATION_MODE_TAPE_REW;
        }
        else // "FF "
        {
            state->operation_mode = OPERATION_MODE_TAPE_FF;
        }
    }
    else if ((memcmp(display, "TAPEMSS FF ", 11) == 0) ||
             (memcmp(display, "TAPEMSS REW", 11) == 0))
    {
        if (memcmp(display+8, "REW", 3) == 0)
        {
            state->operation_mode = OPERATION_MODE_TAPE_MSS_REW;
        }
        else // "FF "
        {
            state->operation_mode = OPERATION_MODE_TAPE_MSS_FF;
        }
    }
    else if (memcmp(display, "TAPE  BLS  ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_BLS;
    }
    else if (memcmp(display, "TAPE METAL ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_METAL;
    }
    else if (memcmp(display, "    NO TAPE", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_NO_TAPE;
        state->tape_side = 0;
    }
    else if (memcmp(display, "TAPE ERROR ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_ERROR;
        state->tape_side = 0;
    }
    else if (memcmp(display, "TAPE LOAD  ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_LOAD;
        state->tape_side = 0;
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_cd_track_pos(radio_state_t *state, uint8_t *display)
{
    if ((display[4] == '-') || (display[5] == '-'))
    {
        state->cd_track_pos = 0;
    }
    else
    {
        uint8_t minutes = 0;
        if (isdigit(display[5])) { minutes += (display[5] & 0x0F) * 10; }
        if (isdigit(display[6])) { minutes += (display[6] & 0x0F); }

        uint8_t seconds = 0;
        if (isdigit(display[7])) { seconds += (display[7] & 0x0F) * 10; }
        if (isdigit(display[8])) { seconds += (display[8] & 0x0F); }

        state->cd_track_pos = (minutes * 60) + seconds;
    }
}

static void _parse_cd(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if (memcmp(display, "CHK MAGAZIN", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_CHECK_MAGAZINE;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_track_pos = 0;
    }
    else if (memcmp(display, "NO  CHANGER", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_NO_CHANGER;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_track_pos = 0;
    }
    else if (memcmp(display, "NO  MAGAZIN", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_NO_MAGAZINE;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_track_pos = 0;
    }
    else if (memcmp(display, "    NO DISC", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_NO_DISC;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_track_pos = 0;
    }
    else if (memcmp(display, "SCAN", 4) == 0) // "SCANCD1TR04"
    {
        state->operation_mode = OPERATION_MODE_CD_SCANNING;
        state->cd_disc = display[6] & 0x0F;
        state->cd_track = 0;
        state->cd_track += (display[9]  & 0x0F) * 10;
        state->cd_track += (display[10] & 0x0F) * 1;
        state->cd_track_pos = 0;
    }
    else if (memcmp(display, "CD ", 3) == 0) // "CD 1"... to "CD 6"...
    {
        state->cd_disc = display[3] & 0x0F;
        state->cd_track_pos = 0;

        if (memcmp(display+4, "CD ERR", 6) == 0) // "CD 1CD ERR " (Premium 5)
        {
            state->operation_mode = OPERATION_MODE_CD_CDX_CD_ERR;
            state->cd_track = 0;
        }
        else if (memcmp(display+5, "NO CD", 5) == 0) // "CD 1 NO CD "
        {
            state->operation_mode = OPERATION_MODE_CD_CDX_NO_CD;
            state->cd_track = 0;
        }
        else if (memcmp(display+5, "TR", 2) == 0) // "CD 1 TR 03 "
        {
            state->operation_mode = OPERATION_MODE_CD_PLAYING;
            state->cd_track = 0;
            state->cd_track += (display[8] & 0x0F) * 10;
            state->cd_track += (display[9] & 0x0F) * 1;
        }
        else if (isdigit(display[8])) // "CD 1  047  "
        {
            state->operation_mode = OPERATION_MODE_CD_PLAYING;
            _parse_cd_track_pos(state, display);
        }
        else
        {
            _parse_unknown(state, display);
        }
    }
    else if (memcmp(display, "CD", 2) == 0) // "CD1"... to "CD6"...
    {
        state->cd_disc = display[2] & 0x0F;
        state->cd_track_pos = 0;

        if (memcmp(display+4, "CD ERR", 6) == 0) // "CD1 CD ERR " (Premium 4)
        {
            state->operation_mode = OPERATION_MODE_CD_CDX_CD_ERR;
            state->cd_track = 0;
        }
        else
        {
            _parse_unknown(state, display);
        }
    }
    else if (memcmp(display, "CUE", 3) == 0) // "CUE   034  "
    {
        state->operation_mode = OPERATION_MODE_CD_CUE;
        _parse_cd_track_pos(state, display);
    }
    else if (memcmp(display, "REV", 3) == 0) // "REV   209  "
    {
        state->operation_mode = OPERATION_MODE_CD_REV;
        _parse_cd_track_pos(state, display);
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_tuner_fm(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    state->tuner_freq = 0; // 102.3 MHz = 1023
    if (isdigit(display[4])) { state->tuner_freq += (display[4] & 0x0F) * 1000; }
    if (isdigit(display[5])) { state->tuner_freq += (display[5] & 0x0F) * 100; }
    if (isdigit(display[6])) { state->tuner_freq += (display[6] & 0x0F) * 10; }
    if (isdigit(display[7])) { state->tuner_freq += (display[7] & 0x0F) * 1; }

    if (memcmp(display, "SCAN", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_TUNER_SCANNING;
        state->tuner_preset = 0;

        if ((state->tuner_band != TUNER_BAND_FM1) &&
            (state->tuner_band != TUNER_BAND_FM2))
        {
            state->tuner_band = TUNER_BAND_FM1;
        }
    }
    else if ((memcmp(display, "FM1", 3) == 0) ||
             (memcmp(display, "FM2", 3) == 0))
    {
        state->operation_mode = OPERATION_MODE_TUNER_PLAYING;
        if (display[2] == '1')
        {
            state->tuner_band = TUNER_BAND_FM1;
        }
        else // '2'
        {
            state->tuner_band = TUNER_BAND_FM2;
        }

        if (isdigit(display[3]))
        {
            state->tuner_preset = display[3] & 0x0F;
        }
        else // ' ' (no preset)
        {
            state->tuner_preset = 0;
        }
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_tuner_am(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    state->tuner_freq = 0; // 1640 kHz = 1640
    if (isdigit(display[4])) { state->tuner_freq += (display[4] & 0x0F) * 1000; }
    if (isdigit(display[5])) { state->tuner_freq += (display[5] & 0x0F) * 100; }
    if (isdigit(display[6])) { state->tuner_freq += (display[6] & 0x0F) * 10; }
    if (isdigit(display[7])) { state->tuner_freq += (display[7] & 0x0F) * 1; }

    state->tuner_band = TUNER_BAND_AM;

    if (memcmp(display, "SCAN", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_TUNER_SCANNING;
        state->tuner_preset = 0;
    }
    else
    {
        state->operation_mode = OPERATION_MODE_TUNER_PLAYING;
        if (isdigit(display[3]))
        {
            state->tuner_preset = display[3] & 0x0F;
        }
        else // ' ' (no preset)
        {
            state->tuner_preset = 0;
        }
    }
}

static void _parse_safe(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if (isdigit(display[0]))
    {
        state->safe_tries = display[0] & 0x0F;
    }
    else
    {
        state->safe_tries = 0;
    }

    if (memcmp(display, "    NO CODE", 11) == 0)
    {
      state->operation_mode = OPERATION_MODE_SAFE_NO_CODE;
      state->safe_code = 0;
    }
    else if (memcmp(display+5, "SAFE", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_SAFE_LOCKED;
        state->safe_code = 1000;
    }
    else if (isdigit(display[4]) && // Premium 5
             isdigit(display[5]) &&
             isdigit(display[6]) &&
             isdigit(display[7]))
    {
        state->operation_mode = OPERATION_MODE_SAFE_ENTRY;
        state->safe_code = 0;
        state->safe_code += (display[4] & 0x0F) * 1000;
        state->safe_code += (display[5] & 0x0F) * 100;
        state->safe_code += (display[6] & 0x0F) * 10;
        state->safe_code += (display[7] & 0x0F) * 1;
    }
    else if (isdigit(display[5]) && // Premium 4
             isdigit(display[6]) &&
             isdigit(display[7]) &&
             isdigit(display[8]))
    {
        state->operation_mode = OPERATION_MODE_SAFE_ENTRY;
        state->safe_code = 0;
        state->safe_code += (display[5] & 0x0F) * 1000;
        state->safe_code += (display[6] & 0x0F) * 100;
        state->safe_code += (display[7] & 0x0F) * 10;
        state->safe_code += (display[8] & 0x0F) * 1;
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_diag(radio_state_t *state, uint8_t *display)
{
    if (memcmp(display, "     DIAG  ", 11) == 0)
    {
        state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;
        state->operation_mode = OPERATION_MODE_DIAGNOSTICS;
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_initial(radio_state_t *state, uint8_t *display)
{
    if (memcmp(display, "    INITIAL", 11) == 0)
    {
        state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;
        state->operation_mode = OPERATION_MODE_INITIALIZING;
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_monsoon(radio_state_t *state, uint8_t *display)
{
    if (memcmp(display, "    MONSOON", 11) == 0)
    {
        state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;
        state->operation_mode = OPERATION_MODE_MONSOON;
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_set(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;
    if (memcmp(display, "SET ONVOL", 9) == 0)
    {
        state->operation_mode = OPERATION_MODE_SETTING_ON_VOL;
        state->option_on_vol = 0;
        if (isdigit(display[9]))  { state->option_on_vol += (display[9]  & 0x0F) * 10; }
        if (isdigit(display[10])) { state->option_on_vol += (display[10] & 0x0F); }
    }
    else if (memcmp(display, "SET CD MIX", 10) == 0)
    {
        state->operation_mode = OPERATION_MODE_SETTING_CD_MIX;
        state->option_cd_mix = display[10] & 0x0F; // 1 or 6
    }
    else if (memcmp(display, "TAPE SKIP", 9) == 0)
    {
        state->operation_mode = OPERATION_MODE_SETTING_TAPE_SKIP;
        if (display[10] == 'Y')
        {
            state->option_tape_skip = 1;
        }
        else // 'N'
        {
            state->option_tape_skip = 0;
        }
    }
    else
    {
        _parse_unknown(state, display);
    }
}

static void _parse_test(radio_state_t *state, uint8_t *display)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;
    if (memcmp(display, "FERN", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_TESTING_FERN;
        if (display[8] == 'F') // "OFF"
        {
            state->test_fern = 0;
        }
        else
        {
            state->test_fern = 1;
        }
    }
    else if (memcmp(display, "Vers", 4) == 0) // Premium 5
    {
        state->operation_mode = OPERATION_MODE_TESTING_VER;
        memcpy(state->test_ver, display+4, sizeof(state->test_ver));
    }
    else if (memcmp(display, "VER", 3) == 0) // Premium 4
    {
        state->operation_mode = OPERATION_MODE_TESTING_VER;
        memcpy(state->test_ver, display+4, sizeof(state->test_ver));
    }
    else if (memcmp(display, "RAD", 3) == 0)
    {
        state->operation_mode = OPERATION_MODE_TESTING_RAD;
        memcpy(state->test_rad, display+4, sizeof(state->test_rad));
    }
    else if (isdigit(display[1]) &&
             isdigit(display[2]) &&
             isdigit(display[3]))
    {
        state->operation_mode = OPERATION_MODE_TESTING_SIGNAL;

        state->test_signal_freq = 0; // 97.7MHz=977, 540KHz=540
        if (isdigit(display[0])) { state->test_signal_freq += (display[0] & 0x0F) * 1000; }
        if (isdigit(display[1])) { state->test_signal_freq += (display[1] & 0x0F) * 100; }
        if (isdigit(display[2])) { state->test_signal_freq += (display[2] & 0x0F) * 10; }
        if (isdigit(display[3])) { state->test_signal_freq += (display[3] & 0x0F) * 1; }

        char strength[4];
        strength[0] = display[4];
        strength[1] = display[6];
        strength[2] = display[8];
        strength[3] = display[10];
        char *part;
        state->test_signal_strength = (uint16_t)strtol(strength, &part, 16);
    }
    else
    {
        _parse_unknown(state, display);
    }
}

void radio_state_parse(radio_state_t *state, uint8_t *display)
{
    if (memcmp(display, "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0", 11) == 0)
    {
        // ignore uninitialized
    }
    else if (memcmp(display, "           ", 11) == 0)
    {
        // ignore all spaces
    }
    else if (memcmp(display, "     DIAG  ", 11) == 0)
    {
        _parse_diag(state, display);
    }
    else if ((memcmp(display+6, "MIN", 3) == 0) ||
             (memcmp(display+6, "MAX", 3) == 0))
    {
        _parse_sound_volume(state, display);
    }
    else if (isdigit(display[0]) && display[1] == ' ')
    {
        _parse_safe(state, display);
    }
    else if ((memcmp(display+0, "    ", 4) == 0) &&
             (memcmp(display+9, "  ", 2) == 0))
    {
        _parse_safe(state, display);
    }
    else if (memcmp(display, "    NO CODE", 11) == 0)
    {
        _parse_safe(state, display);
    }
    else if (memcmp(display, "    INITIAL", 11) == 0)
    {
        _parse_initial(state, display);
    }
    else if (memcmp(display, "    MONSOON", 11) == 0)
    {
        _parse_monsoon(state, display);
    }
    else if (memcmp(display, "BAS", 3) == 0)
    {
        _parse_sound_bass(state, display);
    }
    else if (memcmp(display, "TRE", 3) == 0)
    {
        _parse_sound_treble(state, display);
    }
    else if (memcmp(display, "MID", 3) == 0)
    {
        _parse_midrange(state, display);
    }
    else if (memcmp(display, "BAL", 3) == 0)
    {
        _parse_sound_balance(state, display);
    }
    else if (memcmp(display, "FAD", 3) == 0)
    {
        _parse_sound_fade(state, display);
    }
    else if ((memcmp(display, "SET", 3) == 0) ||
             (memcmp(display, "TAPE SKIP", 9) == 0))
    {
        _parse_set(state, display);
    }
    else if ((memcmp(display, "FER", 3) == 0) ||
             (memcmp(display, "RAD", 3) == 0) ||
             (memcmp(display, "VER", 3) == 0) ||
             (memcmp(display, "Ver", 3) == 0))
    {
        _parse_test(state, display);
    }
    else if (isdigit(display[1]) &&
             isdigit(display[2]) &&
             isdigit(display[3]))
    {
        _parse_test(state, display);
    }
    else if ((memcmp(display, "TAP", 3) == 0) ||
             (memcmp(display, "    NO TAPE", 11) == 0))
    {
        _parse_tape(state, display);
    }
    else if ((memcmp(display, "CD", 2) == 0) ||
             (memcmp(display+4, "CD", 2) == 0) ||
             (memcmp(display, "CHK", 3) == 0) ||
             (memcmp(display, "CUE", 3) == 0) ||
             (memcmp(display, "REV", 3) == 0))
    {
        _parse_cd(state, display);
    }
    else if ((memcmp(display, "NO  CHANGER", 11) == 0) ||
             (memcmp(display, "NO  MAGAZIN", 11) == 0) ||
             (memcmp(display, "    NO DISC", 11) == 0))
    {
        _parse_cd(state, display);
    }
    else if ((memcmp(display+8, "MHZ", 3) == 0) ||
             (memcmp(display+8, "MHz", 3) == 0))
    {
        _parse_tuner_fm(state, display);
    }
    else if ((memcmp(display+8, "KHZ", 3) == 0) ||
             (memcmp(display+8, "kHz", 3) == 0))
    {
        _parse_tuner_am(state, display);
    }
    else
    {
        _parse_unknown(state, display);
    }
}

void radio_state_update_from_upd_if_dirty(
    radio_state_t *radio_state, upd_state_t *upd_state)
{
    if ((upd_state->dirty_flags & UPD_DIRTY_DISPLAY) == 0)
    {
        return;  // display unchanged, nothing to do
    }

    uint8_t display[25];
    uint8_t i;
    uint8_t c;
    for (i=0; i<11; i++)
    {
        // TODO this display order is premium 4 only, make general purpose
        c = upd_state->display_ram[0x0c-i];
        // TODO this converion table is premium 4 specific, make general purpose
        switch (c)
        {
            case 0xe4:
                c = '0'; break;
            case 0xe5:
                c = '1'; break;
            case 0xe6:
                c = '3'; break;
            case 0xe7:
                c = '4'; break;
            case 0xe8:
                c = '5'; break;
            case 0xe9:
                c = '6'; break;
            case 0xea:
                c = '9'; break;
            case 0xeb:
                c = '1'; break; // for FM'1'
            case 0xe0:
                c = 'A'; break; // for SC'A'N
            case 0xe1:
                c = 'B'; break; // for 'B'ASS, TRE'B', 'B'AL
            case 0xe2:
                c = 'N'; break; // for SCA'N'
            case 0xec:
                c = '2'; break; // for FM'2'
            case 0xed:
                c = '2'; break; // for preset 2
            case 0xee:
                c = '3'; break; // for preset 3
            case 0xef:
                c = '4'; break; // for preset 4
            case 0xf0:
                c = '5'; break; // for preset 5
            case 0xf1:
                c = '6'; break;
            case 0xf2:
                c = '6'; break; // for preset 6
            case 0xf3:
                c = '2'; break;
            default:
                break;
        }
        display[i] = c;
    }
    radio_state_parse(radio_state, display);
}

void radio_state_init(radio_state_t *state)
{
    state->operation_mode = OPERATION_MODE_UNKNOWN;
    state->display_mode = DISPLAY_MODE_UNKNOWN;
    state->safe_code = 1000;
    state->safe_tries = 0;
    state->sound_balance = 0;
    state->sound_fade = 0;
    state->sound_bass = 0;
    state->sound_treble = 0;
    state->sound_midrange = 0;
    state->tuner_band = TUNER_BAND_UNKNOWN;
    state->tuner_freq = 0;
    state->tuner_preset = 0;
    state->cd_disc = 0;
    state->cd_track = 0;
    state->cd_track_pos = 0;
    state->tape_side = 0;
    memset(state->display, 0, sizeof(state->display));
    state->option_on_vol = 0;
    state->option_cd_mix = 1;
    state->option_tape_skip = 0;
    state->test_fern = 0;
    memset(state->test_rad, ' ', sizeof(state->test_rad));
    memset(state->test_ver, ' ', sizeof(state->test_ver));
}
