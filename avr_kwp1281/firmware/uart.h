#ifndef UART_H
#define UART_H

#include "ringbuf.h"

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init();
void uart_flush_tx();
void uart_put(uint8_t c);
void uart_put16(uint16_t w);
void uart_puts(uint8_t *str);
void uart_puthex_nib(uint8_t c);
void uart_puthex_byte(uint8_t c);
void uart_puthex_16(uint16_t w);

volatile ringbuffer_t uart_rx_buffer;
volatile ringbuffer_t uart_tx_buffer;

#endif
