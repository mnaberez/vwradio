#include "main.h"
#include "radio_state.h"
#include "updemu.h"
#include <ctype.h>
#include <string.h>
#include <avr/io.h>

/*************************************************************************
 * Radio State
 *************************************************************************/

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
    state->cd_cue_pos = 0;
    state->tape_side = 0;
}

static void _radio_state_process_unknown(radio_state_t *state, uint8_t *ram)
{
    // unknown displays are ignored
}

static void _radio_state_process_volume(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_VOLUME;
}

static void _radio_state_process_bass(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_BASS;

    if (isdigit(ram[8]))
    {
        state->sound_bass = ram[8] & 0x0F;
        if (ram[6] == '-')
        {
            state->sound_bass = state->sound_bass * -1;
        }
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_treble(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_TREBLE;

    if (isdigit(ram[8]))
    {
        state->sound_treble = ram[8] & 0x0F;
        if (ram[6] == '-')
        {
            state->sound_treble = state->sound_treble * -1;
        }
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_midrange(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_MIDRANGE;

    if (isdigit(ram[8]))
    {
        state->sound_midrange = ram[8] & 0x0F;
        if (ram[6] == '-')
        {
            state->sound_midrange = state->sound_midrange * -1;
        }
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_balance(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_BALANCE;

    if (ram[4] == 'C')
    {
        state->sound_balance = 0; // Center
    }
    else if ((ram[4] == 'R') && isdigit(ram[10]))
    {
        state->sound_balance = ram[10] & 0x0F; // Right
    }
    else if ((ram[4] == 'L') && isdigit(ram[10]))
    {
        state->sound_balance = (ram[10] & 0x0F) * -1; // Left
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_fade(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_ADJUSTING_FADE;

    if (ram[4] == 'C')
    {
        state->sound_fade = 0; // Center
    }
    else if ((ram[4] == 'F') && isdigit(ram[10]))
    {
        state->sound_fade = ram[10] & 0x0F; // Front
    }
    else if ((ram[4] == 'R') && isdigit(ram[10]))
    {
        state->sound_fade = (ram[10] & 0x0F) * -1; // Rear
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_tape(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if ((memcmp(ram, "TAPE PLAY A", 11) == 0) ||
        (memcmp(ram, "TAPE PLAY B", 11) == 0))
    {
        state->operation_mode = OPERATION_MODE_TAPE_PLAYING;
        if (ram[10] == 'A')
        {
            state->tape_side = 1;
        }
        else // 'B'
        {
            state->tape_side = 2;
        }
    }
    else if ((memcmp(ram, "TAPE  FF   ", 11) == 0) ||
             (memcmp(ram, "TAPE  REW  ", 11) == 0))
    {
        if (memcmp(ram+6, "REW", 3) == 0)
        {
            state->operation_mode = OPERATION_MODE_TAPE_REW;
        }
        else // "FF "
        {
            state->operation_mode = OPERATION_MODE_TAPE_FF;
        }
    }
    else if ((memcmp(ram, "TAPEMSS FF ", 11) == 0) ||
             (memcmp(ram, "TAPEMSS REW", 11) == 0))
    {
        if (memcmp(ram+8, "REW", 3) == 0)
        {
            state->operation_mode = OPERATION_MODE_TAPE_MSS_REW;
        }
        else // "FF "
        {
            state->operation_mode = OPERATION_MODE_TAPE_MSS_FF;
        }
    }
    else if (memcmp(ram, "TAPE METAL ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_METAL;
    }
    else if (memcmp(ram, "    NO TAPE", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_NO_TAPE;
        state->tape_side = 0;
    }
    else if (memcmp(ram, "TAPE ERROR ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_ERROR;
        state->tape_side = 0;
    }
    else if (memcmp(ram, "TAPE LOAD  ", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_TAPE_LOAD;
        state->tape_side = 0;
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_cd(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if (memcmp(ram, "CHK MAGAZIN", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_CHECK_MAGAZINE;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_cue_pos = 0;
    }
    else if (memcmp(ram, "NO  CHANGER", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_NO_CHANGER;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_cue_pos = 0;
    }
    else if (memcmp(ram, "    NO DISC", 11) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_NO_DISC;
        state->cd_disc = 0;
        state->cd_track = 0;
        state->cd_cue_pos = 0;
    }
    else if (memcmp(ram, "CD ", 3) == 0) // "CD 1" to "CD 6"
    {
        state->cd_disc = ram[3] & 0x0F;
        state->cd_cue_pos = 0;

        if (memcmp(ram+5, "NO CD", 5) == 0)
        {
            state->operation_mode = OPERATION_MODE_CD_CDX_NO_CD;
            state->cd_track = 0;
        }
        else if (memcmp(ram+5, "TR", 2) == 0)
        {
            state->operation_mode = OPERATION_MODE_CD_PLAYING;
            state->cd_track = 0;
            state->cd_track += (ram[8] & 0x0F) * 10;
            state->cd_track += (ram[9] & 0x0F) * 1;
        }
        else
        {
            _radio_state_process_unknown(state, ram);
        }
    }
    else if (memcmp(ram, "CD", 2) == 0) // "CD1" to "CD6"
    {
        state->cd_disc = ram[2] & 0x0F;
        state->cd_cue_pos = 0;

        if (memcmp(ram+4, "CD ERR", 6) == 0)
        {
            state->operation_mode = OPERATION_MODE_CD_CDX_CD_ERR;
            state->cd_track = 0;
        }
        else
        {
            _radio_state_process_unknown(state, ram);
        }
    }
    else if (memcmp(ram, "CUE", 3) == 0)
    {
        state->operation_mode = OPERATION_MODE_CD_CUEING;
        // TODO  self.cd_cue_pos = int(text[4:9].strip())
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_tuner_fm(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    state->tuner_freq = 0; // 102.3 MHz = 1023
    if (isdigit(ram[4])) { state->tuner_freq += (ram[4] & 0x0F) * 1000; }
    if (isdigit(ram[5])) { state->tuner_freq += (ram[5] & 0x0F) * 100; }
    if (isdigit(ram[6])) { state->tuner_freq += (ram[6] & 0x0F) * 10; }
    if (isdigit(ram[7])) { state->tuner_freq += (ram[7] & 0x0F) * 1; }

    if (memcmp(ram, "SCAN", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_TUNER_SCANNING;
        state->tuner_preset = 0;

        if ((state->tuner_band != TUNER_BAND_FM1) &&
            (state->tuner_band != TUNER_BAND_FM2))
        {
            state->tuner_band = TUNER_BAND_FM1;
        }
    }
    else if ((memcmp(ram, "FM1", 3) == 0) ||
             (memcmp(ram, "FM2", 3) == 0))
    {
        state->operation_mode = OPERATION_MODE_TUNER_PLAYING;
        if (ram[2] == '1')
        {
            state->tuner_band = TUNER_BAND_FM1;
        }
        else // '2'
        {
            state->tuner_band = TUNER_BAND_FM2;
        }

        if (isdigit(ram[3]))
        {
            state->tuner_preset = ram[3] & 0x0F;
        }
        else // ' ' (no preset)
        {
            state->tuner_preset = 0;
        }
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

static void _radio_state_process_tuner_am(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    state->tuner_freq = 0; // 1640 kHz = 1640
    if (isdigit(ram[4])) { state->tuner_freq += (ram[4] & 0x0F) * 1000; }
    if (isdigit(ram[5])) { state->tuner_freq += (ram[5] & 0x0F) * 100; }
    if (isdigit(ram[6])) { state->tuner_freq += (ram[6] & 0x0F) * 10; }
    if (isdigit(ram[7])) { state->tuner_freq += (ram[7] & 0x0F) * 1; }

    state->tuner_band = TUNER_BAND_AM;

    if (memcmp(ram, "SCAN", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_TUNER_SCANNING;
        state->tuner_preset = 0;
    }
    else
    {
        state->operation_mode = OPERATION_MODE_TUNER_PLAYING;
        if (isdigit(ram[3]))
        {
            state->tuner_preset = ram[3] & 0x0F;
        }
        else // ' ' (no preset)
        {
            state->tuner_preset = 0;
        }
    }
}

static void _radio_state_process_safe(radio_state_t *state, uint8_t *ram)
{
    state->display_mode = DISPLAY_MODE_SHOWING_OPERATION;

    if (isdigit(ram[0]))
    {
        state->safe_tries = ram[0] & 0x0F;
    }
    else
    {
        state->safe_tries = 0;
    }

    if (memcmp(ram+5, "SAFE", 4) == 0)
    {
        state->operation_mode = OPERATION_MODE_SAFE_LOCKED;
        state->safe_code = 1000;
    }
    else if (isdigit(ram[4]) && // Premium 5
             isdigit(ram[5]) &&
             isdigit(ram[6]) &&
             isdigit(ram[7]))
    {
        state->operation_mode = OPERATION_MODE_SAFE_ENTRY;
        state->safe_code = 0;
        state->safe_code += (ram[4] & 0x0F) * 1000;
        state->safe_code += (ram[5] & 0x0F) * 100;
        state->safe_code += (ram[6] & 0x0F) * 10;
        state->safe_code += (ram[7] & 0x0F) * 1;
    }
    else if (isdigit(ram[5]) && // Premium 4
             isdigit(ram[6]) &&
             isdigit(ram[7]) &&
             isdigit(ram[8]))
    {
        state->operation_mode = OPERATION_MODE_SAFE_ENTRY;
        state->safe_code = 0;
        state->safe_code += (ram[5] & 0x0F) * 1000;
        state->safe_code += (ram[6] & 0x0F) * 100;
        state->safe_code += (ram[7] & 0x0F) * 10;
        state->safe_code += (ram[8] & 0x0F) * 1;
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

void radio_state_process(radio_state_t *state, uint8_t *ram)
{
    if (memcmp(ram, "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0", 11) == 0)
    {
        // ignore uninitialized
    }
    else if (memcmp(ram, "           ", 11) == 0)
    {
        // ignore all spaces
    }
    else if ((memcmp(ram+6, "MIN", 3) == 0) ||
             (memcmp(ram+6, "MAX", 3) == 0))
    {
        _radio_state_process_volume(state, ram);
    }
    else if (isdigit(ram[0]))
    {
        _radio_state_process_safe(state, ram);
    }
    else if ((memcmp(ram+0, "    ", 4) == 0) &&
             (memcmp(ram+9, "  ", 2) == 0))
    {
        _radio_state_process_safe(state, ram);
    }
    else if (memcmp(ram, "BAS", 3) == 0)
    {
        _radio_state_process_bass(state, ram);
    }
    else if (memcmp(ram, "TRE", 3) == 0)
    {
        _radio_state_process_treble(state, ram);
    }
    else if (memcmp(ram, "MID", 3) == 0)
    {
        _radio_state_process_midrange(state, ram);
    }
    else if (memcmp(ram, "BAL", 3) == 0)
    {
        _radio_state_process_balance(state, ram);
    }
    else if (memcmp(ram, "FAD", 3) == 0)
    {
        _radio_state_process_fade(state, ram);
    }
    else if ((memcmp(ram, "TAP", 3) == 0) ||
             (memcmp(ram, "    NO TAPE", 11) == 0))
    {
        _radio_state_process_tape(state, ram);
    }
    else if ((memcmp(ram, "CD", 2) == 0) ||
             (memcmp(ram, "CUE", 3) == 0) ||
             (memcmp(ram, "CHK", 3) == 0))
    {
        _radio_state_process_cd(state, ram);
    }
    else if ((memcmp(ram, "NO  CHANGER", 11) == 0) ||
             (memcmp(ram, "    NO DISC", 11) == 0))
    {
        _radio_state_process_cd(state, ram);
    }
    else if ((memcmp(ram+8, "MHZ", 3) == 0) ||
             (memcmp(ram+8, "MHz", 3) == 0))
    {
        _radio_state_process_tuner_fm(state, ram);
    }
    else if ((memcmp(ram+8, "KHZ", 3) == 0) ||
             (memcmp(ram+8, "kHz", 3) == 0))
    {
        _radio_state_process_tuner_am(state, ram);
    }
    else
    {
        _radio_state_process_unknown(state, ram);
    }
}

void radio_state_update_from_upd_if_dirty(radio_state_t *radio_state, upd_state_t *upd_state)
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
        // TODO XXX this display order is premium 4 specific
        c = upd_state->display_ram[0x0c-i];
        // TODO xxx this conversion table is premium 4 specific
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
    radio_state_process(radio_state, display);
}
