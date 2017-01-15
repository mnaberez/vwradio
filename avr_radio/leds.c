#include "leds.h"
#include "main.h"
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * LED
 *************************************************************************/

void led_init()
{
    // set direction of led pins to output
    LED_DDR |= _BV(LED_GREEN) | _BV(LED_RED);

    // set leds initially off
    LED_PORT &= ~(_BV(LED_GREEN) | _BV(LED_RED));
}

void led_set(uint8_t lednum, uint8_t state)
{
    if (state)
    {
        LED_PORT |= _BV(lednum);
    }
    else
    {
        LED_PORT &= ~_BV(lednum);
    }
}

void led_blink(uint8_t lednum, uint16_t times)
{
    while (times > 0)
    {
        led_set(lednum, 1);
        _delay_ms(250);
        led_set(lednum, 0);
        _delay_ms(250);
        times -= 1;
    }
    _delay_ms(500);
}

void led_fatal(uint8_t code)
{
    while (1)
    {
        led_blink(LED_RED, code);
    }
}
