#include "main.h"
#include "uart.h"
#include "kwp1281.h"
#include "crack.h"
#include <string.h>
#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>


int main()
{
    uart_init(UART_DEBUG, 115200);  // debug messages
    uart_init(UART_KLINE,  10400);  // obd-ii kwp1281
    sei();

    uart_puts(UART_DEBUG, "\n\nRESET\n");

    kwp_result_t result = kwp_autoconnect(KWP_RADIO);
    kwp_panic_if_error(result);
    kwp_print_module_info();

    // result = kwp_login_safe(1866);
    // kwp_panic_if_error(result);
    // result = kwp_read_ram(0, 0xffff, 32);
    // kwp_panic_if_error(result);

    crack();

    uart_puts(UART_DEBUG, "\nDONE\n");
    while(1);
}
