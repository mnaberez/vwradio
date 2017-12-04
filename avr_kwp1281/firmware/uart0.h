#ifndef UART0_H
#define UART0_H

#include "ringbuf.h"

/*************************************************************************
 * UART0
 *************************************************************************/

void uart0_init(uint32_t baud);
void uart0_flush_tx();
void uart0_put(uint8_t c);
void uart0_put16(uint16_t w);
void uart0_puts(uint8_t *str);
void uart0_puthex_nib(uint8_t c);
void uart0_puthex_byte(uint8_t c);
void uart0_puthex_16(uint16_t w);

volatile ringbuffer_t uart0_rx_buffer;
volatile ringbuffer_t uart0_tx_buffer;

#endif
