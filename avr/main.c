/*
 * Pin 11: GND
 * Pin 14: PD0/RXD
 * Pin 15: PD1/TXD
 * Pin 18: PD4: Green LED
 * Pin 19: PD5: Red LED
 */

#ifndef F_CPU
#define F_CPU 18432000UL
#endif

#define LED_RED 0x40
#define LED_GREEN 0x20
#define BAUD 9600

#include <avr/io.h>
#include <util/delay.h>
#include <util/setbaud.h>


/*************************************************************************
 * Utils
 *************************************************************************/

void sleep(uint16_t millisecs)
{
    while (millisecs > 0)
    {
        _delay_ms(1);
        millisecs -= 1;
    }
}

/*************************************************************************
 * LED
 *************************************************************************/

void led_init()
{
    DDRD = LED_GREEN | LED_RED;
    PORTD = 0;
}

void led_set(uint8_t lednum, uint8_t state)
{
    if (state)
    {
        PORTD |= lednum;
    }
    else
    {
        PORTD &= ~lednum;
    }
}

void led_blink(uint8_t lednum, uint16_t times)
{
    while (times > 0)
    {
        led_set(lednum, 1);
        sleep(250);
        led_set(lednum, 0);
        sleep(250);
        times -= 1;
    }
}

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init(void)
{
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;

#if USE_2X
    UCSR0A |= _BV(U2X0);
#else
    UCSR0A &= ~(_BV(U2X0));
#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
}

void uart_putc(char c)
{
    // Wait for the tx buffer ready
    loop_until_bit_is_set(UCSR0A, UDRE0);

    UDR0 = c;
}

void uart_puts(char *str)
{
    while (*str != '\0')
    {
        uart_putc(*str);
        str++;
    }
}

/*************************************************************************
 * Main
 *************************************************************************/

int main(void)
{
    led_init();
    uart_init();

    while(1)
    {
        led_blink(LED_GREEN, 1);

        char msg[] = "Hello World";
        uart_puts(msg);
    }
}
