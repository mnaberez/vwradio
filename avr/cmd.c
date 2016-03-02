#include <stdint.h>
#include "cmd.h"
#include "leds.h"
#include "main.h"
#include "faceplate.h"
#include "radio_spi.h"
#include "radio_state.h"
#include "uart.h"
#include "updemu.h"
#include <avr/io.h>
#include <avr/interrupt.h>

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
static void _cmd_timer_start()
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
static void _cmd_timer_stop()
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
    _cmd_timer_stop();
    cmd_init();
}

static void _cmd_reply_ack()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(ACK);  // ACK byte
}

static void _cmd_reply_nak()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(NAK);  // NAK byte
}

/* Command: Reset uPD16432B Emulator
 * Arguments: none
 * Returns: <ack>
 *
 * Reset the uPD16432B Emulator to its default state.  This does not
 * affect the UPD key data output bytes (upd_tx_key_data).
 */
static void _cmd_do_emulated_upd_reset()
{
    if (cmd_buf_index != 1)
    {
        _cmd_reply_nak();
        return;
    }

    upd_init(&emulated_upd_state);
    _cmd_reply_ack();
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
    uart_putc(ACK); // ACK byte
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
static void _cmd_do_emulated_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&emulated_upd_state);
    if (success == 0)
    {
        return _cmd_reply_nak();
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
        return 0;
    }

    // Populate uPD16432B command request with bytes from UART
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
        cmd->data[i-1] = cmd_buf[i];
    }
    cmd->size = i-1;
    return 1;
}

/* Command: Send uPD16432B Emulator Command
 * Arguments: <cmd arg byte0> <cmd arg byte1> ...
 * Returns: <ack>
 *
 * Sends a fake SPI command to the uPD16432B Emulator.  The arguments
 * are the SPI bytes that would be received by the uPD16432B while it
 * is selected with STB high.
 */
static void _cmd_do_emulated_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (success == 0)
    {
        return _cmd_reply_nak();
    }

    // Process uPD16432B command request as if we received it over SPI
    upd_process_command(&emulated_upd_state, &cmd);
    return _cmd_reply_ack();
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
static void _cmd_do_emulated_upd_load_key_data()
{
    if (cmd_buf_index != 5)
    {
        _cmd_reply_nak();
        return;
    }

    // load the four key data bytes
    uint8_t i;
    for (i=0; i<4; i++)
    {
        upd_tx_key_data[i] = cmd_buf[i+1];
    }

    _cmd_reply_ack();
}

/* Command: Radio State Reset
 * Arguments: <byte0> <byte1> ...
 * Returns: <ack>
 */
static void _cmd_do_radio_state_reset()
{
    if (cmd_buf_index != 1)
    {
        _cmd_reply_nak();
        return;
    }

    radio_state_init(&radio_state);
    _cmd_reply_ack();
}

/* Command: Radio State Process
 * Arguments: <byte1>
 * Returns: <ack>
 */
static void _cmd_do_radio_state_process()
{
    // TODO arg length checking

    // Bail out if size of bytes from UART exceeds display RAM size
    // -1 is because first byte in cmd_buf is the uart command byte
    if ((cmd_buf_index - 1) > UPD_DISPLAY_RAM_SIZE)
    {
        _cmd_reply_nak();
        return;
    }

    // Initialize empty data buffer
    uint8_t display_ram[UPD_DISPLAY_RAM_SIZE];
    uint8_t i;
    for (i=0; i<sizeof(display_ram); i++)
    {
        display_ram[i] = 0;
    }

    // Populate data buffer with UART data
    for (i=1; i<cmd_buf_index; i++)
    {
        display_ram[i-1] = cmd_buf[i];
    }

    radio_state_process(&radio_state, display_ram);
    _cmd_reply_ack();
}

/* Command: Radio State Dump
 * Arguments: <byte1>
 * Returns: <ack>
 */
static void _cmd_do_radio_state_dump()
{
    if (cmd_buf_index != 1)
    {
        _cmd_reply_nak();
        return;
    }

    uart_putc(31); // number of bytes to follow
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
    uart_putc(radio_state.cd_cue_pos & 0x00FF);
    uart_putc((radio_state.cd_cue_pos & 0xFF00) >> 8);
    uart_putc(radio_state.tuner_freq & 0x00FF);
    uart_putc((radio_state.tuner_freq & 0xFF00) >> 8);
    uart_putc(radio_state.tuner_preset);
    uart_putc(radio_state.tuner_band);
    uint8_t i;
    for (i=0; i<11; i++)
    {
        uart_putc(radio_state.display[i]);
    }
}

/* Command: Echo
 * Arguments: <arg1> <arg2> <arg3> ...
 * Returns: <ack> <arg1> <arg1> <arg3> ...
 *
 * Echoes the arguments received back to the client.  If no args were
 * received after the command byte, an empty ACK response is returned.
 */
static void _cmd_do_echo()
{
    uart_putc(cmd_buf_index); // number of bytes to follow
    uart_putc(ACK); // ACK byte
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
static void _cmd_do_set_led()
{
    if (cmd_buf_index != 3)
    {
        _cmd_reply_nak();
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
            _cmd_reply_nak();
            return;
    }

    _cmd_reply_ack();
}

/* TODO document me
 */
static void _cmd_do_pass_radio_commands_to_emulated_upd()
{
    if (cmd_buf_index != 2)
    {
        _cmd_reply_nak();
        return;
    }

    // TODO check arg
    uint8_t c = cmd_buf[1];
    pass_radio_commands_to_emulated_upd = c;
    _cmd_reply_ack();
}

/* TODO document me
 */
static void _cmd_do_pass_emulated_upd_display_to_faceplate()
{
    if (cmd_buf_index != 2)
    {
        _cmd_reply_nak();
        return;
    }

    // TODO check arg
    uint8_t c = cmd_buf[1];
    pass_emulated_upd_display_to_faceplate = c;

    // if returning control of the faceplate to the emulated upd, force an
    // immediate update of the faceplate to restore the radio's display
    if (pass_emulated_upd_display_to_faceplate == 1)
    {
        emulated_upd_state.dirty_flags =
            UPD_DIRTY_DISPLAY |
            UPD_DIRTY_PICTOGRAPH |
            UPD_DIRTY_CHARGEN;
        faceplate_update_from_upd_if_dirty(&emulated_upd_state);
        emulated_upd_state.dirty_flags = UPD_DIRTY_NONE;
    }

    _cmd_reply_ack();
}

/* TODO document me
 */
static void _cmd_do_pass_faceplate_keys_to_emulated_upd()
{
    if (cmd_buf_index != 2)
    {
        _cmd_reply_nak();
        return;
    }

    // TODO check arg
    uint8_t c = cmd_buf[1];
    pass_faceplate_keys_to_emulated_upd = c;
    _cmd_reply_ack();
}

/* Command: Dump the real faceplate's uPD16432B state
 * Arguments: none
 * Returns: <ack> <all bytes in faceplate_upd_state>
 *
 * Dump the current state of the real uPD16432B on the faceplate.
 */
static void _cmd_do_faceplate_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&faceplate_upd_state);
    if (success == 0)
    {
        return _cmd_reply_nak();
    }
}

/* Command: Send command to faceplate's uPD16432B
 * Arguments: <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <ack>
 *
 * Send an SPI command to the faceplate's uPD16432B.
 */
static void _cmd_do_faceplate_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success;
    success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (success == 0)
    {
        return _cmd_reply_nak();
    }

    faceplate_send_upd_command(&cmd);
    return _cmd_reply_ack();
}

/* Command: Clear the faceplate's display
 * Arguments: none
 * Returns: <ack|nak>
 *
 * Sends SPI commands to initialize the faceplate and clear it.
 */
static void _cmd_do_faceplate_upd_clear_display()
{
    if (cmd_buf_index != 1)
    {
        _cmd_reply_nak();
        return;
    }

    faceplate_clear_display();
    return _cmd_reply_ack();
}

/* TODO document me
 */
 static void _cmd_do_faceplate_upd_read_key_data()
 {
     // todo check arguments
     uint8_t key_data[4] = {0, 0, 0, 0};
     faceplate_read_key_data(key_data);

     uart_putc(5); // number of bytes to follow
     uart_putc(ACK); // ACK byte
     uart_putc(key_data[0]);
     uart_putc(key_data[1]);
     uart_putc(key_data[2]);
     uart_putc(key_data[3]);
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
            _cmd_do_set_led();
            break;
        case CMD_ECHO:
            _cmd_do_echo();
            break;

        case CMD_PASS_RADIO_COMMANDS_TO_EMULATED_UPD:
            _cmd_do_pass_radio_commands_to_emulated_upd();
            break;
        case CMD_PASS_EMULATED_UPD_DISPLAY_TO_FACEPLATE:
            _cmd_do_pass_emulated_upd_display_to_faceplate();
            break;
        case CMD_PASS_FACEPLATE_KEYS_TO_EMULATED_UPD:
            _cmd_do_pass_faceplate_keys_to_emulated_upd();
            break;

        case CMD_RADIO_STATE_PROCESS:
            _cmd_do_radio_state_process();
            break;
        case CMD_RADIO_STATE_DUMP:
            _cmd_do_radio_state_dump();
            break;
        case CMD_RADIO_STATE_RESET:
            _cmd_do_radio_state_reset();
            break;

        case CMD_EMULATED_UPD_LOAD_KEY_DATA:
            _cmd_do_emulated_upd_load_key_data();
            break;
        case CMD_EMULATED_UPD_DUMP_STATE:
            _cmd_do_emulated_upd_dump_state();
            break;
        case CMD_EMULATED_UPD_SEND_COMMAND:
            _cmd_do_emulated_upd_send_command();
            break;
        case CMD_EMULATED_UPD_RESET:
            _cmd_do_emulated_upd_reset();
            break;

        case CMD_FACEPLATE_UPD_DUMP_STATE:
            _cmd_do_faceplate_upd_dump_state();
            break;
        case CMD_FACEPLATE_UPD_SEND_COMMAND:
            _cmd_do_faceplate_upd_send_command();
            break;
        case CMD_FACEPLATE_UPD_CLEAR_DISPLAY:
            _cmd_do_faceplate_upd_clear_display();
            break;
        case CMD_FACEPLATE_UPD_READ_KEY_DATA:
            _cmd_do_faceplate_upd_read_key_data();
            break;

        default:
            _cmd_reply_nak();
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
            _cmd_reply_nak();
            cmd_init();
        }
        else
        {
            cmd_expected_length = c;
            _cmd_timer_start();
        }
    }
    // receive command byte(s)
    else
    {
        cmd_buf[cmd_buf_index++] = c;
        _cmd_timer_start();

        if (cmd_buf_index == cmd_expected_length)
        {
            _cmd_timer_stop();
            _cmd_dispatch();
            cmd_init();
        }
    }
}
