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

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD 9600
#include <util/setbaud.h>

#define LED_PORT PORTD
#define LED_DDR DDRD
#define LED_RED PD6
#define LED_GREEN PD5

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
    LED_DDR = _BV(LED_GREEN) | _BV(LED_RED);
    LED_PORT = 0;
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

    // Enable the USART Recieve Complete interrupt
    UCSR0B |= _BV(RXC0);
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

/* XXX This implmentation blocks for long periods during the interrupt.  The
       AVR's receive FIFO can only buffer 2 bytes so it is easily overrun. */
ISR(USART0_RX_vect)
{
    uint8_t c;
    c = UDR0;

    if (c == 'r' || c == 'R')
    {
        led_blink(LED_RED, 1);
    }
    else if (c == 'g' || c == 'G')
    {
        led_blink(LED_GREEN, 1);
    }
    else
    {
        led_set(LED_RED, 1);
        led_set(LED_GREEN, 1);
        sleep(250);
        led_set(LED_RED, 0);
        led_set(LED_GREEN, 0);
    }
}

/*************************************************************************
 * Main
 *************************************************************************/

int main(void)
{
    led_init();
    uart_init();
    sei();

    while(1)
    {
        char msg[] = "Hello World";
        uart_puts(msg);
        sleep(500);
    }
}
