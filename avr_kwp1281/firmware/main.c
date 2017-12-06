/*
 * Pin  1: PB0 (unused)
 * Pin  2: PB1 (unused)
 * Pin  3: PB2 (unused)
 * Pin  4: PB3 (unused)
 * Pin  5: PB4 (unused)
 * Pin  6: PB5 (unused)
 * Pin  7: PB6 (unused)
 * pin  8: PB7 (unused)
 * pin  9: /RESET to GND through pushbutton, 10K pullup to Vcc
 *                also connect to Atmel-ICE AVR port pin 6 nSRST
 * pin 10: Vcc (connect to unswitched 5V)
 * Pin 11: GND (connect to radio's GND)
 * Pin 12: XTAL2 (to 20 MHz crystal with 18pF cap to GND)
 * Pin 13: XTAL1 (to 20 MHz crystal and 18pF cap to GND)
 * Pin 14: PD0/RXD0 (to PC's serial TXD)
 * Pin 15: PD1/TXD0 (to PC's serial RXD)
 * Pin 16: PD2/RXD1 (to L9637D pin 1 RX)
 * Pin 17: PD3/TXD1 (to L9637D pin 4 TX)
 * Pin 18: PD4 (unused)
 * Pin 19: PD5 (unused)
 * Pin 20: PD6 (unused)
 * Pin 21: PD7 (unused)
 * Pin 22: PC0 I2C SDA (unused)
 * Pin 23: PC1 I2C SCL (unused)
 * Pin 24: PC2 JTAG TCK (to Atmel-ICE AVR port pin 1 TCK)
 * Pin 25: PC3 JTAG TMS (to Atmel-ICE AVR port pin 5 TMS)
 * Pin 26: PC4 JTAG TDO (to Atmel-ICE AVR port pin 3 TDO)
 * Pin 27: PC5 JTAG TDI (to Atmel-ICE AVR port pin 9 TDI)
 * Pin 28: PC6 TOSC1 (unused)
 * Pin 29: PC7 TOSC2 (unused)
 * Pin 30: AVCC connect directly to Vcc (also to Atmel-ICE AVR port pin 4 VTG)
 * Pin 31: GND (also to Atmel-ICE AVR port pins 2 GND and 10 GND)
 * Pin 32: AREF connect to GND through 0.1 uF cap
 * Pin 33: PA7 (unused)
 * Pin 34: PA6 (unused)
 * Pin 35: PA5 (unused)
 * Pin 36: PA4 (unused)
 * Pin 37: PA3 (unused)
 * Pin 38: PA2 (unused)
 * Pin 39: PA1 (unused)
 * Pin 40: PA0 (unused)
 */

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
    uart_puts(UART_DEBUG, (uint8_t*)"VAG Number: \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_vag_number[i]);
    }
    uart_puts(UART_DEBUG, (uint8_t*)"\"\n");

    uart_puts(UART_DEBUG, (uint8_t*)"Component:  \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_1[i]);
    }
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_2[i]);
    }
    uart_puts(UART_DEBUG, (uint8_t*)"\"\n");
}

void print_safe_code(uint16_t safe_code_bcd)
{
    uart_puts(UART_DEBUG, (uint8_t*)"SAFE Code:  ");
    uart_puthex_16(UART_DEBUG, safe_code_bcd);
    uart_puts(UART_DEBUG, (uint8_t*)"\n");
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

    // uint16_t safe_code_bin = bcd_to_bin(safe_code_bcd);
    // kwp_send_login_block(safe_code_bin, 0x01, 0x869f);
    // kwp_receive_block();
    //
    // kwp_send_group_reading_block(0x19);
    // kwp_receive_block();
    //
    // kwp_send_read_eeprom_block(0x0000, 0x80);
    // kwp_receive_block();

    while(1);
}
