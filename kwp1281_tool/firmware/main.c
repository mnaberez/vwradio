#include "main.h"
#include "uart.h"
#include "kwp1281.h"
#include "technisat.h"
#include "crack.h"
#include <avr/interrupt.h>


int main(void)
{
    uart_init(UART_DEBUG, 115200); // debug messages
    uart_init(UART_KLINE, 10400);  // obd-ii kwp1281
    sei();

    kwp_result_t result = kwp_retrying_connect(KWP_RADIO);
    kwp_panic_if_error(result);

    crack();

    while(1);
}
