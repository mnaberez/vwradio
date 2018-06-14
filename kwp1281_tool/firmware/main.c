#include "main.h"
#include "uart.h"
#include "kwp1281.h"
#include <string.h>
#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

uint16_t bcd_to_bin(uint16_t bcd)
{
    uint16_t bin = 0;
    bin +=  (bcd & 0x000f);
    bin += ((bcd & 0x00f0) >>  4) * 10;
    bin += ((bcd & 0x0f00) >>  8) * 100;
    bin += ((bcd & 0xf000) >> 12) * 1000;
    return bin;
}

void print_safe_code(uint16_t safe_code_bcd)
{
    uart_puts(UART_DEBUG, "SAFE Code: ");
    uart_puthex16(UART_DEBUG, safe_code_bcd);
    uart_puts(UART_DEBUG, "\n");
}

void print_rom_checksum(uint16_t checksum)
{
    uart_puts(UART_DEBUG, "ROM Checksum: ");
    uart_puthex16(UART_DEBUG, checksum);
    uart_puts(UART_DEBUG, "\n");
}

// connect to standard radio address and login using safe code
// should work on any radio if safe code is correct
void connect_and_login_safe(uint16_t safe_code)
{
    kwp_result_t result = kwp_connect(KWP_RADIO, 10400);
    kwp_panic_if_error(result);

    result = kwp_send_login_block(safe_code, 0x01, 0x869f);
    kwp_panic_if_error(result);
    result = kwp_receive_block_expect(KWP_ACK);
    kwp_panic_if_error(result);

    result = kwp_send_group_reading_block(0x19);
    kwp_panic_if_error(result);
    // premium 4 (clarion), premium 5 (delco), and gamma 5 (technisat) will unlock the protected
    // commands after reading group 0x19.  only premium 4 sends ack.  the other radios send nak,
    // but it's a lie, treat it like ack.
    result = kwp_receive_block();
    kwp_panic_if_error(result);
}


int main()
{
    uart_init(UART_DEBUG, 115200);  // debug messages
    uart_init(UART_KLINE,  10400);  // obd-ii kwp1281
    sei();

    uart_puts(UART_DEBUG, "\n\nRESET\n");

    kwp_result_t result = kwp_autoconnect(KWP_RADIO);
    kwp_panic_if_error(result);

    kwp_print_module_info();

    if (memcmp(&kwp_component_1[7], "3CP", 3) == 0) {
        uart_puts(UART_DEBUG, "CLARION PREMIUM 4 DETECTED\n");

        uint16_t safe_code;
        result = kwp_p4_read_safe_code_bcd(&safe_code);
        kwp_panic_if_error(result);

        print_safe_code(safe_code);

    } else if (memcmp(&kwp_component_1[7], "DE2", 3) == 0) {
        uart_puts(UART_DEBUG, "DELCO PREMIUM 5 DETECTED\n");
        kwp_disconnect();
        result = kwp_autoconnect(KWP_RADIO_MFG);
        kwp_panic_if_error(result);
        result = kwp_p5_login_mfg();
        kwp_panic_if_error(result);

        uint16_t rom_checksum;
        result = kwp_p5_calc_rom_checksum(&rom_checksum);
        kwp_panic_if_error(result);

        uint16_t safe_code;
        result = kwp_p5_read_safe_code_bcd(&safe_code);
        kwp_panic_if_error(result);

        print_rom_checksum(rom_checksum);
        print_safe_code(safe_code);

    } else if (memcmp(&kwp_component_1[7], "YD5", 3) == 0) {
        uart_puts(UART_DEBUG, "TECHNISAT GAMMA 5 DETECTED\n");
        uart_puts(UART_DEBUG, "UNCRACKABLE\n");

    } else {
        uart_puts(UART_DEBUG, "UNKNOWN RADIO\n");
        uart_puts(UART_DEBUG, "UNCRACKABLE\n");
    }

    uart_puts(UART_DEBUG, "\nDONE\n");
    while(1);
}
