#include "main.h"
#include <stdint.h>
#include <avr/interrupt.h>
#include "uart1.h"

/*************************************************************************
 * UART1
 *************************************************************************/

void uart1_init()
{
    // Baud Rate
#define BAUD 9600
#include <util/setbaud.h>
    UBRR1H = UBRRH_VALUE;
    UBRR1L = UBRRL_VALUE;
#if USE_2X
#error USE_2X is not supported
#endif

    UCSR1A &= ~(_BV(U2X1));             // Do not use 2X
    UCSR1C = _BV(UCSZ11) | _BV(UCSZ10); // N-8-1
    UCSR1B = _BV(RXEN1) | _BV(TXEN1);   // Enable RX and TX
    UCSR1B |= _BV(RXCIE1);              // Enable Recieve Complete interrupt

    buf_init(&uart1_rx_buffer);
    buf_init(&uart1_tx_buffer);
}

void uart1_flush_tx()
{
    while (buf_has_byte(&uart1_tx_buffer)) {}
}

void uart1_put(uint8_t c)
{
    buf_write_byte(&uart1_tx_buffer, c);
    // Enable UDRE interrupts
    UCSR1B |= _BV(UDRIE1);
}

void uart1_puts(uint8_t *str)
{
    while (*str != '\0')
    {
        uart1_put(*str);
        str++;
    }
}

uint8_t uart1_blocking_get()
{
    while (!buf_has_byte(&uart1_rx_buffer));
    return buf_read_byte(&uart1_rx_buffer);
}

// USART Receive Complete
ISR(USART1_RX_vect)
{
    uint8_t c;
    c = UDR1;
    buf_write_byte(&uart1_rx_buffer, c);
}

// USART Data Register Empty (USART is ready to transmit a byte)
ISR(USART1_UDRE_vect)
{
    if (uart1_tx_buffer.read_index != uart1_tx_buffer.write_index)
    {
        UDR1 = uart1_tx_buffer.data[uart1_tx_buffer.read_index++];
    }
    else
    {
        // Disable UDRE interrupts
        UCSR1B &= ~_BV(UDRE1);
    }
}
