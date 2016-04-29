/*
 * Pin  1: PB0 CLOCK in/out (connect to radio through 3.3K resistor)
 * Pin  2: PB1 SWITCH out
 * Pin  5: PB4 /ENABLE in
 * Pin 19: PD5 Green LED
 * Pin 20: PD6 Red LED
 *
 * Tie FE/ME out permanently low (means non-metal tape)
 * Tie MONITOR out permanently high (means no error condition)
 */

#include "main.h"
#include "leds.h"

#include <stdint.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

int main()
{
    DDRB &= ~_BV(PB0);  // CLOCK as input

    DDRB |= _BV(PB1);   // SWITCH as output
    PORTB |= _BV(PB1);  // set SWITCH initially high

    DDRB &= ~_BV(PB4);  // ENABLE as input
    PORTB |= _BV(PB4);  // Activate internal pull-up on ENABLE

    while (PINB & _BV(PB4)) {} // wait for ENABLE to go low

    // SWITCH is already high
    _delay_ms(286);
    PORTB &= ~_BV(PB1); // set SWITCH low
    _delay_ms(337);
    PORTB |= _BV(PB1); // set SWITCH high
    _delay_ms(77);
    PORTB &= ~_BV(PB1); // set SWITCH low

    led_init();
    led_set(LED_GREEN, 1);

    DDRB |= _BV(PB0); // CLOCK as output
    while (1)
    {
        PORTB |= _BV(PB0); // set CLOCK high
        _delay_ms(25);
        PORTB &= ~_BV(PB0); // set CLOCK low
        _delay_ms(1);
    }

}
