#ifndef UART1_H
#define UART1_H

#include "ringbuf.h"

/*************************************************************************
 * UART1
 *************************************************************************/

void uart1_init();
void uart1_flush_tx();
void uart1_put(uint8_t c);
void uart1_puts(uint8_t *str);
uint8_t uart1_blocking_get();

volatile ringbuffer_t uart1_rx_buffer;
volatile ringbuffer_t uart1_tx_buffer;

#endif
