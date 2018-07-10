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

    uint8_t rx_byte;
    tsat_result_t result;

    // receive unknown first byte
    result = _recv_byte(&rx_byte);
    if (result != TSAT_SUCCESS) { return result; }
    tsat_rx_buf[0] = rx_byte;

    // receive length byte
    result = _recv_byte(&rx_byte);
    if (result != TSAT_SUCCESS) { return result; }
    tsat_rx_buf[1] = rx_byte;

    uint8_t length = rx_byte + 1 + 1;
    for (uint8_t i=0; i<length; i++) {
        result = _recv_byte(&rx_byte);
        if (result != TSAT_SUCCESS) { return result; }
        tsat_rx_buf[i+2] = rx_byte;
    }
    tsat_rx_size = length;

    uart_puts(UART_DEBUG, "\n");
    return TSAT_SUCCESS;
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

tsat_result_t tsat_authenticate()
{
    uart_puts(UART_DEBUG, "PERFORM AUTHENTICATION\n");

    // send authentication block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    _send_byte(0x10);    // only responds if this is 2-0xff
    _send_byte(0x01);    // only responds if this is 1
    _send_byte(0x2);     // number of bytes before checksum -1 (only responds to 0-2)
    _send_byte(0x45);
    _send_byte(0x62);
    _send_byte(0x14);
    _send_byte(0x41);    // checksum
    uart_puts(UART_DEBUG, "\n");

    // receive authentication response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}


tsat_result_t tsat_read_eeprom()
{
    uart_puts(UART_DEBUG, "PERFORM READ EEPROM\n");

    // send read eeprom block
    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    _send_byte(0x10);    // only responds if this is 2-0xff
    _send_byte(0x01);    // only responds if this is 1
    _send_byte(0x2);     // number of bytes before checksum -1 (only responds to 0-2)
    _send_byte(0x48);
    _send_byte(0x00);
    _send_byte(0x00);
    _send_byte(0xb4);    // checksum
    uart_puts(UART_DEBUG, "\n");

    // receive read eeprom response block
    tsat_result_t result = tec_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // TODO check status code in rx buffer

    return TSAT_SUCCESS;
}


tsat_result_t tsat_read_safe_code_bcd(uint16_t *safe_code)
{
    tsat_result_t result = tsat_read_eeprom();
    if (result != TSAT_SUCCESS) { return result; }

    // safe code is stored as 4 ascii digits in eeprom
    *safe_code = 0;
    *safe_code += (tsat_rx_buf[15] - 0x30) << 12;
    *safe_code += (tsat_rx_buf[16] - 0x30) << 8;
    *safe_code += (tsat_rx_buf[17] - 0x30) << 4;
    *safe_code += (tsat_rx_buf[18] - 0x30);

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
