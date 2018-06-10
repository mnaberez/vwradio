#ifndef UART_H
#define UART_H

#include <stdint.h>

/*************************************************************************
 * UART Numbers
 *************************************************************************/

#define UART0 0
#define UART1 1

/*************************************************************************
 * UART Functions
 *************************************************************************/

void uart_init(uint8_t uartnum, uint32_t baud);
void uart_flush_tx(uint8_t uartnum);
void uart_put(uint8_t uartnum, uint8_t c);
void uart_put16(uint8_t uartnum, uint16_t w);
void uart_puts(uint8_t uartnum, char *str);
void uart_puthex(uint8_t uartnum, uint8_t c);
void uart_puthex16(uint8_t uartnum, uint16_t w);
uint8_t uart_rx_ready(uint8_t uartnum);
void uart_blocking_put(uint8_t uartnum, uint8_t c);
uint8_t uart_blocking_get(uint8_t uartnum);
uint8_t uart_blocking_get_with_timeout(uint8_t uartnum, uint16_t timeout_ms, uint8_t *rx_byte_out);

/*************************************************************************
 * UART Ring Buffers
 *************************************************************************/

typedef struct
{
    uint8_t data[256];
    uint8_t write_index;
    uint8_t read_index;
} uart_ringbuffer_t;

#endif
