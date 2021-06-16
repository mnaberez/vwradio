#include "main.h"
#include <stdint.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "uart.h"

/*************************************************************************
 * UART Ring Buffers
 *************************************************************************/

static volatile uart_ringbuffer_t _rx_buffers[2];
static volatile uart_ringbuffer_t _tx_buffers[2];

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

static uint16_t _baud_to_ubrr(uint32_t baud)
{
    switch (baud) {
        case 115200:    return UART_UBRR_115200;
        case 57600:     return UART_UBBR_57600;
        case 38400:     return UART_UBBR_38400;
        case 19200:     return UART_UBBR_19200;
        case 10400:     return UART_UBRR_10400;
        case 9600:      return UART_UBRR_9600;
        case 4800:      return UART_UBBR_4800;
        case 2400:      return UART_UBBR_2400;
        case 1200:      return UART_UBBR_1200;
        default:        while(1);
    }
}

void uart_init(uart_num_t uartnum, uint32_t baud)
{
    uint16_t ubrr = _baud_to_ubrr(baud);

    switch (uartnum) {
        case UART0:
            UBRR0H = HIGH(ubrr);  // Baud Rate high
            UBRR0L = LOW(ubrr);   // Baud Rate low
            UCSR0A = _BV(U2X0);   // Enable 2x, Clear error flags
            break;
        case UART1:
            UBRR1H = HIGH(ubrr);  // Baud Rate high
            UBRR1L = LOW(ubrr);   // Baud Rate low
            UCSR1A = _BV(U2X1);   // Enable 2x, Clear error flags
            break;
        default:
            while(1);
    }

    uart_enable(uartnum);
}

void uart_enable(uart_num_t uartnum)
{
    _buf_init(&_rx_buffers[uartnum]);
    _buf_init(&_tx_buffers[uartnum]);

    switch (uartnum) {
        case UART0:
            UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
            UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
            UCSR0B |= _BV(RXCIE0);              // Enable Receive Complete int
            break;
        case UART1:
            UCSR1C = _BV(UCSZ11) | _BV(UCSZ10); // N-8-1
            UCSR1B = _BV(RXEN1) | _BV(TXEN1);   // Enable RX and TX
            UCSR1B |= _BV(RXCIE1);              // Enable Receive Complete int
            break;
        default:
            while(1);
    }
}

void uart_disable(uart_num_t uartnum)
{
    switch (uartnum) {
        case UART0:
            UCSR0B &= ~_BV(RXEN0);  // Disable RX (PD0/RXD0)
            UCSR0B &= ~_BV(TXEN0);  // Disable TX (PD1/TXD0)
            PORTD |= _BV(PD1);      // PD1 = 1 (line idles high)
            DDRD |= _BV(PD1);       // PD1 = output
            break;
        case UART1:
            UCSR1B &= ~_BV(RXEN1);  // Disable RX (PD2/RXD1)
            UCSR1B &= ~_BV(TXEN1);  // Disable TX (PD3/TXD1)
            PORTD |= _BV(PD3);      // PD3 = 1 (line idles high)
            DDRD |= _BV(PD3);       // PD3 = output
            break;
        default:
            while(1);
    }
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
// Returns UART_READY if a byte has been received into rx_byte_out
uart_status_t uart_blocking_get_with_timeout(uart_num_t uartnum, uint16_t timeout_ms, uint8_t *rx_byte_out)
{
    uint16_t millis = 0;
    uint8_t submillis = 0;
    while (uart_rx_ready(uartnum) == UART_NOT_READY) {
        _delay_us(50); // 50 us = 0.05 ms
        if (++submillis == 20) {  // 1 ms
            submillis = 0;
            if (++millis == timeout_ms) { return UART_NOT_READY; }
        }
    }
    *rx_byte_out = uart_blocking_get(uartnum);
    return UART_READY;
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
