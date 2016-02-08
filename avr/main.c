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
 * Ring Buffers for UART
 *************************************************************************/

typedef struct
{
    uint8_t data[129];
    uint8_t write_index;
    uint8_t read_index;
} RingBuffer;

volatile RingBuffer rx_buffer;
volatile RingBuffer tx_buffer;

void buf_init(volatile RingBuffer *buf)
{
    buf->read_index = 0;
    buf->write_index = 0;
}

void buf_write_byte(volatile RingBuffer *buf, uint8_t c)
{
    buf->data[buf->write_index] = c;
    buf->write_index++;
    if (buf->write_index == 129) { buf->write_index = 0; }
}

uint8_t buf_read_byte(volatile RingBuffer *buf)
{
    uint8_t c = buf->data[buf->read_index];
    buf->read_index++;
    if (buf->read_index == 129) { buf->read_index = 0; }
    return c;
}

uint8_t buf_has_byte(volatile RingBuffer *buf)
{
    return buf->read_index != buf->write_index;
}

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init(void)
{
    // Baud Rate
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
#if USE_2X
    UCSR0A |= _BV(U2X0);
#else
    UCSR0A &= ~(_BV(U2X0));
#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
    // Enable the USART Recieve Complete
    UCSR0B |= _BV(RXCIE0);
}

void uart_putc(char c)
{
    buf_write_byte(&tx_buffer, c);
    // Enable UDRE interrupts
    UCSR0B |= _BV(UDRIE0);
}

void uart_puts(char *str)
{
    while (*str != '\0')
    {
        uart_putc(*str);
        str++;
    }
}

// USART Receive Complete
ISR(USART0_RX_vect)
{
    uint8_t c;
    c = UDR0;
    buf_write_byte(&rx_buffer, c);
}

// USART Data Register Empty (USART is ready to transmit a byte)
ISR(USART0_UDRE_vect)
{
    if (buf_has_byte(&tx_buffer))
    {
        uint8_t c;
        c = buf_read_byte(&tx_buffer);
        UDR0 = c;
    }
    else
    {
        // Disable UDRE interrupts
        UCSR0B &= ~_BV(UDRE0);
    }
}

/*************************************************************************
 * Main
 *************************************************************************/

int main(void)
{
    led_init();
    uart_init();
    buf_init(&rx_buffer);
    buf_init(&tx_buffer);
    sei();

    uint8_t c;

    while(1)
    {
        if (buf_has_byte(&rx_buffer))
        {
            char msg[] = "You typed some text: ";
            uart_puts(msg);
            while (buf_has_byte(&rx_buffer))
            {
                c = buf_read_byte(&rx_buffer);
                uart_putc(c);
            }
            uart_putc('\n');
        }
        led_blink(LED_GREEN, 1);
    }
}
