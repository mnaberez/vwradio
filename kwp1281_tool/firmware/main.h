#pragma once

#define HIGH(x) (((x)>>8) & 0xFF)
#define LOW(x)  ((x) & 0xFF)

#define WORD(high,low) ((high<<8) + low)

#include "uart.h"
#define UART_DEBUG UART0
#define UART_KLINE UART1
