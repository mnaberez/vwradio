#include "main.h"
#include "uart.h"
#include "kwp1281.h"

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

void print_radio_info()
{
    uart_puts(UART_DEBUG, "VAG Number: \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_vag_number[i]);
    }
    uart_puts(UART_DEBUG, "\"\n");

    uart_puts(UART_DEBUG, "Component:  \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_1[i]);
    }
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_2[i]);
    }
    uart_puts(UART_DEBUG, "\"\n");
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
    int retval = kwp_connect(KWP_RADIO_MFG, 10400);
    if (retval != 0) {
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
    int retval = kwp_connect(KWP_RADIO, 10400);
    if (retval != 0) {
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

    connect_and_login_mfg();
    uint16_t safe_code = kwp_p5_read_safe_code_bcd();
    uint16_t checksum = kwp_p5_calc_rom_checksum();
    print_safe_code(safe_code);
    print_rom_checksum(checksum);

    while(1);
}
