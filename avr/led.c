/*
 * PD5 = Red LED
 * PD4 = Green LED
 */

#ifndef F_CPU
#define F_CPU 18432000UL
#endif

#include <avr/io.h>
#include <util/delay.h>

#define LED_RED 0x40
#define LED_GREEN 0x20

void sleep(uint16_t millisecs)
{
    while (millisecs > 0)
    {
        _delay_ms(1);
        millisecs -= 1;
    }
}

void blink(uint8_t lednum, uint16_t times)
{
    while (times > 0)
    {
        PORTD |= lednum;
        sleep(250);
        PORTD &= ~lednum;
        sleep(250);
        times -= 1;
    }
}

int main(void)
{
    DDRD = LED_GREEN | LED_RED;
    while(1)
    {
        blink(LED_GREEN, 4);
        blink(LED_RED, 2);
    }
}
