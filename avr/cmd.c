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
static void cmd_timer_start()
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
static void cmd_timer_stop()
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
    cmd_timer_stop();
    cmd_init();
}

static void cmd_reply_ack()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(ACK);  // ACK byte
    uart_flush_tx();
}

static void cmd_reply_nak()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(NAK);  // NAK byte
    uart_flush_tx();
}

/* Command: Reset uPD16432B Emulator
 * Arguments: none
 * Returns: <ack>
 *
 * Reset the uPD16432B Emulator to its default state.  This does not
 * affect the UPD key data output bytes (upd_tx_key_data).
 */
static void cmd_do_emulated_upd_reset()
{
    if (cmd_buf_index != 1)
    {
        cmd_reply_nak();
        return;
    }

    upd_init(&emulated_upd_state);
    cmd_reply_ack();
}

uint8_t _dump_upd_state_to_uart(upd_state_t *state)
{
    // Bail out if any command arguments were given.
    if (cmd_buf_index != 1)
    {
        return 0;
    }

    uint8_t size;
    size = 1 + // ACK byte
           1 + // Selected RAM area
           1 + // Size of selected RAM area
           1 + // Current address in that area
           1 + // Address increment mode on/off
           UPD_DISPLAY_RAM_SIZE +
           1 + // dirty byte for display data ram
           UPD_PICTOGRAPH_RAM_SIZE +
           1 + // dirty byte for pictograph ram
           UPD_CHARGEN_RAM_SIZE +
           1; // dirty byte for chargen ram

    uart_putc(size); // number of bytes to follow
    uart_putc(ACK); // ACK byte
    uart_putc(state->ram_area);
    uart_putc(state->ram_size);
    uart_putc(state->address);
    uart_putc(state->increment);
    uart_flush_tx();

    // dump display data ram & dirty byte
    uint8_t i;
    for (i=0; i<UPD_DISPLAY_RAM_SIZE; i++)
    {
        uart_putc(state->display_ram[i]);
    }
    uart_putc(state->display_ram_dirty);
    uart_flush_tx();

    // dump pictograph ram & dirty byte
    for (i=0; i<UPD_PICTOGRAPH_RAM_SIZE; i++)
    {
        uart_putc(state->pictograph_ram[i]);
    }
    uart_putc(state->pictograph_ram_dirty);
    uart_flush_tx();

    // dump chargen ram & dirty byte
    for (i=0; i<UPD_CHARGEN_RAM_SIZE; i++)
    {
        uart_putc(state->chargen_ram[i]);
    }
    uart_putc(state->chargen_ram_dirty);
    uart_flush_tx();

    return 1;
}

/* Command: Dump uPD16432B Emulator State
 * Arguments: none
 * Returns: <ack> <all bytes in emulated_upd_state>
 *
 * Dump the current state of the uPD16432B emulator.
 */
static void cmd_do_emulated_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&emulated_upd_state);
    if (success == 0)
    {
        return cmd_reply_nak();
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
 * Arguments: <cmd byte> <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <ack>
 *
 * Sends a fake SPI command to the uPD16432B Emulator.  The arguments
 * are the SPI bytes that would be received by the uPD16432B while it
 * is selected with STB high.
 */
static void cmd_do_emulated_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (success == 0)
    {
        return cmd_reply_nak();
    }

    // Process uPD16432B command request as if we received it over SPI
    upd_process_command(&emulated_upd_state, &cmd);
    return cmd_reply_ack();
}

/* Command: Load uPD16432B Emulator Key Data
 * Arguments: <cmd byte> <key0> <key1> <key2> <key3>
 * Returns: <ack>
 *
 * Load the four bytes of the uPD16432B emulator key data.  These bytes
 * will be sent to the radio whenever a key data request command is received.
 * The same bytes will be sent for every key data request until the bytes
 * are changed.  Set {0, 0, 0, 0} to indicate no keys pressed.
 */
static void cmd_do_radio_load_key_data()
{
    if (cmd_buf_index != 5)
    {
        cmd_reply_nak();
        return;
    }

    // load the four key data bytes
    uint8_t i;
    for (i=0; i<4; i++)
    {
        upd_tx_key_data[i] = cmd_buf[i+1];
    }

    cmd_reply_ack();
}


static void cmd_do_radio_state_reset()
{
    // TODO arg length checking

    radio_state_init(&radio_state);
    cmd_reply_ack();
}


static void cmd_do_radio_state_process()
{
    // TODO arg length checking

    // Bail out if size of bytes from UART exceeds display RAM size
    // -1 is because first byte in cmd_buf is the uart command byte
    if ((cmd_buf_index - 1) > UPD_DISPLAY_RAM_SIZE)
    {
        cmd_reply_nak();
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
    cmd_reply_ack();
}


static void cmd_do_radio_state_dump()
{
    // TODO arg length checking

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
static void cmd_do_echo()
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
static void cmd_do_set_led()
{
    if (cmd_buf_index != 3)
    {
        cmd_reply_nak();
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
            cmd_reply_nak();
            return;
    }

    cmd_reply_ack();
}

/* Command: Set Run Mode
 * Arguments: <mode>
 * Returns: <ack|nak>
 *
 * Sets the current running mode (one of the RUN_MODE_* constants).  In
 * test mode, SPI commands from the radio are ignored so the uPD16432B
 * code can be tested.
 */
static void cmd_do_set_run_mode()
{
    if (cmd_buf_index != 2)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t mode = cmd_buf[1];

    switch (mode)
    {
        case CMD_ARG_RUN_MODE_NORMAL:
            run_mode = RUN_MODE_NORMAL;
            break;

        case CMD_ARG_RUN_MODE_TEST:
            run_mode = RUN_MODE_TEST;
            break;

        default:
            return cmd_reply_nak();
    }

    cmd_reply_ack();
}

/* Command: Dump the real faceplate's uPD16432B state
 * Arguments: none
 * Returns: <ack> <all bytes in faceplate_upd_state>
 *
 * Dump the current state of the real uPD16432B on the faceplate.
 */
static void cmd_do_faceplate_upd_dump_state()
{
    uint8_t success;
    success = _dump_upd_state_to_uart(&faceplate_upd_state);
    if (success == 0)
    {
        return cmd_reply_nak();
    }
}

/* Command: Send command to faceplate's uPD16432B
 * Arguments: <cmd byte> <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <ack>
 *
 * Send an SPI command to the faceplate's uPD16432B.
 */
static void cmd_do_faceplate_upd_send_command()
{
    upd_command_t cmd;

    uint8_t success;
    success = _populate_cmd_from_uart_cmd_buf(&cmd);
    if (success == 0)
    {
        return cmd_reply_nak();
    }

    faceplate_send_upd_command(&cmd);
    return cmd_reply_ack();
}

/* Command: Clear the faceplate's display
 * Arguments: none
 * Returns: <ack|nak>
 *
 * Sends SPI commands to initialize the faceplate and clear it.
 */
static void cmd_do_faceplate_clear_display()
{
    if (cmd_buf_index != 1)
    {
        cmd_reply_nak();
        return;
    }

    faceplate_clear_display();
    return cmd_reply_ack();
}

/* Dispatch a command.  A complete command packet has been received.  The
 * command buffer has one more bytes.  The first byte is the command byte.
 * Dispatch to a handler, or return a NAK if the command is unrecognized.
 */
static void cmd_dispatch()
{
    switch (cmd_buf[0])
    {
        case CMD_SET_LED:
            cmd_do_set_led();
            break;
        case CMD_ECHO:
            cmd_do_echo();
            break;
        case CMD_SET_RUN_MODE:
            cmd_do_set_run_mode();
            break;

        case CMD_RADIO_LOAD_KEY_DATA:
            cmd_do_radio_load_key_data();
            break;

        case CMD_RADIO_STATE_PROCESS:
            cmd_do_radio_state_process();
            break;
        case CMD_RADIO_STATE_DUMP:
            cmd_do_radio_state_dump();
            break;
        case CMD_RADIO_STATE_RESET:
            cmd_do_radio_state_reset();
            break;

        case CMD_EMULATED_UPD_DUMP_STATE:
            cmd_do_emulated_upd_dump_state();
            break;
        case CMD_EMULATED_UPD_SEND_COMMAND:
            cmd_do_emulated_upd_send_command();
            break;
        case CMD_EMULATED_UPD_RESET:
            cmd_do_emulated_upd_reset();
            break;

        case CMD_FACEPLATE_UPD_DUMP_STATE:
            cmd_do_faceplate_upd_dump_state();
            break;
        case CMD_FACEPLATE_UPD_SEND_COMMAND:
            cmd_do_faceplate_upd_send_command();
            break;
        case CMD_FACEPLATE_CLEAR_DISPLAY:
            cmd_do_faceplate_clear_display();
            break;

        default:
            cmd_reply_nak();
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
            cmd_reply_nak();
            cmd_init();
        }
        else
        {
            cmd_expected_length = c;
            cmd_timer_start();
        }
    }
    // receive command byte(s)
    else
    {
        cmd_buf[cmd_buf_index++] = c;
        cmd_timer_start();

        if (cmd_buf_index == cmd_expected_length)
        {
            cmd_timer_stop();
            cmd_dispatch();
            cmd_init();
        }
    }
}
