#include "uart.h"

// Wire UART up to printf()
// See instructions: https://github.com/mpaland/printf
void _putchar(char c)
{
    uart_put(UART_DEBUG, c);
}
