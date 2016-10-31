#include <stdint.h>
#include <string.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include "cmd.h"
#include "convert_keys.h"
#include "convert_pictographs.h"
#include "leds.h"
#include "main.h"
#include "faceplate.h"
#include "radio_spi.h"
#include "radio_state.h"
#include "uart.h"
#include "updemu.h"

/*************************************************************************
 * Command Interpreter
 *************************************************************************/

void cmd_init()
{
    cmd_buf_index = 0;
    cmd_expected_length = 0;
}

/* Start or restart the command timeout timer.
 * Call this after each byte of the command is received.
 */
static void _start_timer()
{
    // set timer1 CTC mode (CS11=0, CS10=1 = prescaler 1024)
    TCCR1B = (1 << CS12) | (0 << CS11) | (1 << CS10);

    // set compare value (2.00 seconds at 20 MHz)
    OCR1A = 39063;

    // set initial count
    TCNT1 = 0;

    // enable timer1 compare interrupt
    TIMSK1 = (1 << OCIE1A);
}

/* Stop the command timeout timer.
 * Call this after the last byte of a command has been received.
 */
static void _stop_timer()
{
    // stop timer1
    TCCR1B = 0;
    // disable timer1 compare interrupt
    TIMSK1 = 0;
}

/* Command timeout has occurred while receiving command bytes.  We forget the
 * buffer and don't send any reply.  This allows the client to resynchronize
 * by waiting longer than the timeout.
 */
ISR(TIMER1_COMPA_vect)
{
    _stop_timer();
    cmd_init();
}

static void _send_empty_reply(uint8_t error_code)
{
    uart_put(1);   // 1 byte to follow
    uart_put(error_code);
}

/* Command: Reset uPD16432B Emulator
 * Arguments: none
 * Returns: <error>
 *
 * Reset the uPD16432B Emulator to its default state.  This does not
 * affect the UPD key data output bytes (upd_tx_key_data).
 */
static void _do_emulated_upd_reset()
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    upd_init(&emulated_upd_state);
    _send_empty_reply(CMD_ERROR_OK);
}

static void _dump_upd_state_to_uart(upd_state_t *state)
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t size;
    size = 1 + // error byte
           1 + // ram_area
           1 + // ram_size
           1 + // address
           1 + // increment
           1 + // dirty_flags
           UPD_DISPLAY_RAM_SIZE +
           UPD_PICTOGRAPH_RAM_SIZE +
           UPD_CHARGEN_RAM_SIZE +
           UPD_LED_RAM_SIZE;

    uart_put(size); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(state->ram_area);
    uart_put(state->ram_size);
    uart_put(state->address);
    uart_put(state->increment);
    uart_put(state->dirty_flags);

    uint8_t i;
    for (i=0; i<UPD_DISPLAY_RAM_SIZE; i++) {
        uart_put(state->display_ram[i]);
    }

    for (i=0; i<UPD_PICTOGRAPH_RAM_SIZE; i++)
    {
        uart_put(state->pictograph_ram[i]);
    }

    for (i=0; i<UPD_CHARGEN_RAM_SIZE; i++)
    {
        uart_put(state->chargen_ram[i]);
    }

    for (i=0; i<UPD_LED_RAM_SIZE; i++)
    {
        uart_put(state->led_ram[i]);
    }
}

/* Command: Dump uPD16432B Emulator State
 * Arguments: none
 * Returns: <error> <all bytes in emulated_upd_state>
 *
 * Dump the current state of the uPD16432B emulator.
 */
static void _do_emulated_upd_dump_state()
{
    _dump_upd_state_to_uart(&emulated_upd_state);
}

/* Populate a upd_command_t from the UART command buffer
 * Returns an error code (one of CMD_ERROR_*)
 */
static uint8_t _populate_cmd_from_uart_cmd_buf(upd_command_t *cmd)
{
    // Bail out if size of bytes from UART exceeds uPD16432B command max size.
    // -1 is because first byte in cmd_buf is the uart command byte
    if ((cmd_buf_index - 1) > sizeof(cmd->data))
    {
        return CMD_ERROR_BAD_ARGS_LENGTH;
    }

    // Populate uPD16432B command request with bytes from UART
    uint8_t size = cmd_buf_index - 1;
    memcpy(cmd->data, cmd_buf+1, size);
    cmd->size = size;

    return CMD_ERROR_OK;
}

/* Command: Send uPD16432B Emulator Command
 * Arguments: <cmd arg byte0> <cmd arg byte1> ...
 * Returns: <error>
 *
 * Sends a fake SPI command to the uPD16432B Emulator.  The arguments
 * are the SPI bytes that would be received by the uPD16432B while it
 * is selected with STB high.
 */
static void _do_emulated_upd_send_command()
{
    upd_command_t cmd;

    uint8_t error_code = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (error_code != CMD_ERROR_OK)
    {
        _send_empty_reply(error_code);
        return;
    }

    // Process uPD16432B command request as if we received it over SPI
    upd_process_command(&emulated_upd_state, &cmd);
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Load uPD16432B Emulator Key Data
 * Arguments: <key0> <key1> <key2> <key3>
 * Returns: <error>
 *
 * Load the four bytes of the uPD16432B emulator key data.  These bytes
 * will be sent to the radio whenever a key data request command is received.
 * The same bytes will be sent for every key data request until the bytes
 * are changed.  Set {0, 0, 0, 0} to indicate no keys pressed.
 */
static void _do_emulated_upd_load_key_data()
{
    if (cmd_buf_index != 5)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    // can't load key data while key passthru is enabled because the
    // data we'd load would be immediately overwritten by passthru
    if (auto_key_passthru)
    {
        _send_empty_reply(CMD_ERROR_BLOCKED_BY_PASSTHRU);
        return;
    }

    // load the four key data bytes
    uint8_t i;
    for (i=0; i<sizeof(upd_tx_key_data); i++)
    {
        upd_tx_key_data[i] = cmd_buf[i+1];
    }

    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Radio State Reset
 * Arguments: none
 * Returns: <error>
 */
static void _do_radio_state_reset()
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    radio_state_init(&radio_state);
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Radio State Parse
 * Arguments: <byte1>
 * Returns: <error>
 */
static void _do_radio_state_parse()
{
    // -1 is because first byte in cmd_buf is the uart command byte
    uint8_t data_size = cmd_buf_index - 1;

    // Bail out if not enough bytes of display data were received or
    // if size of bytes from UART exceeds display RAM size
    if ((data_size < 11) ||
        (data_size > UPD_DISPLAY_RAM_SIZE))
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    // Initialize empty display data buffer
    uint8_t display_ram[UPD_DISPLAY_RAM_SIZE];
    memset(display_ram, 0, UPD_DISPLAY_RAM_SIZE);

    // Populate display data buffer with UART data
    memcpy(display_ram, cmd_buf+1, data_size);

    radio_state_parse(&radio_state, display_ram);
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Radio State Dump
 * Arguments: <byte1>
 * Returns: <error>
 */
static void _do_radio_state_dump()
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uart_put(53); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(radio_state.operation_mode);
    uart_put(radio_state.display_mode);
    uart_put(radio_state.safe_tries);
    uart_put16(radio_state.safe_code);
    uart_put(radio_state.sound_bass);
    uart_put(radio_state.sound_treble);
    uart_put(radio_state.sound_midrange);
    uart_put(radio_state.sound_balance);
    uart_put(radio_state.sound_fade);
    uart_put(radio_state.tape_side);
    uart_put(radio_state.cd_disc);
    uart_put(radio_state.cd_track);
    uart_put16(radio_state.cd_track_pos);
    uart_put16(radio_state.tuner_freq);
    uart_put(radio_state.tuner_preset);
    uart_put(radio_state.tuner_band);
    uint8_t i;
    for (i=0; i<sizeof(radio_state.display); i++)
    {
        uart_put(radio_state.display[i]);
    }
    uart_put(radio_state.option_on_vol);
    uart_put(radio_state.option_cd_mix);
    uart_put(radio_state.option_tape_skip);
    uart_put(radio_state.test_fern);
    for (i=0; i<sizeof(radio_state.test_rad); i++)
    {
        uart_put(radio_state.test_rad[i]);
    }
    for (i=0; i<sizeof(radio_state.test_ver); i++)
    {
        uart_put(radio_state.test_ver[i]);
    }
    uart_put16(radio_state.test_signal_freq);
    uart_put16(radio_state.test_signal_strength);
}

/* Command: Echo
 * Arguments: <arg1> <arg2> <arg3> ...
 * Returns: <error> <arg1> <arg1> <arg3> ...
 *
 * Echoes the arguments received back to the client.  If no args were
 * received after the command byte, an empty success response is returned.
 */
static void _do_echo()
{
    uart_put(cmd_buf_index); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
        uart_put(cmd_buf[i]);
        uart_flush_tx();
    }
}

/* Command: Set LED
 * Arguments: <led number> <led state>
 * Returns: <error>
 *
 * Turns one of the LEDs on or off.  Returns an error if the LED
 * number is not recognized.
 */
static void _do_set_led()
{
    if (cmd_buf_index != 3)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t led_num = cmd_buf[1];
    uint8_t led_state = cmd_buf[2];

    switch (led_num)
    {
        case CMD_ARG_RED_LED:
            led_set(LED_RED, led_state);
            break;

        case CMD_ARG_GREEN_LED:
            led_set(LED_GREEN, led_state);
            break;

        default:
            _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
            return;
    }

    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Set Run Mode
 * Arguments: <run mode>
 * Returns: <error>
 *
 * Sets the run mode to either RUN_MODE_RUNNING or RUN_MODE_STOPPED.  This is
 * mainly used for testing.  When stopped, commands from the radio are ignored
 * and the faceplate is not updated.
 */
static void _do_set_run_mode()
{
    if (cmd_buf_index != 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t mode = cmd_buf[1];
    if ((mode != RUN_MODE_RUNNING) && (mode != RUN_MODE_STOPPED))
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }

    run_mode = mode;
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Set passthru of emulated uPD display to the real faceplate
 * Arguments: <0|1>
 * Returns: <error>
 *
 * Sets whether the faceplate will be automatically updated with the display
 * from the radio.  Set to 1 to enable passthru, or set to 0 to disable
 * passthru so the faceplate display can be taken over.
 */
static void _do_set_auto_display_passthru()
{
    if (cmd_buf_index != 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t onoff = cmd_buf[1];
    if ((onoff != 0) && (onoff != 1))
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }
    auto_display_passthru = onoff;

    // if returning control of the faceplate to the emulated upd, force the
    // emulated state to be dirty.  this will cause an immediate update of
    // the real faceplate in the main loop.
    if (auto_display_passthru)
    {
        emulated_upd_state.dirty_flags =
            UPD_DIRTY_DISPLAY |
            UPD_DIRTY_PICTOGRAPH |
            UPD_DIRTY_CHARGEN;
    }

    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Set passthru of keys on the real faceplate to the emulated uPD
 * Argument: <0|1>
 * Returns: <error>
 *
 * Sets whether key presses on the faceplate will be automatically passed on
 * to the radio.  Set to 1 to enable passthru, or set to 0 to disable
 * passthru so the faceplate keys can be taken over.
 */
static void _do_set_auto_key_passthru()
{
    if (cmd_buf_index != 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t onoff = cmd_buf[1];
    if ((onoff != 0) && (onoff != 1))
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }
    auto_key_passthru = onoff;

    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Dump the real faceplate's uPD16432B state
 * Arguments: none
 * Returns: <error> <all bytes in faceplate_upd_state>
 *
 * Dump the current state of the real uPD16432B on the faceplate.
 */
static void _do_faceplate_upd_dump_state()
{
    _dump_upd_state_to_uart(&faceplate_upd_state);
}

/* Command: Send command to faceplate's uPD16432B
 * Arguments: <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <error>
 *
 * Send an SPI command to the faceplate's uPD16432B.
 */
static void _do_faceplate_upd_send_command()
{
    upd_command_t cmd;

    uint8_t error_code = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (error_code != CMD_ERROR_OK)
    {
        _send_empty_reply(error_code);
        return;
    }

    faceplate_send_upd_command(&cmd);
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Clear the faceplate's display
 * Arguments: none
 * Returns: <error>
 *
 * Sends SPI commands to initialize the faceplate and clear it.
 */
static void _do_faceplate_upd_clear_display()
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    faceplate_clear_display();
    _send_empty_reply(CMD_ERROR_OK);
}

/* Command: Read the faceplate's raw key data
 * Arguments: none
 * Returns: <error> <byte0> <byte1> <byte2> <byte3>
 *
 * Reads the key data from the faceplate and returns the 4 raw key data bytes.
 */
 static void _do_faceplate_upd_read_key_data()
 {
     if (cmd_buf_index != 1)
     {
         _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
         return;
     }

     uint8_t key_data[4] = {0, 0, 0, 0};
     faceplate_read_key_data(key_data);

     uart_put(5); // number of bytes to follow
     uart_put(CMD_ERROR_OK);
     uart_put(key_data[0]);
     uart_put(key_data[1]);
     uart_put(key_data[2]);
     uart_put(key_data[3]);
 }

/* Command: Convert a key code to uPD16432B raw data bytes
 * Arguments: <keycode>
 * Returns: <error> <byte0> <byte1> <byte2> <byte3>
 *
 * Convert a key code (one of the KEY_ constants) to uPD16432B raw data
 * bytes.  If the key code is bad, or the key is not supported by the
 * radio, an error is returned.
 */
static void _do_convert_code_to_upd_key_data()
{
    if (cmd_buf_index != 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t key_code = cmd_buf[1];
    uint8_t key_data[4] = {0, 0, 0, 0};
    uint8_t success = convert_code_to_upd_key_data(key_code, key_data);
    if (! success) // key code not found
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }

    uart_put(5); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(key_data[0]);
    uart_put(key_data[1]);
    uart_put(key_data[2]);
    uart_put(key_data[3]);
}

/* Command: Convert uPD16432B raw key data bytes to key codes
 * Arguments: <byte0> <byte1> <byte2> <byte3>
 * Returns: <error> <count> <keycode0> <keycode1>
 *
 * Convert uPD16432B key data to key codes (the KEY_ constants).  Returns 0, 1,
 * or 2 key codes as indicated by <count>  Two key code bytes are always
 * returned; unused bytes are set to 0.
 */
static void _do_convert_upd_key_data_to_codes()
{
    // command byte + 4 key data bytes
    if (cmd_buf_index != 5)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t key_codes[2];
    uint8_t num_keys_pressed;
    num_keys_pressed = convert_upd_key_data_to_codes(cmd_buf+1, key_codes);

    uart_put(4); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(num_keys_pressed);
    uart_put(key_codes[0]);
    uart_put(key_codes[1]);
}

/*
 * Command: Convert a pictograph code to uPD16432B raw pictograph data bytes
 * Arguments: <code>
 * Returns: <error> <byte0>...<byte7>
 *
 * Convert a pictograph code (one of the PICTOGRAPH_ constants) to uPD16432B
 * raw pictograph data bytes.  If the pictograph code is bad, or the pictograph
 * is not supported by the radio, an error is returned.
 */
static void _do_convert_code_to_upd_pictograph_data()
{
    if (cmd_buf_index != 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t pictograph_code = cmd_buf[1];
    uint8_t pictograph_data[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t success = convert_code_to_upd_pictograph_data(pictograph_code, pictograph_data);
    if (! success) // key code not found
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }

    uart_put(9); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    for (uint8_t i=0; i<8; i++)
    {
        uart_put(pictograph_data[i]);
    }
}

/*
 * Command: Convert uPD16432B raw pictograph data bytes to pictograph codes
 * Arguments: <byte0>...<byte7>
 * Returns: <error> <count> <byte0>...<byte6>
 *
 * Convert uPD16432B pictograph data to codes (the PICTOGRAPH_ constants).
 * Returns 0-7 pictograph codes as indicated by <count>.  7 pictograph code
 * bytes are always returned; unused bytes are set to 0.
 */
static void _do_convert_upd_pictograph_data_to_codes()
{
    // command byte + 8 pictograph data bytes
    if (cmd_buf_index != 9)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    uint8_t pictograph_codes[8];
    uint8_t num_pictographs_displayed;
    num_pictographs_displayed = convert_upd_pictograph_data_to_codes(cmd_buf+1, pictograph_codes);

    uart_put(9); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(num_pictographs_displayed);
    for (uint8_t i=0; i<7; i++)
    {
        uart_put(pictograph_codes[i]);
    }
}

/* Command: Read the real faceplate's keys as key codes
 * Arguments: none
 * Returns: <error> <count> <keycode0> <keycode1>
 *
 * Read the faceplate and return keys codes (KEY_* constants) for any keys
 * pressed.  It may return 0, 1, or 2 key codes as indicated by <count>.  Two
 * key code bytes are always returned; unused bytes are set to 0.
 */
static void _do_read_keys()
{
    if (cmd_buf_index != 1)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    // Read keys from the faceplate
    uint8_t key_data[4] = {0, 0, 0, 0};
    faceplate_read_key_data(key_data);

    // Convert uPD16432B key raw data to key codes
    uint8_t key_codes[2] = {0, 0};
    uint8_t num_pressed = convert_upd_key_data_to_codes(key_data, key_codes);

    uart_put(4); // number of bytes to follow
    uart_put(CMD_ERROR_OK);
    uart_put(num_pressed);
    uart_put(key_codes[0]);
    uart_put(key_codes[1]);
}

/* Command: Load the emulated faceplate's key data from key codes
 * Arguments: <count> <keycode0> <keycode1>
 * Returns: <error>
 *
 * Load the emulated uPD16432B's key data from key codes (KEY_ constants).
 * The key codes will be converted to uPD16432B key data and then sent
 * to the radio when it requests key data.  This same key data will always
 * be sent until it is changed again (i.e., the keys will be held down).
 *
 * If a given key code is bad, or a key is not supported by the radio, an
 * error is returned.
 *
 * Always send three arguments: a count of key codes (may be 0, 1, 2) followed
 * by two key code bytes.  If count < 2, the extra key code bytes are ignored.
 * To release all keys, send a count of 0.
 */
static void _do_load_keys()
{
    // command byte + count byte + 2 key code bytes
    if (cmd_buf_index != 4)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_LENGTH);
        return;
    }

    // can't load key data while key passthru is enabled because the
    // data we'd load would be immediately overwritten by passthru
    if (auto_key_passthru)
    {
        _send_empty_reply(CMD_ERROR_BLOCKED_BY_PASSTHRU);
        return;
    }

    // get number of keys pressed and their keycodes from cmd buffer
    uint8_t num_pressed = cmd_buf[1];
    uint8_t key_codes[2] = { cmd_buf[2], cmd_buf[3] };

    // 0, 1, or 2 keys can be pressed simultaneously
    if (num_pressed > 2)
    {
        _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
        return;
    }

    // convert the key codes to four uPD16432B key data bytes
    uint8_t key_data[4] = {0, 0, 0, 0};
    uint8_t i;
    for (i=0; i<num_pressed; i++)
    {
        // get key upd data bytes for this one key
        uint8_t one_key_data[4] = {0, 0, 0, 0};
        uint8_t success = convert_code_to_upd_key_data(
            key_codes[i], one_key_data);
        if (! success) // bad key code
        {
            _send_empty_reply(CMD_ERROR_BAD_ARGS_VALUE);
            return;
        }

        // merge the bytes from this one key into the final key data
        key_data[0] |= one_key_data[0];
        key_data[1] |= one_key_data[1];
        key_data[2] |= one_key_data[2];
        key_data[3] |= one_key_data[3];
    }

    // load the four uPD16432B key data bytes
    for (i=0; i<4; i++)
    {
        upd_tx_key_data[i] = key_data[i];
    }

    _send_empty_reply(CMD_ERROR_OK);
}

/* Dispatch a command.  A complete command packet has been received.  The
 * command buffer has one or more bytes.  The first byte is the command byte.
 * Dispatch to a handler, or return an error if the command is unrecognized.
 */
static void _cmd_dispatch()
{
    switch (cmd_buf[0])
    {
        case CMD_SET_LED:
            _do_set_led();
            break;
        case CMD_ECHO:
            _do_echo();
            break;

        case CMD_SET_RUN_MODE:
            _do_set_run_mode();
            break;
        case CMD_SET_AUTO_DISPLAY_PASSTHRU:
            _do_set_auto_display_passthru();
            break;
        case CMD_SET_AUTO_KEY_PASSTHRU:
            _do_set_auto_key_passthru();
            break;

        case CMD_RADIO_STATE_DUMP:
            _do_radio_state_dump();
            break;
        case CMD_RADIO_STATE_PARSE:
            _do_radio_state_parse();
            break;
        case CMD_RADIO_STATE_RESET:
            _do_radio_state_reset();
            break;

        case CMD_EMULATED_UPD_DUMP_STATE:
            _do_emulated_upd_dump_state();
            break;
        case CMD_EMULATED_UPD_SEND_COMMAND:
            _do_emulated_upd_send_command();
            break;
        case CMD_EMULATED_UPD_RESET:
            _do_emulated_upd_reset();
            break;
        case CMD_EMULATED_UPD_LOAD_KEY_DATA:
            _do_emulated_upd_load_key_data();
            break;

        case CMD_FACEPLATE_UPD_DUMP_STATE:
            _do_faceplate_upd_dump_state();
            break;
        case CMD_FACEPLATE_UPD_SEND_COMMAND:
            _do_faceplate_upd_send_command();
            break;
        case CMD_FACEPLATE_UPD_CLEAR_DISPLAY:
            _do_faceplate_upd_clear_display();
            break;
        case CMD_FACEPLATE_UPD_READ_KEY_DATA:
            _do_faceplate_upd_read_key_data();
            break;

        case CMD_CONVERT_UPD_KEY_DATA_TO_CODES:
            _do_convert_upd_key_data_to_codes();
            break;
        case CMD_CONVERT_CODE_TO_UPD_KEY_DATA:
            _do_convert_code_to_upd_key_data();
            break;
        case CMD_CONVERT_UPD_PICTOGRAPH_DATA_TO_CODES:
            _do_convert_upd_pictograph_data_to_codes();
            break;
        case CMD_CONVERT_CODE_TO_UPD_PICTOGRAPH_DATA:
            _do_convert_code_to_upd_pictograph_data();
            break;

        case CMD_READ_KEYS:
            _do_read_keys();
            break;
        case CMD_LOAD_KEYS:
            _do_load_keys();
            break;

        default:
            _send_empty_reply(CMD_ERROR_BAD_COMMAND);
    }
}

/* Receive a command byte.  Commands are executed immediately after the
 * last byte has been received.
 *
 * Format of a command request:
 *   <number of bytes to follow> <command byte> <arg> <arg> ...
 * Examples:
 *   01 AB         Command AB, no args
 *   03 DE AA 55   Command DE, args: [AA, 55]
 *
 * Format of a command response:
 *   <number of bytes to follow> <error> <arg> <arg> ...
 * Examples:
 *   01 00         Command succeeded, no data
 *   02 00 AA      Command succeeded, data: [AA]
 *   01 01         Command failed, no data
 *   03 01 AA 55   Command failed, data: [AA, 55]
 *
 * Error byte of zero means success, non-zero means error.
 */
void cmd_receive_byte(uint8_t c)
{
    // receive command length byte
    if (cmd_expected_length == 0)
    {
        if (c == 0) // invalid, command length must be 1 byte or longer
        {
            _send_empty_reply(CMD_ERROR_NO_COMMAND);
            cmd_init();
        }
        else
        {
            cmd_expected_length = c;
            _start_timer();
        }
    }
    // receive command byte(s)
    else
    {
        cmd_buf[cmd_buf_index++] = c;
        _start_timer();

        if (cmd_buf_index == cmd_expected_length)
        {
            _stop_timer();
            _cmd_dispatch();
            cmd_init();
        }
    }
}
