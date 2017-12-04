#include "main.h"
#include "kwp1281.h"
#include "uart.h"
#include <avr/io.h>
#include <util/delay.h>

uint8_t block_counter = 0;


void send_address(uint8_t address)
{
    uart_puts(UART0, (uint8_t*)"SEND 5 BAUD\n\n");

    UCSR1B &= ~_BV(RXEN1);  // Disable RX (PD2/TXD1)
    UCSR1B &= ~_BV(TXEN1);  // Disable TX (PD3/TXD1)
    DDRD |= _BV(PD3);       // PD3 = output

    // TODO add support for sending any address
    if (address != 0x56) { while(1); }

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


// Send byte only
void send_byte(uint8_t c)
{
    _delay_ms(1);

    uart_put(UART1, c);
    uart_blocking_get(UART1);  // consume echo

    uart_puts(UART0, (uint8_t*)"TX: ");
    uart_puthex_byte(UART0, c);
    uart_put(UART0, '\n');
}


// Send byte and receive its complement
void send_byte_recv_compl(uint8_t c)
{
    send_byte(c);
    uint8_t complement = uart_blocking_get(UART1);

    uart_puts(UART0, (uint8_t*)"R_: ");
    uart_puthex_byte(UART0, complement);
    uart_put(UART0, '\n');
}


// Receive byte only
uint8_t recv_byte()
{
    uint8_t c = uart_blocking_get(UART1);

    uart_puts(UART0, (uint8_t*)"RX: ");
    uart_puthex_byte(UART0, c);
    uart_put(UART0, '\n');
    return c;
}


// Receive byte and send its complement
uint8_t recv_byte_send_compl()
{
    uint8_t c = recv_byte();
    uint8_t complement = c ^ 0xFF;

    _delay_ms(1);

    uart_put(UART1, complement);
    uart_blocking_get(UART1);  // consume echo

    uart_puts(UART0, (uint8_t*)"T_: ");
    uart_puthex_byte(UART0, complement);
    uart_put(UART0, '\n');

    return c;
}


void wait_for_55_01_8a()
{
    uint8_t i = 0;
    uint8_t c = 0;
    while (1) {
        c = recv_byte();

        if ((i == 0) && (c == 0x55)) { i = 1; }
        if ((i == 1) && (c == 0x01)) { i = 2; }
        if ((i == 2) && (c == 0x8A)) { i = 3; }
        if (i == 3) { break; }
    }
    uart_puts(UART0, (uint8_t*)"\nGOT KW\n\n");
}


void receive_block()
{
    uart_puts(UART0, (uint8_t*)"BEGIN RECEIVE BLOCK\n");

    uint8_t bytes_received = 0;
    uint8_t bytes_remaining = 1;
    uint8_t c;

    while (bytes_remaining) {
        if ((bytes_received == 0) || (bytes_remaining > 1)) {
            c = recv_byte_send_compl();
        } else {
            // do not send complement for last byte in block (0x03 block end)
            c = recv_byte();
            _delay_ms(2);
        }

        bytes_received++;

        switch (bytes_received) {
            case 1:  // block length
                bytes_remaining = c;
                break;
            case 2:
                block_counter = c;
                // fall through
            default:
                bytes_remaining--;
        }
    }

    uart_puts(UART0, (uint8_t*)"END RECEIVE BLOCK\n\n");
    return;
}


void send_ack_block()
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: ACK\n");

    send_byte_recv_compl(0x03);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0x09);                // block title (ack)
    send_byte_recv_compl(0x03);                // block end

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: ACK\n\n");
}


void send_f0_block()
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: F0\n");

    send_byte_recv_compl(0x04);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0xf0);                // block title (0xf0)
    send_byte_recv_compl(0x00);                // 0=read
    send_byte_recv_compl(0x03);                // block end

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: F0\n\n");
}


void send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop)
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: LOGIN\n");

    send_byte_recv_compl(0x08);                 // block length
    send_byte_recv_compl(++block_counter);      // block counter
    send_byte_recv_compl(0x2b);                 // block title (login)
    send_byte_recv_compl(HIGH(safe_code));      // safe code high byte
    send_byte_recv_compl(LOW(safe_code));       // safe code low byte
    send_byte_recv_compl(fern);                 // fern byte
    send_byte_recv_compl(HIGH(workshop));       // workshop code high byte
    send_byte_recv_compl(LOW(workshop));        // workshop code low byte
    send_byte_recv_compl(0x03);                 // block end

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: LOGIN\n\n");
}


void send_group_reading_block(uint8_t group)
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: GROUP READ\n");

    send_byte_recv_compl(0x04);                // block length
    send_byte_recv_compl(++block_counter);     // block counter
    send_byte_recv_compl(0x29);                // block title (group reading)
    send_byte_recv_compl(group);               // group number
    send_byte_recv_compl(0x03);

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: GROUP READ\n\n");
}


void send_read_eeprom_block(uint16_t address, uint8_t length)
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: READ EEPROM\n");

    send_byte_recv_compl(0x06);                 // block length
    send_byte_recv_compl(++block_counter);      // block counter
    send_byte_recv_compl(0x19);                 // block title (read eeprom)
    send_byte_recv_compl(length);               // number of bytes to read
    send_byte_recv_compl(HIGH(address));        // address high
    send_byte_recv_compl(LOW(address));         // address low
    send_byte(0x03);                            // block end

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: READ EEPROM\n\n");
}


void send_read_ram_block(uint16_t address, uint8_t length)
{
    uart_puts(UART0, (uint8_t*)"BEGIN SEND BLOCK: READ RAM\n");

    send_byte_recv_compl(0x06);                 // block length
    send_byte_recv_compl(++block_counter);      // block counter
    send_byte_recv_compl(0x01);                 // block title (read ram)
    send_byte_recv_compl(length);               // number of bytes to read
    send_byte_recv_compl(HIGH(address));        // address high
    send_byte_recv_compl(LOW(address));         // address low
    send_byte(0x03);                            // block end

    uart_puts(UART0, (uint8_t*)"END SEND BLOCK: READ RAM\n\n");
}


void read_all_ram()
{
    uint16_t address = 0xF000;
    while(1) {
        uart_puts(UART0, (uint8_t*)"ADDRESS = ");
        uart_puthex_16(UART0, address);
        uart_puts(UART0, (uint8_t*)"\n\n");

        uint8_t size = 0x80;
        if (address == 0xFFF0) { size = 15; }
        send_read_ram_block(address, size);
        receive_block();
        address += 80;
        if (address < 0x8000) { break; }
    }
}


void connect()
{
    send_address(0x56);
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
