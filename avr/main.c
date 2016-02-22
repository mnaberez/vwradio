/* Pin  1: PB0 POW out (drive low to push POWER button, else high-z)
 * Pin  2: PB1 (not connected for now)
 * Pin  3: PB2 STB in from radio
 * Pin  4: PB3 /SS out (software generated from STB, connect to PB4)
 * Pin  5: PB4 /SS in (connect to PB3)
 * Pin  6: PB5 MOSI in (to radio's DAT)
 * Pin  7: PB6 MISO out (connect to PB5 through 10K resistor)
 * pin  8: PB7 SCK in from radio
 * Pin 11: GND (connect to radio's GND)
 * Pin 14: PD0/RXD (to PC's serial TXD)
 * Pin 15: PD1/TXD (to PC's serial RXD)
 * Pin 16: PD2/RXD1 MISO in (from faceplate's DAT)
 * Pin 17: PD3/TXD1 MOSI out (to faceplate's DAT through 10K resistor)
 * Pin 18: PD4/XCK1 SCK out (to faceplate's CLK)
 * Pin 19: PD5: Green LED
 * Pin 20: PD6: Red LED
 * Pin 21: PD7: STB out to faceplate
 * Pin 39: PA1: LOF out to faceplate
 * Pin 40: PA0: RST out to faceplate
 */

#include "main.h"

#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"
#include "updemu.h"
#include "cmd.h"
#include "leds.h"

/*************************************************************************
 * SPI Slave interface to Radio
 *************************************************************************/

// ring buffer for receiving upd16432b commands from radio
typedef struct
{
    volatile upd_command_t cmds[256];
    volatile uint8_t read_index;
    volatile uint8_t write_index;
    volatile upd_command_t *cmd_at_write_index;
} upd_rx_buf_t;
volatile upd_rx_buf_t upd_rx_buf;

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
    // PB0 as input (POWER button output to radio)
    // Drive PB0 low to push POWER button, otherwise set as high impedance
    DDRB &= ~_BV(PB0);
    PORTB &= ~_BV(PB0);
    // PB2 as input (STB from radio)
    DDRB &= ~_BV(PB2);
    // PB3 as output (/SS output we'll make in software from STB)
    DDRB |= _BV(PB3);
    // PB3 state initially high (/SS not asserted)
    PORTB |= _BV(PB3);
    // Set pin change enable mask 1 for PB2 (PCINT10) only
    PCMSK1 = _BV(PCINT10);
    // Any transition generates the pin change interrupt
    EICRA = _BV(ISC11);
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
        if ((upd_rx_buf.cmd_at_write_index->size !=0) &&
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

// Push the radio's POWER button momentarily.
// This should turn the radio either on or off.
void radio_push_power_button()
{
    // configure POW line as output, drive it low
    DDRB |= _BV(PB0);
    PORTB &= ~_BV(PB0);
    // wait for radio to see POWER button
    _delay_ms(100);
    // return POW line to high-z input
    DDRB &= ~_BV(PB0);
}

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

/*************************************************************************
 * Main
 *************************************************************************/

// copy emulated upd display to real faceplate
void copy_emulated_upd_to_faceplate()
{
    if (emulated_upd_state.display_data_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x40, // data setting command: display data ram
            sizeof(emulated_upd_state.display_data_ram),
            emulated_upd_state.display_data_ram
        );
        emulated_upd_state.display_data_ram_dirty = 0;
    }

    if (emulated_upd_state.pictograph_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x41, // data setting command: pictograph ram
            sizeof(emulated_upd_state.pictograph_ram),
            emulated_upd_state.pictograph_ram
            );
        emulated_upd_state.pictograph_ram_dirty = 0;
    }

    if (emulated_upd_state.chargen_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x4a, // data setting command: chargen ram
            sizeof(emulated_upd_state.chargen_ram),
            emulated_upd_state.chargen_ram
            );
        emulated_upd_state.chargen_ram_dirty = 0;
    }
}

int main()
{
    run_mode = RUN_MODE_NORMAL;

    led_init();
    uart_init();
    cmd_init();
    radio_spi_init();
    faceplate_spi_init();
    upd_init(&emulated_upd_state);
    sei();

    // clear faceplate
    faceplate_clear_display();

    while (1)
    {
        // service bytes from uart
        if (buf_has_byte(&uart_rx_buffer))
        {
            uint8_t c;
            c = buf_read_byte(&uart_rx_buffer);
            cmd_receive_byte(c);
        }

        // service commands from radio
        if (upd_rx_buf.read_index != upd_rx_buf.write_index)
        {
            upd_command_t cmd;
            cmd = upd_rx_buf.cmds[upd_rx_buf.read_index];
            upd_rx_buf.read_index++;

            if (run_mode != RUN_MODE_TEST)
            {
                upd_process_command(&emulated_upd_state, &cmd);
                copy_emulated_upd_to_faceplate();
            }
        }

    }
}
