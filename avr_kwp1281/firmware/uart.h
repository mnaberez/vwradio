#ifndef UART_H
#define UART_H

#include <stdint.h>

#define UART0 0
#define UART1 1

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

typedef struct
{
    uint8_t data[256];
    uint8_t write_index;
    uint8_t read_index;
} ringbuffer_t;

volatile ringbuffer_t uart_rx_buffers[2];
volatile ringbuffer_t uart_tx_buffers[2];

/*************************************************************************
 * UART
 *************************************************************************/

void uart_init(uint8_t uartnum, uint32_t baud);
void uart_flush_tx(uint8_t uartnum);
void uart_put(uint8_t uartnum, uint8_t c);
void uart_put16(uint8_t uartnum, uint16_t w);
void uart_puts(uint8_t uartnum, char *str);
void uart_puthex_nib(uint8_t uartnum, uint8_t c);
void uart_puthex_byte(uint8_t uartnum, uint8_t c);
void uart_puthex_16(uint8_t uartnum, uint16_t w);
uint8_t uart_blocking_get(uint8_t uartnum);

#endif
