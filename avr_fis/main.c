/*
 * Pin  3: PB2 ENA in/out to ENA on radio's 3LB
 * Pin  4: PB3 /SS out: connect to PB4
 * Pin  5: PB4 /SS in:  connect to PB3 (/SS out)
 * Pin  6: PB5 MOSI in: connect to DAT on radio's 3LB **
 * pin  8: PB7 SCK in: connect to CLK on radio's 3LB **
 *
 * Pins marked ** above are also used by the ISP programmer but the ISP
 * can't be connected at the same time as the radio.
 */

#include "main.h"
#include "uart.h"

#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

// Pin Change Interrupt: Fires for any change of ENA
ISR(PCINT1_vect)
{
    // /ENABLE low->high
    if (PINB & _BV(PB2)) {
    }
    // /ENABLE high->low
    else
    {
    }
}

ISR(SPI_STC_vect)
{
    uint8_t c = SPDR;
    uart_put('0');
    uart_put('x');
    uart_puthex_byte(c);
    uart_put('\n');
}

int main()
{
    uart_init();

    sei();

    DDRB &= ~_BV(PB0);  // CLOCK as input
    DDRB &= ~_BV(PB7);  // SCK as input

    // ENA as input
    DDRB &= ~_BV(PB2);
    PORTB |= _BV(PB2);  // internal pull-up

    DDRB |= _BV(PB3);  // /SS out as output
    PORTB |= _BV(PB3); // /SS out initially high

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

    // SPI data output register (MISO) initially 0
    SPDR = 0;

    // SPE=1 SPI enabled, MSTR=0 SPI slave,
    // DORD=0 MSB first, CPOL=1, CPHA=1
    // SPIE=1 SPI interrupts enabled
    SPCR = _BV(SPE) | _BV(CPOL) | _BV(CPHA) | _BV(SPIE);

    uart_puts((uint8_t*)"RESET!\n\n");
    uart_flush_tx();

    while (1)
    {
    }

}
