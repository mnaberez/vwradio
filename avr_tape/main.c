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
    led_init();
    led_set(LED_RED, 0);
    led_set(LED_GREEN, 0);

    DDRB &= ~_BV(PB4);  // ENABLE as input
    DDRB &= ~_BV(PB0);  // CLOCK as input

    DDRB |= _BV(PB1);   // SWITCH as output
    PORTB |= _BV(PB1);  // set SWITCH initially high

    loop_until_bit_is_clear(PINB, PB4);  // wait for ENABLE to go low

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
        // CLOCK low for 1ms
        DDRB |= _BV(PB0);
        PORTB &= ~_BV(PB0); // set CLOCK low
        _delay_ms(1);

        // CLOCK high for 25ms
        DDRB &= ~_BV(PB0); // CLOCK as input (external pull-up makes it high)
        _delay_ms(25);
    }

}
