#include "main.h"
#include "uart.h"
#include "kwp1281.h"
#include "technisat.h"
#include "crack.h"
#include <avr/interrupt.h>


int main()
{
    // XXX For debugging only, remove me
    DDRA |= _BV(PA0);       // PA0 = output
    PORTA &= ~_BV(PA3);     // PA0 = off

    uart_init(UART_DEBUG, 115200);  // debug messages
    uart_init(UART_KLINE,  10400);  // obd-ii kwp1281
    sei();

    kwp_result_t result = kwp_autoconnect(KWP_RADIO);
    kwp_panic_if_error(result);

    // result = kwp_login_safe(1866);
    // kwp_panic_if_error(result);
    // result = kwp_read_ram(0, 0xffff, 32);
    // kwp_panic_if_error(result);

    crack();

    while(1);
}
