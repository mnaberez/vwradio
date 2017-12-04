#ifndef UART_H
#define UART_H

#include "ringbuf.h"

#define UART0 0
#define UART1 1

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init(uint8_t uartnum, uint32_t baud);
void uart_flush_tx(uint8_t uartnum);
void uart_put(uint8_t uartnum, uint8_t c);
void uart_put16(uint8_t uartnum, uint16_t w);
void uart_puts(uint8_t uartnum, uint8_t *str);
void uart_puthex_nib(uint8_t uartnum, uint8_t c);
void uart_puthex_byte(uint8_t uartnum, uint8_t c);
void uart_puthex_16(uint8_t uartnum, uint16_t w);
uint8_t uart_blocking_get(uint8_t uartnum);

volatile ringbuffer_t uart_rx_buffers[2];
volatile ringbuffer_t uart_tx_buffers[2];

#endif
