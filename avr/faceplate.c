#include <stdint.h>
#include <avr/io.h>
#include "updemu.h"

/*************************************************************************
 * SPI Master Interface to Faceplate
 *************************************************************************/

void faceplate_spi_init()
{
    // PA0: RST out to faceplate
    DDRA |= _BV(PA0);
    PORTA |= _BV(PA0);
    // PA1: LOF out to faceplate
    DDRA |= _BV(PA1);
    PORTA |= _BV(PA1);

    // PD2/RXD1 MISO as input (from faceplate's DAT)
    DDRD &= ~_BV(PD2);
    // PD3/TXD1 MOSI as output (to faceplate's DAT through 10K resistor?)
    DDRD |= _BV(PD3);
    // PD4/XCK1 SCK as output (to faceplate's CLK)
    DDRD |= _BV(PD4);
    // PD7 as output (to faceplate's STB)
    DDRD |= _BV(PD7);
    // PD7 initially low (faceplate STB = not selected)
    PORTD &= ~_BV(PD7);

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

void faceplate_send_upd_command(upd_command_t *cmd)
{
    // Bail out if command is empty so we don't assert STB with no bytes
    if (cmd->size == 0)
    {
        return;
    }

    // STB=high (start of transfer)
    PORTD |= _BV(PD7);

    // Send each byte
    uint8_t i;
    for (i=0; i<cmd->size; i++)
    {
        faceplate_spi_xfer_byte(cmd->data[i]);
    }

    // STB=low (end of transfer)
    PORTD &= ~_BV(PD7);
}

void faceplate_clear_display()
{
    upd_command_t cmd;
    uint8_t i;

    // Display Setting command
    cmd.data[0] = 0x04;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Status command
    cmd.data[0] = 0xcf;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Data Setting command: write to pictograph ram
    cmd.data[0] = 0x41;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Address Setting command + pictograph data
    cmd.data[0] = 0x80;
    for (i=1; i<9; i++)
    {
        cmd.data[i] = 0;
    }
    cmd.size = 9;
    faceplate_send_upd_command(&cmd);

    // Data Setting command: write to display data ram
    cmd.data[0] = 0x40;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // Address Setting command + display data
    cmd.data[0] = 0x80;
    for (i=1; i<17; i++)
    {
        cmd.data[i] = 0x20;
    }
    cmd.size = 17;
    faceplate_send_upd_command(&cmd);
}

void faceplate_write_upd_ram(uint8_t data_setting_cmd,
    uint8_t data_size, uint8_t *data)
{
    upd_command_t cmd;
    uint8_t i;

    // send data setting command: write to display data ram
    cmd.data[0] = data_setting_cmd;
    cmd.size = 1;
    faceplate_send_upd_command(&cmd);

    // send address setting command + 16 bytes display data
    cmd.data[0] = 0x80;
    for (i=0; i<data_size; i++)
    {
        cmd.data[i+1] = data[i];
    }
    cmd.size = 1 + data_size;
    faceplate_send_upd_command(&cmd);
}
