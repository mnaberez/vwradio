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

#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

uint8_t block_counter = 0;

void send_5_baud_init()
{
    uart0_puts((uint8_t*)"SEND 5 BAUD\n\n");

    UCSR1B &= ~_BV(RXEN1);  // Disable RX (PD2/TXD1)
    UCSR1B &= ~_BV(TXEN1);  // Disable TX (PD3/TXD1)
    DDRD |= _BV(PD3);       // PD3 = output

    PORTD |= _BV(PD3);      // initially high
    _delay_ms(250);

    PORTD &= ~_BV(PD3);     // low 400ms
    _delay_ms(400);
    PORTD |= _BV(PD3);      // high 400ms
    _delay_ms(400);
    PORTD &= ~_BV(PD3);     // low 200ms
    _delay_ms(200);
    PORTD |= _BV(PD3);      // high 200ms
    _delay_ms(200);
    PORTD &= ~_BV(PD3);     // low 200ms
    _delay_ms(200);

    PORTD |= _BV(PD3);      // return high
    UCSR1B |= _BV(TXEN1);   // Enable TX (PD3/TXD1)
    UCSR1B |= _BV(RXEN1);   // Enable RX (PD2/TXD1)
}

void wait_for_55_01_8a()
{
    uint8_t i = 0;
    uint8_t c = 0;
    while (1) {
        c = uart1_blocking_get();

        uart0_puts((uint8_t*)"RX: ");
        uart0_puthex_byte(c);
        uart0_put('\n');

        if ((i == 0) && (c == 0x55)) { i = 1; }
        if ((i == 1) && (c == 0x01)) { i = 2; }
        if ((i == 2) && (c == 0x8A)) { i = 3; }
        if (i == 3) { break; }
    }
    uart0_puts((uint8_t*)"\nGOT KW\n\n");
}

void receive_block()
{
    uart0_puts((uint8_t*)"BEGIN RECEIVE BLOCK\n");

    uint8_t done = 0;
    uint8_t i = 0;
    uint8_t block_length = 0;
    uint8_t c = 0;

    while (!done) {
        // read byte from radio
        c = uart1_blocking_get();

        uart0_puts((uint8_t*)"RX: ");
        uart0_puthex_byte(c);
        uart0_put('\n');

        if (i == 0) {
            block_length = c;
        } else {
            if (i == 1) { block_counter = c; }
            block_length--;
            if (block_length == 0) { done = 1; }
        }

        _delay_ms(1);
        uart1_put(c ^ 0xFF);

        uart0_puts((uint8_t*)"T_: ");
        uart0_puthex_byte(c ^ 0xFF);
        uart0_put('\n');

        // consume byte we sent
        c = uart1_blocking_get();

        i++;

        if (done) {
            uart0_puts((uint8_t*)"END RECEIVE BLOCK\n\n");
            return;
        }
    }
}


// Send byte only
void send_byte(uint8_t c)
{
    _delay_ms(1);
    uart1_put(c);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(c);
    uart0_put('\n');
    // consume byte we sent
    c = uart1_blocking_get();
}


// Send byte and receive its complement
void send_byte_recv_compl(uint8_t c)
{
    send_byte(c);
    // read byte from radio
    c = uart1_blocking_get();
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');
}


// Receive byte only
uint8_t recv_byte()
{
    uint8_t c = uart1_blocking_get();
    uart0_puts((uint8_t*)"RX: ");
    uart0_puthex_byte(c);
    uart0_put('\n');
    return c;
}


// Receive byte and send its complement
uint8_t recv_byte_send_compl()
{
    uint8_t c, complement;
    c = recv_byte();

    // send complement
    complement = c ^ 0xFF;
    _delay_ms(1);
    uart1_put(complement);
    uart0_puts((uint8_t*)"T_: ");
    uart0_puthex_byte(complement);
    uart0_put('\n');

    // consume byte we sent
    uart1_blocking_get();

    return c;
}



void send_ack_block()
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: ACK\n");

    send_byte_recv_compl(0x03);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0x09);                // ack
    send_byte_recv_compl(0x03);                // block end

    uart0_puts((uint8_t*)"END SEND BLOCK: ACK\n\n");
}


void send_f0_block()
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: F0\n");

    send_byte_recv_compl(0x04);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0xf0);                // block title 0xf0
    send_byte_recv_compl(0x00);                // 0=read
    send_byte_recv_compl(0x03);                // block end

    uart0_puts((uint8_t*)"END SEND BLOCK: F0\n\n");
}


void send_login_block()
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: LOGIN\n");

    send_byte_recv_compl(0x08);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0x2b);                // login
    send_byte_recv_compl(0x10);
    send_byte_recv_compl(0xe1);
    send_byte_recv_compl(0x01);
    send_byte_recv_compl(0x86);
    send_byte_recv_compl(0x9f);
    send_byte_recv_compl(0x03);

    uart0_puts((uint8_t*)"END SEND BLOCK: LOGIN\n\n");
}


void send_group_reading_0x25()
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: GROUP READ 0x19\n");

    send_byte_recv_compl(0x04);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0x29);                // group reading
    send_byte_recv_compl(0x19);                // group number 0x19
    send_byte_recv_compl(0x03);

    uart0_puts((uint8_t*)"END SEND BLOCK: GROUP READ 0x19\n\n");
}


void send_read_eeprom(uint16_t address, uint8_t length)
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: READ EEPROM\n");

    send_byte_recv_compl(0x06);                         // block length
    send_byte_recv_compl(++block_counter);              // block counter
    send_byte_recv_compl(0x19);                         // read eeprom
    send_byte_recv_compl(length);                       // number of bytes to read
    send_byte_recv_compl((uint8_t)(address >> 8));      // address high
    send_byte_recv_compl((uint8_t)(address & 0xff));    // address low
    send_byte(0x03);                                    // block end

    uart0_puts((uint8_t*)"END SEND BLOCK: READ EEPROM\n\n");
}


void send_read_ram(uint16_t address, uint8_t length)
{
    uart0_puts((uint8_t*)"BEGIN SEND BLOCK: READ RAM\n");

    send_byte_recv_compl(0x06);                         // block length
    send_byte_recv_compl(++block_counter);              // block counter
    send_byte_recv_compl(0x01);                         // read ram
    send_byte_recv_compl(length);                       // number of bytes to read
    send_byte_recv_compl((uint8_t)(address >> 8));      // address high
    send_byte_recv_compl((uint8_t)(address & 0xff));    // address low
    send_byte(0x03);                                    // block end

    uart0_puts((uint8_t*)"END SEND BLOCK: READ RAM\n\n");
}


void read_all_ram()
{
    uint16_t address = 0xF000;
    while(1) {
        uart0_puts((uint8_t*)"ADDRESS = ");
        uart0_puthex_16(address);
        uart0_puts((uint8_t*)"\n\n");

        uint8_t size = 0x80;
        if (address == 0xFFF0) { size = 15; }
        send_read_ram(address, size);
        receive_block();
        address += 80;
        if (address < 0x8000) { break; }
    }
}


void connect()
{
    send_5_baud_init();
    wait_for_55_01_8a();
    _delay_ms(30);
    send_byte(0x75);

    // Receive and acknowledge:
    //   0. 0xF6 (ASCII/Data): "1J0035180D  "
    //   1. 0xF6 (ASCII/Data): " RADIO 3CP  "
    //   2. 0xF6 (ASCII/Data): "        0001"
    //   3. 0xF6 (ASCII/Data): 0x00 0x0A 0xF8 0x00 0x00
    for (uint8_t i=0; i<4; i++) {
        receive_block();
        send_ack_block();
    }

    // Receive 0x09 (Acknowledge)
    receive_block();
}


int main()
{
    uart0_init();
    uart1_init();
    sei();

    connect();

    send_f0_block();
    receive_block();

    send_login_block();
    receive_block();

    send_group_reading_0x25();
    receive_block();

    send_read_eeprom(0x0000, 0x80);
    receive_block();

    uart0_puts((uint8_t*)"END\n\n");
    while(1);
}
