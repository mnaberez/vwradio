#include "main.h"
#include "uart.h"
#include "kwp1281.h"
#include "technisat.h"
#include "crack.h"
#include <avr/interrupt.h>


int main(void)
{
    uart_init(UART_DEBUG, 38400);  // debug messages
    uart_init(UART_KLINE, 10400);  // obd-ii kwp1281
    sei();

    kwp_result_t result = kwp_retrying_connect(KWP_RADIO_MFG);
    kwp_panic_if_error(result);

    result = kwp_p5_login_mfg();
    kwp_panic_if_error(result);

    uint16_t checksum = 0;
    result = kwp_p5_calc_rom_checksum(&checksum);
    kwp_panic_if_error(result);
    uart_puthex16(UART_DEBUG, checksum);

    result = kwp_read_ram(0, 0xffff, 1);
    kwp_panic_if_error(result);

    // result = kwp_login_safe(1866);
    // kwp_panic_if_error(result);
    // result = kwp_read_ram(0, 0xffff, 32);
    // kwp_panic_if_error(result);

    // crack();

    while(1);
}
