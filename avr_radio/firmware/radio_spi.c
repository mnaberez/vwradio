#include "main.h"
#include "radio_spi.h"
#include "updemu.h"
#include <avr/interrupt.h>
#include <avr/io.h>

/*************************************************************************
 * SPI Slave interface to Radio
 *************************************************************************/

void radio_spi_init()
{
    // initialize buffer to receive commands
    upd_rx_buf.read_index = 0;
    upd_rx_buf.write_index = 0;
    upd_rx_buf.cmd_at_write_index = &upd_rx_buf.cmds[upd_rx_buf.write_index];
    upd_rx_buf.cmd_at_write_index->size = 0;

    // initialize key press data to be sent
    uint8_t i;
    for (i=0; i<sizeof(upd_tx_key_data); i++)
    {
        upd_tx_key_data[i] = 0;
    }

    // PA1 as input (/LOF from radio)
    // PA2 as input (EJECT from radio)
    // PA3 as input (/POWER_EJECT from radio)
    DDRA &= ~(_BV(PA1) | _BV(PA2) | _BV(PA3));

    // PB2 as input (STB from radio)
    DDRB &= ~_BV(PB2);
    // PB3 as output (/SS output we'll make in software from STB)
    DDRB |= _BV(PB3);
    // PB3 state initially high (/SS not asserted)
    PORTB |= _BV(PB3);
    // Set pin change enable mask 1 for PB2 (PCINT10) only
    PCMSK1 = _BV(PCINT10);
    // Enable interrupts from pin change group 1 only
    PCICR = _BV(PCIE1);

    // PB4 as input (AVR hardware SPI /SS input)
    DDRB &= ~_BV(PB4);
    // PB5 as input (AVR hardware SPI MOSI)
    DDRB &= ~_BV(PB5);
    // PB6 initially as input (AVR hardware SPI MISO)
    // MISO and MOSI are wired together as a single line to the radio (DAT),
    // so we don't set MISO as an output until we need to send data on it.
    DDRB &= ~_BV(PB6);

    // SPI data output register (MISO) initially 0
    SPDR = 0;

    // SPE=1 SPI enabled, MSTR=0 SPI slave,
    // DORD=0 MSB first, CPOL=1, CPHA=1
    // SPIE=1 SPI interrupts enabled
    SPCR = _BV(SPE) | _BV(CPOL) | _BV(CPHA) | _BV(SPIE);
}

// Pin Change Interrupt: Fires for any change of STB
ISR(PCINT1_vect)
{
    if (PINB & _BV(PB2))
    {
        // STB=high: start of transfer
        PORTB &= ~_BV(PB3); // /SS=low

        upd_rx_buf.cmd_at_write_index->size = 0;
    }
    else
    {
        // STB=low: end of transfer
        PORTB |= _BV(PB3); // /SS=high

        // SPI data output register (MISO) = 0 to set up for next transfer
        SPDR = 0;
        // MISO might be configured as an output if we were just sending data,
        // so set it back to an input until the next time we need to send data.
        DDRB &= ~_BV(PB6);

        // copy the current spi command into the circular buffer
        // empty transfers and key data request commands are ignored
        if ((upd_rx_buf.cmd_at_write_index->size != 0) &&
            ((upd_rx_buf.cmd_at_write_index->data[0] & 0x44) != 0x44))
        {
            upd_rx_buf.write_index++;
            upd_rx_buf.cmd_at_write_index =
                &upd_rx_buf.cmds[upd_rx_buf.write_index];
        }
    }
}

// SPI Serial Transfer Complete
ISR(SPI_STC_vect)
{
    // get index for current command data or key request data
    uint8_t index = upd_rx_buf.cmd_at_write_index->size;

    // store data byte from MOSI into current command
    upd_rx_buf.cmd_at_write_index->data[index] = SPDR;

    // if current command is a key data request, load the byte to send on MISO
    if ((index < sizeof(upd_tx_key_data)) &&
        ((upd_rx_buf.cmd_at_write_index->data[0] & 0x44) == 0x44))
    {
        // Load key data byte that will be sent on MISO
        SPDR = upd_tx_key_data[index];
        // Set MISO as an output
        DDRB |= _BV(PB6);
    }
    else
    {
        SPDR = 0;
    }

    // advance data index in current command
    upd_rx_buf.cmd_at_write_index->size = ++index;

    // handle command size overflow
    if (index == sizeof(upd_rx_buf.cmd_at_write_index->data))
    {
        upd_rx_buf.cmd_at_write_index->size = 0;
    }
}
