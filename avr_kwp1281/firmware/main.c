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
#include "uart0.h"
#include "uart1.h"
#include "kwp1281.h"

#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

int main()
{
    uart0_init(115200);  // debug
    uart1_init(9600);    // obd-ii kwp-1281
    sei();

    connect();

    send_f0_block();
    receive_block();

    send_login_block(0x10e1, 0x01, 0x869f);
    receive_block();

    send_group_reading_block(0x19);
    receive_block();

    send_read_eeprom_block(0x0000, 0x80);
    receive_block();

    uart0_puts((uint8_t*)"END\n\n");
    while(1);
}
