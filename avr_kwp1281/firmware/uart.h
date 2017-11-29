#ifndef UART_H
#define UART_H

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

typedef struct
{
    uint8_t data[256];
    uint8_t write_index;
    uint8_t read_index;
} ringbuffer_t;

void buf_init(volatile ringbuffer_t *buf);
void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c);
uint8_t buf_read_byte(volatile ringbuffer_t *buf);
uint8_t buf_has_byte(volatile ringbuffer_t *buf);

volatile ringbuffer_t uart_rx_buffer;
volatile ringbuffer_t uart_tx_buffer;

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

#endif
