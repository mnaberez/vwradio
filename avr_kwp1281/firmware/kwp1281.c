#include "main.h"
#include "kwp1281.h"
#include "uart.h"
#include <string.h>
#include <avr/io.h>
#include <util/delay.h>

// Send module address at 5bps
static void _send_address(uint8_t address)
{
    uart_puts(UART_DEBUG, "INIT 0x");
    uart_puthex(UART_DEBUG, address);
    uart_puts(UART_DEBUG, "\n\n");

    UCSR1B &= ~_BV(RXEN1);  // Disable RX (PD2/TXD1)
    UCSR1B &= ~_BV(TXEN1);  // Disable TX (PD3/TXD1)
    DDRD |= _BV(PD3);       // PD3 = output

    uint8_t parity = 1;
    for (uint8_t i=0; i<10; i++) {
        uint8_t bit;
        switch (i) {
            case 0:     // start bit
                bit = 0;
                break;
            case 8:     // parity bit
                bit = parity;
                break;
            case 9:     // stop bit
                bit = 1;
                break;
            default:    // 7 data bits
                bit = (uint8_t)((address & (1 << (i - 1))) != 0);
                parity ^= bit;
        }

        if (bit == 1) {
          PORTD |= _BV(PD3);    // high
        } else {
          PORTD &= ~_BV(PD3);   // low
        }
        _delay_ms(200);         // 1000ms / 5bps = 200ms per bit
    }

    UCSR1B |= _BV(TXEN1);   // Enable TX (PD3/TXD1)
    UCSR1B |= _BV(RXEN1);   // Enable RX (PD2/TXD1)
    DDRD &= ~_BV(PD3);      // PD3 = input
}


// Send byte only
static void _send_byte(uint8_t c)
{
    _delay_ms(1);

    uart_put(UART_KWP, c);
    uart_blocking_get(UART_KWP);  // consume echo

    uart_puts(UART_DEBUG, "TX: ");
    uart_puthex(UART_DEBUG, c);
    uart_put(UART_DEBUG, '\n');
}


// Send byte and receive its complement
static void _send_byte_recv_compl(uint8_t c)
{
    _send_byte(c);
    uint8_t complement = uart_blocking_get(UART_KWP);

    uart_puts(UART_DEBUG, "R_: ");
    uart_puthex(UART_DEBUG, complement);
    uart_put(UART_DEBUG, '\n');
}


// Receive byte only
static uint8_t _recv_byte()
{
    uint8_t c = uart_blocking_get(UART_KWP);

    uart_puts(UART_DEBUG, "RX: ");
    uart_puthex(UART_DEBUG, c);
    uart_put(UART_DEBUG, '\n');
    return c;
}


// Receive byte and send its complement
static uint8_t _recv_byte_send_compl()
{
    uint8_t c = _recv_byte();
    uint8_t complement = c ^ 0xFF;

    _delay_ms(1);

    uart_put(UART_KWP, complement);
    uart_blocking_get(UART_KWP);  // consume echo

    uart_puts(UART_DEBUG, "T_: ");
    uart_puthex(UART_DEBUG, complement);
    uart_put(UART_DEBUG, '\n');

    return c;
}


static void _wait_for_55_01_8a()
{
    uint8_t i = 0;
    uint8_t c = 0;
    while (1) {
        c = _recv_byte();

        if ((i == 0) && (c == 0x55)) { i = 1; }
        if ((i == 1) && (c == 0x01)) { i = 2; }
        if ((i == 2) && (c == 0x8A)) { i = 3; }
        if (i == 3) { break; }
    }
    uart_puts(UART_DEBUG, "\nGOT KW\n\n");
}


void kwp_receive_block()
{
    uart_puts(UART_DEBUG, "BEGIN RECEIVE BLOCK\n");

    kwp_rx_size = 0;
    memset(kwp_rx_buf, 0, sizeof(kwp_rx_buf));

    uint8_t bytes_remaining = 1;
    uint8_t c;

    while (bytes_remaining) {
        if ((kwp_rx_size == 0) || (bytes_remaining > 1)) {
            c = _recv_byte_send_compl();
        } else {
            // do not send complement for last byte in block (0x03 block end)
            c = _recv_byte();
            _delay_ms(2);
        }

        kwp_rx_buf[kwp_rx_size++] = c;

        switch (kwp_rx_size) {
            case 1:  // block length
                bytes_remaining = c;
                break;
            case 2:
                kwp_block_counter = c;
                // fall through
            default:
                bytes_remaining--;
        }
    }

    _delay_ms(5);
    uart_puts(UART_DEBUG, "END RECEIVE BLOCK\n\n");
    return;
}


void kwp_send_ack_block()
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: ACK\n");

    _send_byte_recv_compl(0x03);                // block length
    _send_byte_recv_compl(++kwp_block_counter); // block counter
    _send_byte_recv_compl(0x09);                // block title (ack)
    _send_byte_recv_compl(0x03);                // block end

    uart_puts(UART_DEBUG, "END SEND BLOCK: ACK\n\n");
}


void kwp_send_f0_block()
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: F0\n");

    _send_byte_recv_compl(0x04);                // block length
    _send_byte_recv_compl(++kwp_block_counter); // block counter
    _send_byte_recv_compl(0xf0);                // block title (0xf0)
    _send_byte_recv_compl(0x00);                // 0=read
    _send_byte_recv_compl(0x03);                // block end

    uart_puts(UART_DEBUG, "END SEND BLOCK: F0\n\n");
}


void kwp_send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop)
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: LOGIN\n");

    _send_byte_recv_compl(0x08);                 // block length
    _send_byte_recv_compl(++kwp_block_counter);  // block counter
    _send_byte_recv_compl(0x2b);                 // block title (login)
    _send_byte_recv_compl(HIGH(safe_code));      // safe code high byte
    _send_byte_recv_compl(LOW(safe_code));       // safe code low byte
    _send_byte_recv_compl(fern);                 // fern byte
    _send_byte_recv_compl(HIGH(workshop));       // workshop code high byte
    _send_byte_recv_compl(LOW(workshop));        // workshop code low byte
    _send_byte_recv_compl(0x03);                 // block end

    uart_puts(UART_DEBUG, "END SEND BLOCK: LOGIN\n\n");
}


void kwp_send_group_reading_block(uint8_t group)
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: GROUP READ\n");

    _send_byte_recv_compl(0x04);                // block length
    _send_byte_recv_compl(++kwp_block_counter); // block counter
    _send_byte_recv_compl(0x29);                // block title (group reading)
    _send_byte_recv_compl(group);               // group number
    _send_byte_recv_compl(0x03);

    uart_puts(UART_DEBUG, "END SEND BLOCK: GROUP READ\n\n");
}


void kwp_send_read_eeprom_block(uint16_t address, uint8_t length)
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: READ EEPROM\n");

    _send_byte_recv_compl(0x06);                 // block length
    _send_byte_recv_compl(++kwp_block_counter);  // block counter
    _send_byte_recv_compl(0x19);                 // block title (read eeprom)
    _send_byte_recv_compl(length);               // number of bytes to read
    _send_byte_recv_compl(HIGH(address));        // address high
    _send_byte_recv_compl(LOW(address));         // address low
    _send_byte(0x03);                            // block end

    uart_puts(UART_DEBUG, "END SEND BLOCK: READ EEPROM\n\n");
}


void kwp_send_read_ram_block(uint16_t address, uint8_t length)
{
    uart_puts(UART_DEBUG, "BEGIN SEND BLOCK: READ RAM\n");

    _send_byte_recv_compl(0x06);                 // block length
    _send_byte_recv_compl(++kwp_block_counter);  // block counter
    _send_byte_recv_compl(0x01);                 // block title (read ram)
    _send_byte_recv_compl(length);               // number of bytes to read
    _send_byte_recv_compl(HIGH(address));        // address high
    _send_byte_recv_compl(LOW(address));         // address low
    _send_byte(0x03);                            // block end

    uart_puts(UART_DEBUG, "END SEND BLOCK: READ RAM\n\n");
}


void kwp_read_ram(uint16_t start_address, uint16_t size)
{
    uint16_t address = start_address;
    uint16_t remaining = size;

    while (remaining != 0) {
        uint8_t chunksize = 32;
        if (remaining < chunksize) { chunksize = remaining; }

        kwp_send_read_ram_block(address, chunksize);
        kwp_receive_block();

        uart_puts(UART_DEBUG, "RAM: ");
        uart_puthex16(UART_DEBUG, address);
        uart_puts(UART_DEBUG, ": ");
        for (uint8_t i=0; i<chunksize; i++) {
            uart_puthex(UART_DEBUG, kwp_rx_buf[3 + i]);
            uart_put(UART_DEBUG, ' ');
        }
        uart_puts(UART_DEBUG, "\n\n");

        address += chunksize;
        remaining -= chunksize;

        kwp_send_ack_block(address, chunksize);
        kwp_receive_block();
    }
}


void kwp_connect(uint8_t address)
{
    _send_address(address);
    _wait_for_55_01_8a();
    _delay_ms(30);
    _send_byte(0x75);

    memset(kwp_vag_number,  0, sizeof(kwp_vag_number));
    memset(kwp_component_1, 0, sizeof(kwp_component_1));
    memset(kwp_component_2, 0, sizeof(kwp_component_2));

    for (uint8_t i=0; i<4; i++) {
        kwp_receive_block();
        kwp_send_ack_block();

        switch (i) {
            case 0:     // 0xF6 (ASCII/Data): "1J0035180D  "
                memcpy(&kwp_vag_number,  &kwp_rx_buf[3], 12);
                break;
            case 1:     // 0xF6 (ASCII/Data): " RADIO 3CP  "
                memcpy(&kwp_component_1, &kwp_rx_buf[3], 12);
                break;
            case 2:     // 0xF6 (ASCII/Data): "        0001"
                memcpy(&kwp_component_2, &kwp_rx_buf[3], 12);
                break;
            default:    // 0xF6 (ASCII/Data): 0x00 0x0A 0xF8 0x00 0x00
                break;
        }
    }

    // Receive 0x09 (Acknowledge)
    kwp_receive_block();
}
