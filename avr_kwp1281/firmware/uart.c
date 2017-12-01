#include "main.h"
#include <stdint.h>
#include <avr/interrupt.h>
#include "uart.h"

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

void buf_init(volatile ringbuffer_t *buf)
{
    buf->read_index = 0;
    buf->write_index = 0;
}

void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c)
{
    buf->data[buf->write_index++] = c;
}

uint8_t buf_read_byte(volatile ringbuffer_t *buf)
{
    uint8_t c = buf->data[buf->read_index++];
    return c;
}

uint8_t buf_has_byte(volatile ringbuffer_t *buf)
{
    return buf->read_index != buf->write_index;
}

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init()
{
    // Baud Rate
#define BAUD 115200
#include <util/setbaud.h>
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

    buf_init(&uart_rx_buffer);
    buf_init(&uart_tx_buffer);
}

void uart_flush_tx()
{
    while (buf_has_byte(&uart_tx_buffer)) {}
}

void uart_put(uint8_t c)
{
    buf_write_byte(&uart_tx_buffer, c);
    // Enable UDRE interrupts
    UCSR0B |= _BV(UDRIE0);
}

void uart_put16(uint16_t w)
{
    uart_put(w & 0x00FF);
    uart_put((w & 0xFF00) >> 8);
}

void uart_puts(uint8_t *str)
{
    while (*str != '\0')
    {
        uart_put(*str);
        str++;
    }
}

void uart_puthex_nib(uint8_t c)
{
    if (c < 10) // 0-9
    {
        uart_put(c + 0x30);
    }
    else // A-F
    {
        uart_put(c + 0x37);
    }
}

void uart_puthex_byte(uint8_t c)
{
    uart_puthex_nib((c & 0xf0) >> 4);
    uart_puthex_nib(c & 0x0f);
}

void uart_puthex_16(uint16_t w)
{
    uart_puthex_byte((w & 0xff00) >> 8);
    uart_puthex_byte((w & 0x00ff));
}

// USART Receive Complete
ISR(USART0_RX_vect)
{
    uint8_t c;
    c = UDR0;
    buf_write_byte(&uart_rx_buffer, c);
}

// USART Data Register Empty (USART is ready to transmit a byte)
ISR(USART0_UDRE_vect)
{
    if (uart_tx_buffer.read_index != uart_tx_buffer.write_index)
    {
        UDR0 = uart_tx_buffer.data[uart_tx_buffer.read_index++];
    }
    else
    {
        // Disable UDRE interrupts
        UCSR0B &= ~_BV(UDRE0);
    }
}
