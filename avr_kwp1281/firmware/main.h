#ifndef MAIN_H
#define MAIN_H

#define F_CPU 20000000UL

#define HIGH(x) (((x)>>8) & 0xFF)
#define LOW(x)  ((x) & 0xFF)

#include "uart.h"
#define UART_DEBUG UART0
#define UART_KLINE UART1

#endif
