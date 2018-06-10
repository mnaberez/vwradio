#include "main.h"
#include <stdint.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "uart.h"

/*************************************************************************
 * UART Ring Buffers
 *************************************************************************/

volatile uart_ringbuffer_t _rx_buffers[2];
volatile uart_ringbuffer_t _tx_buffers[2];

static void _buf_init(volatile uart_ringbuffer_t *buf)
{
    buf->read_index = 0;
    buf->write_index = 0;
}

static void _buf_write_byte(volatile uart_ringbuffer_t *buf, uint8_t c)
{
    buf->data[buf->write_index++] = c;
}

static uint8_t _buf_read_byte(volatile uart_ringbuffer_t *buf)
{
    return buf->data[buf->read_index++];
}

static uint8_t _buf_has_byte(volatile uart_ringbuffer_t *buf)
{
    return buf->read_index != buf->write_index;
}

/*************************************************************************
 * UART
 *************************************************************************/

static uint8_t _baud_to_UBBRxL(uint32_t baud)
{
    // assumes 20 MHz system clock, UBBRxH=0
    switch (baud) {
        case 115200:    return 0x0A;
        case 10400:     return 0x77;
        case 9600:      return 0x81;
        default:        while(1);
    }
}

void uart_init(uart_num_t uartnum, uint32_t baud)
{
    switch (uartnum) {
        case UART0:
            UBRR0H = 0;                         // Baud Rate high
            UBRR0L = _baud_to_UBBRxL(baud);     // Baud Rate low
            UCSR0A &= ~(_BV(U2X0));             // Do not use 2X
            UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
            UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
            UCSR0B |= _BV(RXCIE0);              // Enable Recieve Complete int
            break;
        case UART1:
            UBRR1H = 0;                         // Baud Rate high
            UBRR1L = _baud_to_UBBRxL(baud);     // Baud Rate low
            UCSR1A &= ~(_BV(U2X1));             // Do not use 2X
            UCSR1C = _BV(UCSZ11) | _BV(UCSZ10); // N-8-1
            UCSR1B = _BV(RXEN1) | _BV(TXEN1);   // Enable RX and TX
            UCSR1B |= _BV(RXCIE1);              // Enable Recieve Complete int
            break;
        default:
            while(1);
    }

    _buf_init(&_rx_buffers[uartnum]);
    _buf_init(&_tx_buffers[uartnum]);
}

void uart_put(uart_num_t uartnum, uint8_t c)
{
    _buf_write_byte(&_tx_buffers[uartnum], c);
    // Enable UDRE interrupt
    switch (uartnum) {
        case UART0: UCSR0B |= _BV(UDRIE0); break;
        case UART1: UCSR1B |= _BV(UDRIE1); break;
        default:    while(1);
    }
}

void uart_put16(uart_num_t uartnum, uint16_t w)
{
    uart_put(uartnum, w & 0x00FF);
    uart_put(uartnum, (w & 0xFF00) >> 8);
}

void uart_puts(uart_num_t uartnum, char *str)
{
    while (*str != '\0') {
        uart_put(uartnum, *str);
        str++;
    }
}

static void _puthex_nib(uart_num_t uartnum, uint8_t c)
{
    if (c < 10) { // 0-9
        uart_put(uartnum, c + 0x30);
    } else { // A-F
        uart_put(uartnum, c + 0x37);
    }
}

void uart_puthex(uart_num_t uartnum, uint8_t c)
{
    _puthex_nib(uartnum, (c & 0xf0) >> 4);
    _puthex_nib(uartnum, c & 0x0f);
}

void uart_puthex16(uart_num_t uartnum, uint16_t w)
{
    uart_puthex(uartnum, (w & 0xff00) >> 8);
    uart_puthex(uartnum, (w & 0x00ff));
}

// Block until the TX buffer is empty
void uart_flush_tx(uart_num_t uartnum)
{
    while (_buf_has_byte(&_tx_buffers[uartnum]));
}

// Send a byte; block until it has been transmitted
void uart_blocking_put(uart_num_t uartnum, uint8_t c)
{
    uart_flush_tx(uartnum);
    uart_put(uartnum, c);
    uart_flush_tx(uartnum);
}

// Checks if a newly received byte is available
uart_status_t uart_rx_ready(uart_num_t uartnum)
{
    if (_buf_has_byte(&_rx_buffers[uartnum])) {
        return UART_READY;
    } else {
        return UART_NOT_READY;
    }
}

// Receive a byte; block until one is available
uint8_t uart_blocking_get(uart_num_t uartnum)
{
    while (uart_rx_ready(uartnum) == UART_NOT_READY);
    return _buf_read_byte(&_rx_buffers[uartnum]);
}

// Wrapper around uart_blocking_get() and uart_rx_ready() to provide a timeout
// Returns true if byte has been received into rx_byte_out
uart_status_t uart_blocking_get_with_timeout(uart_num_t uartnum, uint16_t timeout_ms, uint8_t *rx_byte_out)
{
    uint16_t millis = 0;
    uint16_t submillis = 0;
    while (uart_rx_ready(uartnum) == UART_NOT_READY) {
        _delay_us(50); // 50 us = 0.05 ms
        if (++submillis == 20) {  // 1 ms
            submillis = 0;
            if (++millis == timeout_ms) { return 0; }  // timeout
        }
    }
    *rx_byte_out = uart_blocking_get(uartnum);
    return 1;  // success
}

/*************************************************************************
 * UART Interrupt Service Routines
 *************************************************************************/

// USART0 Receive Complete
ISR(USART0_RX_vect)
{
    _buf_write_byte(&_rx_buffers[UART0], UDR0);
}

// USART1 Receive Complete
ISR(USART1_RX_vect)
{
    _buf_write_byte(&_rx_buffers[UART1], UDR1);
}

// USART0 Data Register Empty (USART0 is ready to transmit a byte)
ISR(USART0_UDRE_vect)
{
    if (_buf_has_byte(&_tx_buffers[UART0])) {
        UDR0 = _buf_read_byte(&_tx_buffers[UART0]);
    } else {
        // No more data to send; disable UDRE interrupts
        UCSR0B &= ~_BV(UDRE0);
    }
}

// USART1 Data Register Empty (USART1 is ready to transmit a byte)
ISR(USART1_UDRE_vect)
{
    if (_buf_has_byte(&_tx_buffers[UART1])) {
        UDR1 = _buf_read_byte(&_tx_buffers[UART1]);
    } else {
        // No more data to send; disable UDRE interrupts
        UCSR1B &= ~_BV(UDRE1);
    }
}
