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
    uart_puts(UART_DEBUG, "SAFE Code:  ");
    uart_puthex16(UART_DEBUG, safe_code_bcd);
    uart_puts(UART_DEBUG, "\n");
}

int main()
{
    uart_init(UART_DEBUG, 115200);  // debug messages
    uart_init(UART_KWP,   9600);    // obd-ii kwp1281
    sei();

    kwp_connect(0x56);

    kwp_send_f0_block();
    kwp_receive_block();
    uint16_t safe_code_bcd = (kwp_rx_buf[3] << 8) + kwp_rx_buf[4];

    print_radio_info();
    print_safe_code(safe_code_bcd);

    uint16_t safe_code_bin = bcd_to_bin(safe_code_bcd);
    kwp_send_login_block(safe_code_bin, 0x01, 0x869f);
    kwp_receive_block();

    kwp_send_group_reading_block(0x19);
    kwp_receive_block();

    for (uint8_t i=0; i<100; i++) {
        uart_puts(UART_DEBUG, "\n\nRAM ITERATION ");
        uart_puthex(UART_DEBUG, i);
        uart_puts(UART_DEBUG, "\n\n");
        kwp_read_ram(0x8000, 32768);
    }

    while(1);
}
