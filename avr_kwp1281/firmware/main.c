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
    uint8_t connected = 0;
    uint8_t i = 0;
    uint8_t c = 0;
    while (connected == 0) {
        while (!buf_has_byte(&uart1_rx_buffer));
        c = buf_read_byte(&uart1_rx_buffer);
        if (i == 0) { if (c == 0x55) { i = 1; } }
        if (i == 1) { if (c == 0x01) { i = 2; } }
        if (i == 2) { if (c == 0x8A) { i = 3; } }
        if (i == 3) { connected = 1; }
    }
    uart0_puts((uint8_t*)"GOT KW\n\n");
}

void receive_block()
{
    uart0_puts((uint8_t*)"RECV START\n");

    uint8_t done = 0;
    uint8_t i = 0;
    uint8_t block_length = 0;
    uint8_t c = 0;

    while (!done) {
        // read byte from radio
        while (!buf_has_byte(&uart1_rx_buffer));
        c = buf_read_byte(&uart1_rx_buffer);

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
        while (!buf_has_byte(&uart1_rx_buffer));
        buf_read_byte(&uart1_rx_buffer);

        i++;

        if (done) {
            uart0_puts((uint8_t*)"RECV DONE\n\n");
            return;
        }
    }
}

void send_ack_block()
{
    uint8_t c;
    uart0_puts((uint8_t*)"SEND ACK START\n");

    // block length
    _delay_ms(1);
    uart1_put(0x03);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0x03);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // block counter
    _delay_ms(1);
    uart1_put(++block_counter);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(block_counter);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // ack
    _delay_ms(1);
    uart1_put(0x09);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0x09);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // block end
    _delay_ms(1);
    uart1_put(0x03);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0x03);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    uart0_puts((uint8_t*)"SEND ACK DONE\n\n");
}


void send_f0_block()
{
    uint8_t c;
    uart0_puts((uint8_t*)"SEND F0 START\n");

    // block length
    _delay_ms(1);
    uart1_put(0x04);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0x04);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // block counter
    _delay_ms(1);
    uart1_put(++block_counter);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(block_counter);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // block title 0xf0
    _delay_ms(1);
    uart1_put(0xf0);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0xf0);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // 0=read
    _delay_ms(1);
    uart1_put(0);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    // block end
    _delay_ms(1);
    uart1_put(0x03);
    uart0_puts((uint8_t*)"TX: ");
    uart0_puthex_byte(0x03);
    uart0_put('\n');
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);
    // read byte from radio
    while (!buf_has_byte(&uart1_rx_buffer));
    c = buf_read_byte(&uart1_rx_buffer);
    uart0_puts((uint8_t*)"R_: ");
    uart0_puthex_byte(c);
    uart0_put('\n');

    uart0_puts((uint8_t*)"SEND F0 DONE\n\n");
}

int main()
{
    uart0_init();
    uart1_init();
    sei();

    send_5_baud_init();
    wait_for_55_01_8a();

    _delay_ms(30);
    uart1_put(0x75);
    // consume byte we sent
    while (!buf_has_byte(&uart1_rx_buffer));
    buf_read_byte(&uart1_rx_buffer);

    uart0_puts((uint8_t*)"BLOCK 1\n\n");
    receive_block();
    send_ack_block();

    uart0_puts((uint8_t*)"BLOCK 2\n\n");
    receive_block();
    send_ack_block();

    uart0_puts((uint8_t*)"BLOCK 3\n\n");
    receive_block();
    send_ack_block();

    uart0_puts((uint8_t*)"BLOCK 4\n\n");
    receive_block();
    send_ack_block();

    uart0_puts((uint8_t*)"BLOCK 5\n\n");
    receive_block();

    send_f0_block();
    receive_block();

    uart0_puts((uint8_t*)"END\n\n");
    while(1);

}
