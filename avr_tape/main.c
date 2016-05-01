/*
 * Pin  1: PB0 CLOCK in/out (connect to radio through 3.3K resistor)
 * Pin  2: PB1 SWITCH out
 * Pin  3: PB2 /ENABLE in
 * Pin  4: PB3 /SS out (software generated from /ENABLE, connect to PB4)
 * Pin  5: PB4 /SS in
 * Pin  6: PB5 MOSI in (to radio's DATA)
 * Pin 19: PD5 Green LED
 * Pin 20: PD6 Red LED
 *
 * Tie FE/ME out permanently low (means non-metal tape)
 * Tie MONITOR out permanently high (means no error condition)
 */

#include "main.h"
#include "uart.h"
#include "leds.h"

#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

volatile uint8_t clock_in_use = 0;

// Pin Change Interrupt: Fires for any change of /ENABLE
ISR(PCINT1_vect)
{
    // /ENABLE low->high (unselect)
    if (PINB & _BV(PB2)) {
        PORTB |= _BV(PB4); // /SS = high
        clock_in_use = 0;
    }
    // /ENABLE high->low (select)
    else
    {
        uart_puts((uint8_t*)"L\n");
        DDRB &= ~_BV(PB0); // CLOCK as input
        PORTB &= ~_BV(PB4); // /SS = low
        clock_in_use = 1;
    }
}

ISR(SPI_STC_vect)
{
    uart_puthex_byte(SPDR);
    SPDR = 0;
}

int main()
{
    uart_init();
    led_init();
    sei();
    uart_puts((uint8_t*)"RESET!\n\n");
    uart_flush_tx();
    led_set(LED_RED, 1);

    DDRB |= _BV(PB0);
    while (1) {
        PORTB &= ~_BV(PB0);
        _delay_ms(1);
        PORTB |= _BV(PB0);
        _delay_ms(1);
    }

    // /ENABLE as input
    DDRB &= ~_BV(PB2);
    PORTB |= _BV(PB2);  // internal pull-up

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

    led_set(LED_GREEN,1);
    sei();
    uart_puts((uint8_t*)"RESET\n");
    uart_flush_tx();

    DDRB &= ~_BV(PB0);  // CLOCK as input

    DDRB |= _BV(PB1);   // SWITCH as output
    PORTB |= _BV(PB1);  // set SWITCH initially high

    DDRB |= _BV(PB4);   // /SS out as output
    PORTB |= _BV(PB4);  // /SS out initially high

    // led_set(LED_RED, 0);
    led_set(LED_GREEN, 0);

    // SWITCH is already high
    _delay_ms(286);
    PORTB &= ~_BV(PB1); // set SWITCH low
    _delay_ms(337);
    PORTB |= _BV(PB1); // set SWITCH high
    _delay_ms(77);
    PORTB &= ~_BV(PB1); // set SWITCH low

    led_set(LED_GREEN, 1);

    while (1)
    {
        if (!clock_in_use)
        {
            // CLOCK low for 1ms
            DDRB |= _BV(PB0);
            PORTB &= ~_BV(PB0); // set CLOCK low
            _delay_ms(1);

            // CLOCK high for 25ms
            DDRB &= ~_BV(PB0); // CLOCK as input (external pull-up makes it high)
            _delay_ms(25);
        }
    }

}
