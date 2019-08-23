#ifndef UART_H
#define UART_H

#include "main.h"
#include <stdint.h>

#if F_CPU == 20000000             /* 20 MHz crystal */
#define UART_UBRR_115200  0x0015  /* -1.4% error */
#define UART_UBBR_57600   0x002a  /* 0.9% error */
#define UART_UBBR_38400   0x0040  /* 0.2% error */
#define UART_UBBR_19200   0x0081  /* 0.2% error */
#define UART_UBRR_10400   0x00ef  /* 0.2% error */
#define UART_UBRR_9600    0x0103  /* 0.2% error */
#define UART_UBBR_4800    0x0208  /* 0% error */
#define UART_UBBR_2400    0x0411  /* 0% error */
#define UART_UBBR_1200    0x0822  /* 0% error */

#elif F_CPU == 16000000           /* 16 MHz crystal */
#define UART_UBRR_115200  0x0010  /* 2.1% error */
#define UART_UBBR_57600   0x0022  /* -0.8% error */
#define UART_UBBR_38400   0x0033  /* 0.2% error */
#define UART_UBBR_19200   0x0067  /* 0.2% error */
#define UART_UBRR_10400   0x00bf  /* 0.2% error */
#define UART_UBRR_9600    0x00cf  /* 0.2% error */
#define UART_UBBR_4800    0x01a0  /* -0.1% error */
#define UART_UBBR_2400    0x0340  /* 0% error */
#define UART_UBBR_1200    0x0682  /* 0% error */

#elif F_CPU == 8000000            /* 8 MHz crystal */
#define UART_UBRR_115200  0x0008  /* -3.5% error */
#define UART_UBBR_57600   0x0010  /* 2.1% error */
#define UART_UBBR_38400   0x0019  /* 0.2% error */
#define UART_UBBR_19200   0x0033  /* 0.2% error */
#define UART_UBRR_10400   0x005f  /* 0.2% error */
#define UART_UBRR_9600    0x0067  /* 0.2% error */
#define UART_UBBR_4800    0x00cf  /* 0.2% error */
#define UART_UBBR_2400    0x01a0  /* -0.1% error */
#define UART_UBBR_1200    0x0340  /* 0% error */

#else
#error "No UART baud rate values defined for this value for F_CPU"
#endif

typedef enum {
    UART0 = 0,
    UART1 = 1,
} uart_num_t;

typedef enum {
    UART_NOT_READY = 0,
    UART_READY = 1,
} uart_status_t;

typedef struct
{
    uint8_t data[256];
    uint8_t write_index;
    uint8_t read_index;
} uart_ringbuffer_t;

void uart_init(uart_num_t uartnum, uint32_t baud);
void uart_enable(uart_num_t uartnum);
void uart_disable(uart_num_t uartnum);
void uart_flush_tx(uart_num_t uartnum);
void uart_put(uart_num_t uartnum, uint8_t c);
void uart_put16(uart_num_t uartnum, uint16_t w);
void uart_puts(uart_num_t uartnum, char *str);
void uart_puthex(uart_num_t uartnum, uint8_t c);
void uart_puthex16(uart_num_t uartnum, uint16_t w);
uart_status_t uart_rx_ready(uart_num_t uartnum);
void uart_blocking_put(uart_num_t uartnum, uint8_t c);
uint8_t uart_blocking_get(uart_num_t uartnum);
uart_status_t uart_blocking_get_with_timeout(uart_num_t uartnum, uint16_t timeout_ms, uint8_t *rx_byte_out);

#endif
