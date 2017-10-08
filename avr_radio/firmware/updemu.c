/*************************************************************************
 * NEC uPD16432B LCD Controller Emulator
 *************************************************************************/

#include <stdint.h>
#include <string.h>
#include "updemu.h"

void upd_init(upd_state_t *state)
{
    state->ram_area = UPD_RAM_NONE;
    state->ram_size = 0;
    state->address = 0;
    state->increment = UPD_INCREMENT_OFF;
    state->dirty_flags = UPD_DIRTY_NONE;

    memset(state->display_ram, 0, UPD_DISPLAY_RAM_SIZE);
    memset(state->pictograph_ram, 0, UPD_PICTOGRAPH_RAM_SIZE);
    memset(state->chargen_ram, 0, UPD_CHARGEN_RAM_SIZE);
    memset(state->led_ram, 0, UPD_LED_RAM_SIZE);
}

static void _wrap_address(upd_state_t *state)
{
    if (state->address >= state->ram_size)
    {
        state->address = 0;
    }
}

static void _write_data_byte(upd_state_t *state, uint8_t b)
{
    switch (state->ram_area)
    {
        case UPD_RAM_DISPLAY:
            if (state->display_ram[state->address] != b)
            {
                state->display_ram[state->address] = b;
                state->dirty_flags |= UPD_DIRTY_DISPLAY;
            }
            break;

        case UPD_RAM_PICTOGRAPH:
            if (state->pictograph_ram[state->address] != b)
            {
                state->pictograph_ram[state->address] = b;
                state->dirty_flags |= UPD_DIRTY_PICTOGRAPH;
            }
            break;

        case UPD_RAM_CHARGEN:
            if (state->chargen_ram[state->address] != b)
            {
                state->chargen_ram[state->address] = b;
                state->dirty_flags |= UPD_DIRTY_CHARGEN;
            }
            break;

        case UPD_RAM_LED:
            if (state->led_ram[state->address] != b)
            {
                state->led_ram[state->address] = b;
                state->dirty_flags |= UPD_DIRTY_LED;
            }
            break;

        case UPD_RAM_NONE:
        default:
            return;
    }

    if (state->increment == UPD_INCREMENT_ON)
    {
        state->address++;
        _wrap_address(state);
    }
}

static void _process_address_setting_cmd(upd_state_t *state, upd_command_t *cmd)
{
    uint8_t address;
    address = cmd->data[0] & 0b00011111;

    switch (state->ram_area)
    {
        case UPD_RAM_DISPLAY:
        case UPD_RAM_PICTOGRAPH:
        case UPD_RAM_LED:
            state->address = address;
            _wrap_address(state);
            break;

        case UPD_RAM_CHARGEN:
            // for chargen, address is character number (valid from 0 to 0x0F)
            if (address < 0x10)
            {
                state->address = address * 7; // 7 bytes per character
            }
            else
            {
                state->address = 0; // character number out of range
            }
            break;

        default:
            // unknown ram area
            address = 0;
            break;
    }
}

static void _process_data_setting_cmd(upd_state_t *state, upd_command_t *cmd)
{
    uint8_t mode;
    mode = cmd->data[0] & 0b00000111;

    // set ram target area
    switch (mode)
    {
        case UPD_RAM_DISPLAY:
            state->ram_area = UPD_RAM_DISPLAY;
            state->ram_size = UPD_DISPLAY_RAM_SIZE;
            break;

        case UPD_RAM_PICTOGRAPH:
            state->ram_area = UPD_RAM_PICTOGRAPH;
            state->ram_size = UPD_PICTOGRAPH_RAM_SIZE;
            break;

        case UPD_RAM_CHARGEN:
            state->ram_area = UPD_RAM_CHARGEN;
            state->ram_size = UPD_CHARGEN_RAM_SIZE;
            break;

        case UPD_RAM_LED:
            state->ram_area = UPD_RAM_LED;
            state->ram_size = UPD_LED_RAM_SIZE;
            break;

        default:
            state->ram_area = UPD_RAM_NONE;
            state->ram_size = 0;
            state->address = 0;
    }

    // set increment mode
    switch (mode)
    {
        // only these modes support setting increment on/off
        case UPD_RAM_DISPLAY:
        case UPD_RAM_PICTOGRAPH:
            state->increment = ((cmd->data[0] & 0b00001000) == 0);
            break;

        // other modes always increment and also reset address
        default:
            state->increment = 1;
            state->address = 0;
            break;
    }

    _wrap_address(state);
}

void upd_process_command(upd_state_t *state, upd_command_t *cmd)
{
    // No SPI bytes were received while STB was asserted
    if (cmd->size == 0)
    {
        return;
    }

    // Process command byte
    uint8_t cmd_type;
    cmd_type = cmd->data[0] & 0b11000000;
    switch (cmd_type)
    {
        case 0b01000000:
            _process_data_setting_cmd(state, cmd);
            break;

        case 0b10000000:
            _process_address_setting_cmd(state, cmd);
            break;

        default:
            break;
    }

    // Process data bytes
    if ((state->ram_area != UPD_RAM_NONE) && (cmd->size > 1))
    {
        uint8_t i;
        for (i=1; i<cmd->size; i++)
        {
            _write_data_byte(state, cmd->data[i]);
        }
    }
}
