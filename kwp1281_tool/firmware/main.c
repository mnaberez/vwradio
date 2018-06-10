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

// connect to premium 5 manufacturing address and login
// should work on any premium 5 radio
void connect_and_login_mfg()
{
    int result = kwp_connect(KWP_RADIO_MFG, 10400);
    if (result != KWP_SUCCESS) {
        uart_puts(UART_DEBUG, "INIT FAILED\n");
        while(1);
    }
    kwp_send_login_block(0x4f43, 0x4c, 0x4544);  // "OCLED"
    kwp_receive_block_expect(KWP_ACK);
}

// connect to standard radio address and login using safe code
// should work on any premium 4 or 5 if safe code is correct
void connect_and_login_safe(uint16_t safe_code)
{
    int result = kwp_connect(KWP_RADIO, 10400);
    if (result != KWP_SUCCESS) {
        uart_puts(UART_DEBUG, "INIT FAILED\n");
        while(1);
    }

    kwp_send_login_block(safe_code, 0x01, 0x869f);
    kwp_receive_block_expect(KWP_ACK);

    kwp_send_group_reading_block(0x19);
    // premium 4 and 5 will unlock the protected commands after login and reading group 0x19.
    // premium 4 sends ack.  premium 5 sends nak, but it's a lie, treat it like ack.
    kwp_receive_block();
}


int main()
{
    uart_init(UART_DEBUG, 115200);  // debug messages
    uart_init(UART_KLINE,  10400);  // obd-ii kwp1281
    sei();

    uart_puts(UART_DEBUG, "\n\nRESET\n");

    int result = kwp_autoconnect(KWP_RADIO);
    if (result != KWP_SUCCESS) {
        uart_puts(UART_DEBUG, "INIT FAILED\n");
        goto done;
    }

    kwp_print_module_info();

    if (memcmp(&kwp_component_1[7], "3CP", 3) == 0) {
        uart_puts(UART_DEBUG, "CLARION PREMIUM 4 DETECTED\n");
        uint16_t safe_code = kwp_p4_read_safe_code_bcd();
        print_safe_code(safe_code);
    } else if (memcmp(&kwp_component_1[7], "DE2", 3) == 0) {
        uart_puts(UART_DEBUG, "DELCO PREMIUM 5 DETECTED\n");
        kwp_disconnect();
        connect_and_login_mfg();
        uint16_t rom_checksum = kwp_p5_calc_rom_checksum();
        uint16_t safe_code = kwp_p5_read_safe_code_bcd();
        print_rom_checksum(rom_checksum);
        print_safe_code(safe_code);
    } else {
        uart_puts(UART_DEBUG, "UNCRACKABLE\n");
    }

done:
    uart_puts(UART_DEBUG, "\nDONE\n");
    while(1);
}
