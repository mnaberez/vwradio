#include "main.h"
#include <stdint.h>
#include <avr/interrupt.h>
#include "uart.h"

/*************************************************************************
 * UART
 *************************************************************************/

static uint8_t baud_to_UBRRxL(uint32_t baud)
{
    // assumes 20 MHz system clock, UBBRxH=0
    switch (baud) {
        case 115200:    return 0x0A;
        case 10400:     return 0x77;
        case 9600:      return 0x81;
        default:        while(1);
    }
}

void uart_init(uint8_t uartnum, uint32_t baud)
{
    switch (uartnum) {
        case UART0:
            UBRR0H = 0;                         // Baud Rate high
            UBRR0L = baud_to_UBRRxL(baud);      // Baud Rate low
            UCSR0A &= ~(_BV(U2X0));             // Do not use 2X
            UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
            UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
            UCSR0B |= _BV(RXCIE0);              // Enable Recieve Complete int
            break;
        case UART1:
            UBRR1H = 0;                         // Baud Rate high
            UBRR1L = baud_to_UBRRxL(baud);      // Baud Rate low
            UCSR1A &= ~(_BV(U2X1));             // Do not use 2X
            UCSR1C = _BV(UCSZ11) | _BV(UCSZ10); // N-8-1
            UCSR1B = _BV(RXEN1) | _BV(TXEN1);   // Enable RX and TX
            UCSR1B |= _BV(RXCIE1);              // Enable Recieve Complete int
            break;
        default:
            while(1);
    }

    buf_init(&uart_rx_buffers[uartnum]);
    buf_init(&uart_tx_buffers[uartnum]);
}

void uart_flush_tx(uint8_t uartnum)
{
    while (buf_has_byte(&uart_tx_buffers[uartnum]));
}

void uart_put(uint8_t uartnum, uint8_t c)
{
    buf_write_byte(&uart_tx_buffers[uartnum], c);
    // Enable UDRE interrupt
    switch (uartnum) {
        case UART0: UCSR0B |= _BV(UDRIE0); break;
        case UART1: UCSR1B |= _BV(UDRIE1); break;
        default:    while(1);
    }
}

void uart_put16(uint8_t uartnum, uint16_t w)
{
    uart_put(uartnum, w & 0x00FF);
    uart_put(uartnum, (w & 0xFF00) >> 8);
}

void uart_puts(uint8_t uartnum, uint8_t *str)
{
    while (*str != '\0')
    {
        uart_put(uartnum, *str);
        str++;
    }
}

void uart_puthex_nib(uint8_t uartnum, uint8_t c)
{
    if (c < 10) // 0-9
    {
        uart_put(uartnum, c + 0x30);
    }
    else // A-F
    {
        uart_put(uartnum, c + 0x37);
    }
}

void uart_puthex_byte(uint8_t uartnum, uint8_t c)
{
    uart_puthex_nib(uartnum, (c & 0xf0) >> 4);
    uart_puthex_nib(uartnum, c & 0x0f);
}

void uart_puthex_16(uint8_t uartnum, uint16_t w)
{
    uart_puthex_byte(uartnum, (w & 0xff00) >> 8);
    uart_puthex_byte(uartnum, (w & 0x00ff));
}

uint8_t uart_blocking_get(uint8_t uartnum)
{
    while (!buf_has_byte(&uart_rx_buffers[uartnum]));
    return buf_read_byte(&uart_rx_buffers[uartnum]);
}


// USART0 Receive Complete
ISR(USART0_RX_vect)
{
    buf_write_byte(&uart_rx_buffers[UART0], UDR0);
}

// USART1 Receive Complete
ISR(USART1_RX_vect)
{
    buf_write_byte(&uart_rx_buffers[UART1], UDR1);
}

// USART0 Data Register Empty (USART0 is ready to transmit a byte)
ISR(USART0_UDRE_vect)
{
    if (buf_has_byte(&uart_tx_buffers[UART0])) {
        UDR0 = buf_read_byte(&uart_tx_buffers[UART0]);
    } else {
        // No more data to send; disable UDRE interrupts
        UCSR0B &= ~_BV(UDRE0);
    }
}

// USART1 Data Register Empty (USART1 is ready to transmit a byte)
ISR(USART1_UDRE_vect)
{
    if (buf_has_byte(&uart_tx_buffers[UART1])) {
        UDR1 = buf_read_byte(&uart_tx_buffers[UART1]);
    } else {
        // No more data to send; disable UDRE interrupts
        UCSR1B &= ~_BV(UDRE1);
    }
}
