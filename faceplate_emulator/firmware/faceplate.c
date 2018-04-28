#include <stdint.h>
#include <string.h>
#include <avr/io.h>
#include "faceplate.h"
#include "updemu.h"

/*************************************************************************
 * SPI Master Interface to Faceplate
 *************************************************************************/

// Start or stop SPI communication with the faceplate depending on the state
// of the /LOF signal (LCD OFF).  The radio controls the /LOF signal.  When the
// Premium 4 radio asserts /LOF, it also shuts off MAIN5V.  We must stop
// driving the SPI lines or else ~4V will leak into MAIN5V when it's supposed
// to be off, the effect of which is a malfunction where the radio can't be
// turned back on after being turned off.
void faceplate_service_lof()
{
    if (faceplate_lof_asserted()) {
        if (faceplate_online) {
            // radio has just turned off the faceplate so we must release it
            faceplate_spi_release();
        }
    } else {
        if (! faceplate_online) {
            // radio has just turned on the faceplate so we must (re)init it
            faceplate_spi_init();
            faceplate_clear_display();
        }
    }
}

// Start SPI communication with the faceplate.  Don't use this directly;
// call faceplate_service_lof() instead.
void faceplate_spi_init()
{
    // PD2/RXD1 MISO as input (from faceplate's DAT)
    DDRD &= ~_BV(PD2);
    // PD3/TXD1 MOSI as output (to faceplate's DAT through 10K resistor)
    DDRD |= _BV(PD3);
    // PD4/XCK1 SCK as output (to faceplate's CLK)
    DDRD |= _BV(PD4);
    // PD5 as output (to faceplate's STB)
    DDRD |= _BV(PD5);
    // PD6 as input (from faceplate's /BUS)
    DDRD &= ~_BV(PD6);
    // PD5 initially low (faceplate STB = not selected)
    PORTD &= ~_BV(PD5);

    // must be done first
    UBRR1 = 0;
    // preset transmit complete flag
    UCSR1A = _BV(TXC1);
    // Master SPI mode, CPOL=1 (bit 1), CPHA=1 (bit 0)
    UCSR1C = _BV(UMSEL10) | _BV(UMSEL11) | 2 | 1;
    // transmit enable and receive enable
    UCSR1B = _BV(TXEN1) | _BV(RXEN1);
    // must be done last
    // spi clock (9 = 1mhz for 20mhz clock)
    UBRR1 = 9;

    faceplate_online = 1;
}

// Stop SPI communication with the faceplate.  Don't use this directly;
// call faceplate_service_lof() instead.
void faceplate_spi_release()
{
    DDRD &= ~(_BV(PD2) | _BV(PD3) | _BV(PD4) | _BV(PD5) | _BV(PD6));
    UCSR1C = 0;
    UCSR1B = 0;

    faceplate_online = 0;
}

// Returns true if the radio is asserting /LOF to the faceplate's
// uPD16432B meaning it has shut the faceplate off.
uint8_t faceplate_lof_asserted()
{
    return (PINA & _BV(PA1)) == 0;
}

uint8_t faceplate_spi_xfer_byte(uint8_t c)
{
    // wait for transmitter ready
    while ((UCSR1A & _BV(UDRE1)) == 0);

    // send byte
    UDR1 = c;

    // wait for receiver ready
    while ((UCSR1A & _BV (RXC1)) == 0);

    // receive byte, return it
    return UDR1;
}

void faceplate_read_key_data(volatile uint8_t *key_data)
{
    // STB=high (start of transfer)
    PORTD |= _BV(PD5);

    faceplate_spi_xfer_byte(0x44); // key data request command

    key_data[0] = faceplate_spi_xfer_byte(0xFF);
    key_data[1] = faceplate_spi_xfer_byte(0xFF);
    key_data[2] = faceplate_spi_xfer_byte(0xFF);
    key_data[3] = faceplate_spi_xfer_byte(0xFF);

    // STB=low (end of transfer)
    PORTD &= ~_BV(PD5);
}

void faceplate_send_upd_command(upd_command_t *cmd)
{
    // Bail out if command is empty so we don't assert STB with no bytes
    if (cmd->size == 0)
    {
        return;
    }

    // STB=high (start of transfer)
    PORTD |= _BV(PD5);

    // Send each byte
    uint8_t i;
    for (i=0; i<cmd->size; i++)
    {
        faceplate_spi_xfer_byte(cmd->data[i]);
    }

    // STB=low (end of transfer)
    PORTD &= ~_BV(PD5);

    // The real uPD16432B doesn't have a way to read back its registers so
    // we use an instance of the emulator to remember them.
    upd_process_command(&faceplate_upd_state, cmd);
}

static void _prepare_display()
{
    upd_command_t cmd;

    // Display Setting command
    cmd.data[0] = 0x04;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Status command
    cmd.data[0] = 0xcf;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);
}

void faceplate_clear_display()
{
    upd_command_t cmd;

    _prepare_display();

    // Data Setting command: write to pictograph ram
    cmd.data[0] = 0x41;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Address Setting command + pictograph data
    cmd.data[0] = 0x80;
    memset(cmd.data + 1, 0x00, UPD_PICTOGRAPH_RAM_SIZE);
    cmd.size = 1 + UPD_PICTOGRAPH_RAM_SIZE;
    faceplate_send_upd_command(&cmd);

    // Data Setting command: write to display ram
    cmd.data[0] = 0x40;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Address Setting command + display data
    cmd.data[0] = 0x80;
    memset(cmd.data + 1, 0x20, UPD_DISPLAY_RAM_SIZE);
    cmd.size = 1 + UPD_DISPLAY_RAM_SIZE;
    faceplate_send_upd_command(&cmd);
}

static void _write_ram(
    uint8_t data_setting_cmd, uint8_t address,
    uint8_t data_size, uint8_t *data)
{
    upd_command_t cmd;

    // send data setting command: write to display ram
    cmd.data[0] = data_setting_cmd;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // send address setting command + data bytes
    cmd.data[0] = 0x80 + address;
    memcpy(cmd.data + 1, data, data_size);
    cmd.size = 1 + data_size;
    faceplate_send_upd_command(&cmd);
}

// copy emulated upd display to real faceplate
void faceplate_update_from_upd_if_dirty(upd_state_t *state)
{
    // Always re-prepare if anything is dirty to ensure the faceplate
    // display is turned on.  This allows the faceplate to be disconnected
    // and still be visible when it is reconnected again.
    if (state->dirty_flags)
    {
        _prepare_display();
    }

    if (state->dirty_flags & UPD_DIRTY_DISPLAY)
    {
        _write_ram(
            0x40, // data setting command: display ram
            0,    // address
            sizeof(state->display_ram),
            state->display_ram
            );
    }

    if (state->dirty_flags & UPD_DIRTY_PICTOGRAPH)
    {
        _write_ram(
            0x41, // data setting command: pictograph ram
            0,    // address
            sizeof(state->pictograph_ram),
            state->pictograph_ram
            );
    }

    if (state->dirty_flags & UPD_DIRTY_CHARGEN)
    {
        uint8_t charnum;

        for (charnum=0; charnum<0x10; charnum++)
        {
            _write_ram(
                0x4a,    // data setting command: chargen ram
                charnum, // address = character number
                7,       // size = 7 bytes per char
                state->chargen_ram + (charnum * 7) // data for this char
                );
        }
    }

    if (state->dirty_flags & UPD_DIRTY_LED)
    {
        _write_ram(
            0x4b, // data setting command: led output latch
            0,    // address
            sizeof(state->led_ram),
            state->led_ram
            );
    }
}
