#include <stdint.h>
#include <string.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include "cmd.h"
#include "convert.h"
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

    // set compare value (2 seconds at 18.432MHz with prescaler 1024)
    OCR1A = 39062;

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

static void _reply_ack()
{
    uart_putc(1);   // 1 byte to follow
    uart_putc(ACK);
}

static void _reply_nak()
{
    uart_putc(1);   // 1 byte to follow
    uart_putc(NAK);
}

/* Command: Reset uPD16432B Emulator
 * Arguments: none
 * Returns: <ack>
 *
 * Reset the uPD16432B Emulator to its default state.  This does not
 * affect the UPD key data output bytes (upd_tx_key_data).
 */
static void _do_emulated_upd_reset()
{
    if (cmd_buf_index != 1)
    {
        _reply_nak();
        return;
    }

    upd_init(&emulated_upd_state);
    _reply_ack();
}

static uint8_t _dump_upd_state_to_uart(upd_state_t *state)
{
    // Bail out if any command arguments were given.
    if (cmd_buf_index != 1)
    {
        return 0;
    }

    uint8_t size;
    size = 1 + // ACK byte
           1 + // ram_area
           1 + // ram_size
           1 + // address
           1 + // increment
           1 + // dirty_flags
           UPD_DISPLAY_RAM_SIZE +
           UPD_PICTOGRAPH_RAM_SIZE +
           UPD_CHARGEN_RAM_SIZE;

    uart_putc(size); // number of bytes to follow
    uart_putc(ACK);
    uart_putc(state->ram_area);
    uart_putc(state->ram_size);
    uart_putc(state->address);
    uart_putc(state->increment);
    uart_putc(state->dirty_flags);

    uint8_t i;
    for (i=0; i<UPD_DISPLAY_RAM_SIZE; i++)
    {
        uart_putc(state->display_ram[i]);
    }

    for (i=0; i<UPD_PICTOGRAPH_RAM_SIZE; i++)
    {
        uart_putc(state->pictograph_ram[i]);
    }

    for (i=0; i<UPD_CHARGEN_RAM_SIZE; i++)
    {
        uart_putc(state->chargen_ram[i]);
    }

    return 1;
}

/* Command: Dump uPD16432B Emulator State
 * Arguments: none
 * Returns: <ack> <all bytes in emulated_upd_state>
 *
 * Dump the current state of the uPD16432B emulator.
 */
static void _do_emulated_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&emulated_upd_state);
    if (! success)
    {
        return _reply_nak();
    }
}

/* Populate a upd_command_t from the UART command buffer
 * Returns 1 on success, 0 on failure.
 */
static uint8_t _populate_cmd_from_uart_cmd_buf(upd_command_t *cmd)
{
    // Bail out if size of bytes from UART exceeds uPD16432B command max size.
    // -1 is because first byte in cmd_buf is the uart command byte
    if ((cmd_buf_index - 1) > sizeof(cmd->data))
    {
        return 0; // failure
    }

    // Populate uPD16432B command request with bytes from UART
    uint8_t size = cmd_buf_index - 1;
    memcpy(cmd->data, cmd_buf+1, size);
    cmd->size = size;

    return 1; // success
}

/* Command: Send uPD16432B Emulator Command
 * Arguments: <cmd arg byte0> <cmd arg byte1> ...
 * Returns: <ack>
 *
 * Sends a fake SPI command to the uPD16432B Emulator.  The arguments
 * are the SPI bytes that would be received by the uPD16432B while it
 * is selected with STB high.
 */
static void _do_emulated_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (! success)
    {
        return _reply_nak();
    }

    // Process uPD16432B command request as if we received it over SPI
    upd_process_command(&emulated_upd_state, &cmd);
    return _reply_ack();
}

/* Command: Load uPD16432B Emulator Key Data
 * Arguments: <key0> <key1> <key2> <key3>
 * Returns: <ack>
 *
 * Load the four bytes of the uPD16432B emulator key data.  These bytes
 * will be sent to the radio whenever a key data request command is received.
 * The same bytes will be sent for every key data request until the bytes
 * are changed.  Set {0, 0, 0, 0} to indicate no keys pressed.
 */
static void _do_emulated_upd_load_key_data()
{
    // can't load key data while key passthru is enabled because
    // the data we'd load would be immediately overwritten by passthru
    if (auto_key_passthru)
    {
        _reply_nak();
        return;
    }

    if (cmd_buf_index != 5)
    {
        _reply_nak();
        return;
    }

    // load the four key data bytes
    uint8_t i;
    for (i=0; i<sizeof(upd_tx_key_data); i++)
    {
        upd_tx_key_data[i] = cmd_buf[i+1];
    }

    _reply_ack();
}

/* Command: Radio State Reset
 * Arguments: none
 * Returns: <ack>
 */
static void _do_radio_state_reset()
{
    if (cmd_buf_index != 1)
    {
        _reply_nak();
        return;
    }

    radio_state_init(&radio_state);
    _reply_ack();
}

/* Command: Radio State Process
 * Arguments: <byte1>
 * Returns: <ack>
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
        _reply_nak();
        return;
    }

    // Initialize empty display data buffer
    uint8_t display_ram[UPD_DISPLAY_RAM_SIZE];
    memset(display_ram, 0, UPD_DISPLAY_RAM_SIZE);

    // Populate display data buffer with UART data
    memcpy(display_ram, cmd_buf+1, data_size);

    radio_state_parse(&radio_state, display_ram);
    _reply_ack();
}

/* Command: Radio State Dump
 * Arguments: <byte1>
 * Returns: <ack>
 */
static void _do_radio_state_dump()
{
    if (cmd_buf_index != 1)
    {
        _reply_nak();
        return;
    }

    uart_putc(34); // number of bytes to follow
    uart_putc(ACK);
    uart_putc(radio_state.operation_mode);
    uart_putc(radio_state.display_mode);
    uart_putc(radio_state.safe_tries);
    uart_putc(radio_state.safe_code & 0x00FF);
    uart_putc((radio_state.safe_code & 0xFF00) >> 8);
    uart_putc(radio_state.sound_bass);
    uart_putc(radio_state.sound_treble);
    uart_putc(radio_state.sound_midrange);
    uart_putc(radio_state.sound_balance);
    uart_putc(radio_state.sound_fade);
    uart_putc(radio_state.tape_side);
    uart_putc(radio_state.cd_disc);
    uart_putc(radio_state.cd_track);
    uart_putc(radio_state.cd_track_pos & 0x00FF);
    uart_putc((radio_state.cd_track_pos & 0xFF00) >> 8);
    uart_putc(radio_state.tuner_freq & 0x00FF);
    uart_putc((radio_state.tuner_freq & 0xFF00) >> 8);
    uart_putc(radio_state.tuner_preset);
    uart_putc(radio_state.tuner_band);
    uint8_t i;
    for (i=0; i<11; i++)
    {
        uart_putc(radio_state.display[i]);
    }
    uart_putc(radio_state.option_on_vol);
    uart_putc(radio_state.option_cd_mix);
    uart_putc(radio_state.option_tape_skip);
}

/* Command: Echo
 * Arguments: <arg1> <arg2> <arg3> ...
 * Returns: <ack> <arg1> <arg1> <arg3> ...
 *
 * Echoes the arguments received back to the client.  If no args were
 * received after the command byte, an empty ACK response is returned.
 */
static void _do_echo()
{
    uart_putc(cmd_buf_index); // number of bytes to follow
    uart_putc(ACK);
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
        uart_putc(cmd_buf[i]);
        uart_flush_tx();
    }
}

/* Command: Set LED
 * Arguments: <led number> <led state>
 * Returns: <ack|nak>
 *
 * Turns one of the LEDs on or off.  Returns a NAK if the LED
 * number is not recognized.
 */
static void _do_set_led()
{
    if (cmd_buf_index != 3)
    {
        _reply_nak();
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
            _reply_nak();
            return;
    }

    _reply_ack();
}

/* Command: Set Run Mode
 * Arguments: <run mode>
 * Returns: <ack|nak>
 *
 * Sets the run mode to either RUN_MODE_RUNNING or RUN_MODE_STOPPED.  This is
 * mainly used for testing.  When stopped, commands from the radio are ignored
 * and the faceplate is not updated.
 */
static void _do_set_run_mode()
{
    if (cmd_buf_index != 2)
    {
        _reply_nak();
        return;
    }

    uint8_t mode = cmd_buf[1];
    if ((mode != RUN_MODE_RUNNING) && (mode != RUN_MODE_STOPPED))
    {
        _reply_nak();
        return;
    }

    run_mode = mode;
    _reply_ack();
}

/* Command: Set passthru of emulated uPD display to the real faceplate
 * Arguments: <0|1>
 * Returns: <ack|nak>
 *
 * Sets whether the faceplate will be automatically updated with the display
 * from the radio.  Set to 1 to enable passthru, or set to 0 to disable
 * passthru so the faceplate display can be taken over.
 */
static void _do_set_auto_display_passthru()
{
    if (cmd_buf_index != 2)
    {
        _reply_nak();
        return;
    }

    uint8_t onoff = cmd_buf[1];
    if ((onoff != 0) && (onoff != 1))
    {
        _reply_nak();
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

    _reply_ack();
}

/* Command: Set passthru of keys on the real faceplate to the emulated uPD
 * Argument: <0|1>
 * Returns: <ack|nak>
 *
 * Sets whether key presses on the faceplate will be automatically passed on
 * to the radio.  Set to 1 to enable passthru, or set to 0 to disable
 * passthru so the faceplate keys can be taken over.
 */
static void _do_set_auto_key_passthru()
{
    if (cmd_buf_index != 2)
    {
        _reply_nak();
        return;
    }

    uint8_t onoff = cmd_buf[1];
    if ((onoff != 0) && (onoff != 1))
    {
        _reply_nak();
        return;
    }
    auto_key_passthru = onoff;

    _reply_ack();
}

/* Command: Dump the real faceplate's uPD16432B state
 * Arguments: none
 * Returns: <ack> <all bytes in faceplate_upd_state>
 *
 * Dump the current state of the real uPD16432B on the faceplate.
 */
static void _do_faceplate_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&faceplate_upd_state);
    if (! success)
    {
        return _reply_nak();
    }
}

/* Command: Send command to faceplate's uPD16432B
 * Arguments: <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <ack>
 *
 * Send an SPI command to the faceplate's uPD16432B.
 */
static void _do_faceplate_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success;
    success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (! success)
    {
        return _reply_nak();
    }

    faceplate_send_upd_command(&cmd);
    return _reply_ack();
}

/* Command: Clear the faceplate's display
 * Arguments: none
 * Returns: <ack|nak>
 *
 * Sends SPI commands to initialize the faceplate and clear it.
 */
static void _do_faceplate_upd_clear_display()
{
    if (cmd_buf_index != 1)
    {
        _reply_nak();
        return;
    }

    faceplate_clear_display();
    return _reply_ack();
}

/* Command: Read the faceplate's raw key data
 * Arguments: none
 * Returns: <ack> <byte0> <byte1> <byte2> <byte3>
 *
 * Reads the key data from the faceplate and returns the 4 raw key data bytes.
 */
 static void _do_faceplate_upd_read_key_data()
 {
     if (cmd_buf_index != 1)
     {
         _reply_nak();
         return;
     }

     uint8_t key_data[4] = {0, 0, 0, 0};
     faceplate_read_key_data(key_data);

     uart_putc(5); // number of bytes to follow
     uart_putc(ACK);
     uart_putc(key_data[0]);
     uart_putc(key_data[1]);
     uart_putc(key_data[2]);
     uart_putc(key_data[3]);
 }

/* Command: Convert uPD16432B raw key data bytes to key codes
 * Arguments: <byte0> <byte1> <byte2> <byte3>
 * Returns: <ack> <num_keycodes> <keycode0> <keycode1>
 *
 * Convert uPD16432B key data to key codes (the KEY_ constants).  Returns 0, 1,
 * or 2 key codes.  The first byte indicates the number of key codes.  2 key
 * code bytes are always returned; unused bytes are set to 0.
 */
static void _do_convert_upd_key_data_to_key_codes()
{
    // command byte + 4 key data bytes
    if (cmd_buf_index != 5)
    {
        _reply_nak();
        return;
    }

    uint8_t key_codes[2];
    uint8_t num_keys_pressed;
    num_keys_pressed = convert_upd_key_data_to_codes(cmd_buf+1, key_codes);

    uart_putc(4); // number of bytes to follow
    uart_putc(ACK);
    uart_putc(num_keys_pressed);
    uart_putc(key_codes[0]);
    uart_putc(key_codes[1]);
}

/* TODO document me
 */
static void _do_convert_code_to_upd_key_data()
{
    if (cmd_buf_index != 2)
    {
        _reply_nak();
        return;
    }

    uint8_t key_code = cmd_buf[1];
    uint8_t key_data[4] = {0, 0, 0, 0};
    uint8_t success = convert_code_to_upd_key_data(key_code, key_data);
    if (! success) // key code not found
    {
        _reply_nak();
        return;
    }

    uart_putc(5); // number of bytes to follow
    uart_putc(ACK);
    uart_putc(key_data[0]);
    uart_putc(key_data[1]);
    uart_putc(key_data[2]);
    uart_putc(key_data[3]);
}

/* TODO document me
 */
static void _do_read_keys()
{
    // TODO check args length

    // Read keys from the faceplate
    uint8_t key_data[4] = {0, 0, 0, 0};
    faceplate_read_key_data(key_data);

    // Convert uPD16432B key raw data to key codes
    uint8_t key_codes[2] = {0, 0};
    uint8_t num_pressed = convert_upd_key_data_to_codes(key_data, key_codes);

    uart_putc(4); // number of bytes to follow
    uart_putc(ACK);
    uart_putc(num_pressed);
    uart_putc(key_codes[0]);
    uart_putc(key_codes[1]);
}

/* TODO document me
 */
static void _do_load_keys()
{
    // TODO check args length

    // can't load key data while key passthru is enabled because
    // the data we'd load would be immediately overwritten by passthru
    if (auto_key_passthru)
    {
        _reply_nak();
        return;
    }

    uint8_t key_data[4] = {0, 0, 0, 0};
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
        // get key upd data bytes for this one key
        uint8_t one_key_data[4] = {0, 0, 0, 0};
        uint8_t success = convert_code_to_upd_key_data(cmd_buf[i], one_key_data);
        if (! success) // bad key code
        {
            _reply_nak();
            return;
        }

        // merge the one key into final key data
        key_data[0] |= one_key_data[0];
        key_data[1] |= one_key_data[1];
        key_data[2] |= one_key_data[2];
        key_data[3] |= one_key_data[3];
    }

    // load the four key data bytes
    for (i=0; i<4; i++)
    {
        upd_tx_key_data[i] = key_data[i];
    }

    _reply_ack();
}

/* Dispatch a command.  A complete command packet has been received.  The
 * command buffer has one more bytes.  The first byte is the command byte.
 * Dispatch to a handler, or return a NAK if the command is unrecognized.
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

        case CMD_CONVERT_UPD_KEY_DATA_TO_KEY_CODES:
            _do_convert_upd_key_data_to_key_codes();
            break;
        case CMD_CONVERT_CODE_TO_UPD_KEY_DATA:
            _do_convert_code_to_upd_key_data();
            break;
        case CMD_READ_KEYS:
            _do_read_keys();
            break;
        case CMD_LOAD_KEYS:
            _do_load_keys();
            break;

        default:
            _reply_nak();
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
 *   <number of bytes to follow> <ack|nak> <arg> <arg> ...
 * Examples:
 *   01 06         Command acknowledged, no args
 *   02 06 AA      Command acknowledged, args: [AA]
 *   01 15         Command not acknowledged, no args
 *   03 15 AA 55   Command not acknowledged, args: [AA, 55]
 */
void cmd_receive_byte(uint8_t c)
{
    // receive command length byte
    if (cmd_expected_length == 0)
    {
        if (c == 0) // invalid, command length must be 1 byte or longer
        {
            _reply_nak();
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

