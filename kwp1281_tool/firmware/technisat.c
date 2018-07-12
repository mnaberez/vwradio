#include "main.h"
#include "kwp1281.h"
#include "technisat.h"
#include "uart.h"
#include <string.h>
#include <avr/io.h>
#include <util/delay.h>


// Return a string description of a result
const char * tsat_describe_result(tsat_result_t result) {
    switch (result) {
        case TSAT_SUCCESS:           return "Success";
        case TSAT_TIMEOUT:           return "Timeout";
        case TSAT_BAD_ECHO:          return "Bad echo received";
        case TSAT_BAD_CHECKSUM:      return "Bad checksum";
        default:                     return "???";
    }
}


// If result is success, do nothing.  Otherwise, report the error and halt.
void tsat_panic_if_error(tsat_result_t result)
{
    if (result == TSAT_SUCCESS) { return; }

    const char *msg = tsat_describe_result(result);
    uart_flush_tx(UART_DEBUG);
    uart_puts(UART_DEBUG, "\n\n*** TSAT PANIC: ");
    uart_puts(UART_DEBUG, (char *)msg);
    uart_puts(UART_DEBUG, "\n");
    while(1);
}


// Send byte only
static tsat_result_t _send_byte(uint8_t tx_byte)
{
    _delay_ms(1);

    // send byte
    uart_blocking_put(UART_KLINE, tx_byte);

    // consume its echo
    uint8_t echo;
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, 3000, &echo);
    if (!uart_ready) { return TSAT_TIMEOUT; }
    if (echo != tx_byte) { return TSAT_BAD_ECHO; }

    uart_puthex(UART_DEBUG, tx_byte);
    uart_put(UART_DEBUG, ' ');
    return TSAT_SUCCESS;
}


// Receive byte only
static tsat_result_t _recv_byte(uint8_t *rx_byte_out)
{
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, 3000, rx_byte_out);
    if (!uart_ready) { return TSAT_TIMEOUT; }

    uart_puthex(UART_DEBUG, *rx_byte_out);
    uart_put(UART_DEBUG, ' ');
    return TSAT_SUCCESS;
}


static tsat_result_t tec_receive_block()
{
    uart_puts(UART_DEBUG, "RECV: ");

    tsat_result_t result;
    tsat_rx_size = 0;

    // receive block
    uint8_t remaining = 4;  // unknown + num params + command + checksum
    uint8_t checksum = 0;
    while (remaining != 0) {
        uint8_t rx_byte;
        result = _recv_byte(&rx_byte);
        if (result != TSAT_SUCCESS) { return result; }

        tsat_rx_buf[tsat_rx_size] = rx_byte;
        tsat_rx_size += 1;
        remaining -= 1;

        // second byte is number of optional params after command byte
        if (tsat_rx_size == 2) { remaining += rx_byte; }

        // add byte to checksum, unless it's the last byte (the checksum)
        if (remaining != 0) { checksum += rx_byte; }
    }

    // verify checksum
    checksum ^= 0xff;
    if (checksum == tsat_rx_buf[tsat_rx_size - 1]) {
        result = TSAT_SUCCESS;
    } else {
        result = TSAT_BAD_CHECKSUM;
    }

    uart_puts(UART_DEBUG, "\n");
    return result;
}


tsat_result_t tsat_disconnect()
{
    uart_puts(UART_DEBUG, "PERFORM DISCONNECT\n");

    // send authentication block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    _send_byte(0x10);    // only responds if this is 2-0xff
    _send_byte(0x01);    // only responds if this is 1
    _send_byte(0x0);     // number of bytes before checksum -1 (only responds to 0-2)
    _send_byte(0x5f);
    _send_byte(0x9f);    // checksum
    uart_puts(UART_DEBUG, "\n");

    // receive authentication response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}

tsat_result_t tsat_disable_eeprom_filter()
{
    uart_puts(UART_DEBUG, "PERFORM DISABLE EEPROM FILTER\n");

    // send authentication block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    _send_byte(0x10);    // only responds if this is 2-0xff
    _send_byte(0x01);    // only responds if this is 1
    _send_byte(0x1);     // number of parameters
    _send_byte(0x4d);    // command
    _send_byte(0x04);    // param 0: 0x04 = disable eeprom filtering
    _send_byte(0xac);    // checksum
    uart_puts(UART_DEBUG, "\n");

    // receive authentication response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}


tsat_result_t tsat_read_eeprom(uint16_t address, uint8_t size)
{
    uart_puts(UART_DEBUG, "PERFORM READ EEPROM\n");

    uint8_t block[] = {
        0x10,           // only responds if this is 2-0xff
        0x01,           // only responds if this is 1
        0x03,           // number of parameters
        0x48,           // command
        LOW(address),   // param 0: eeprom address low
        HIGH(address),  // param 1: eeprom address high
        size,           // param 2: number of bytes to read
        0,              // checksum
    };

    // calculate checksum
    uint8_t checksum = 0;
    for (uint8_t i=1; i<7; i++) { checksum += block[i]; }
    checksum ^= 0xff;
    block[7] = checksum;

    // send block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    for (uint8_t i=0; i<8; i++) {
        _send_byte(block[i]);
    }
    uart_puts(UART_DEBUG, "\n");

    // receive read eeprom response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}


tsat_result_t tsat_write_eeprom(uint16_t address, uint8_t size, uint8_t *data)
{
    uart_puts(UART_DEBUG, "PERFORM WRITE EEPROM\n");

    // send block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);

    _send_byte(0x10);           // only responds if this is 2-0xff
    _send_byte(0x01);           // only responds if this is 1
    _send_byte(size + 2);       // number of parameters (data size + 2 for address bytes)
    _send_byte(0x49);           // command (0x49 = write eeprom)
    _send_byte(LOW(address));   // param 0: eeprom address low
    _send_byte(HIGH(address));  // param 1: eeprom address high

    uint8_t checksum = (uint8_t)(0x01 + (size + 2) + 0x49 + LOW(address) + HIGH(address));
    for (uint8_t i=0; i<size; i++) {
        _send_byte(data[i]);
        checksum += data[i];
    }
    checksum ^= 0xff;
    _send_byte(checksum);
    uart_puts(UART_DEBUG, "\n");

    // receive read eeprom response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}


tsat_result_t tsat_read_safe_code_bcd(uint16_t *safe_code)
{
    tsat_result_t result = tsat_read_eeprom(0x000c, 4);
    if (result != TSAT_SUCCESS) { return result; }

    // safe code is stored as 4 ascii digits in eeprom
    *safe_code = 0;
    *safe_code += (tsat_rx_buf[3] - 0x30) << 12;
    *safe_code += (tsat_rx_buf[4] - 0x30) << 8;
    *safe_code += (tsat_rx_buf[5] - 0x30) << 4;
    *safe_code += (tsat_rx_buf[6] - 0x30);

    return TSAT_SUCCESS;
}


tsat_result_t tsat_connect()
{
    uart_puts(UART_DEBUG, "\nCONNECT ");
    uart_puthex(UART_DEBUG, 0x7c);
    uart_puts(UART_DEBUG, " TECHNISAT PROTOCOL\n");

    uart_init(UART_KLINE, 9600);

    // Send address at 5 baud
    kwp_send_address(KWP_RADIO_MFG);

    // receive initial block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}
