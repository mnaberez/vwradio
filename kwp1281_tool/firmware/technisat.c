#include "kwp1281.h"
#include "technisat.h"
#include "uart.h"
#include <string.h>
#include <avr/io.h>
#include <util/delay.h>


// Return a string description of a result
const char * tsat_describe_result(tsat_result_t result) {
    switch (result) {
        case TSAT_SUCCESS:            return "Success";
        case TSAT_TIMEOUT:            return "Timeout";
        case TSAT_BAD_ECHO:           return "Bad echo received";
        case TSAT_BAD_CHECKSUM:       return "Bad checksum";
        case TSAT_UNEXPECTED:         return "Unexpected response";
        case TSAT_SAFE_CODE_FILTERED: return "SAFE code locations filtered";
        default:                      return "???";
    }
}


// If result is success, do nothing.  Otherwise, report the error and halt.
void tsat_panic_if_error(tsat_result_t result)
{
    if (result == TSAT_SUCCESS) { return; }

    const char *msg = tsat_describe_result(result);
    uart_flush_tx(UART_DEBUG);
    uart_puts(UART_DEBUG, "\r\n\r\n*** TSAT PANIC: ");
    uart_puts(UART_DEBUG, (char *)msg);
    uart_puts(UART_DEBUG, "\r\n");
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


tsat_result_t tsat_receive_block(void)
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

        // all bytes are added to checksum except last byte (checksum itself)
        if (remaining != 0) { checksum += rx_byte; }
    }

    // verify checksum
    checksum ^= 0xff;
    if (checksum == tsat_rx_buf[tsat_rx_size - 1]) {
        result = TSAT_SUCCESS;
    } else {
        result = TSAT_BAD_CHECKSUM;
    }

    uart_puts(UART_DEBUG, "\r\n");
    return result;
}


tsat_result_t tsat_send_block(uint8_t *buf)
{
    // size is number of optional data bytes (byte 2) plus 5 for:
    // unknown + unknown + num params + command + checksum
    uint8_t size = buf[2] + 5;
    uint8_t checksum_index = size - 1;
    buf[checksum_index] = 0;

    uart_puts(UART_DEBUG, "SEND: ");
    _delay_ms(10);
    for (uint8_t i=0; i<size; i++) {
        // update checksum
        if (i == 0) {
            // for tx only, first byte is not included in checksum
        } else if (i < checksum_index) {
            buf[checksum_index] += buf[i];
        } else {
            buf[checksum_index] ^= 0xff;
        }

        tsat_result_t result = _send_byte(buf[i]);
        if (result != TSAT_SUCCESS) { return result; }
    }
    uart_puts(UART_DEBUG, "\r\n");

    return TSAT_SUCCESS;
}


tsat_result_t tsat_disconnect(void)
{
    uart_puts(UART_DEBUG, "PERFORM DISCONNECT\r\n");

    // send disconnect block
    uint8_t block[] = { 0x10, // only responds if this is 2-0xff
                        0x01, // only responds if this is 1
                        0x00, // number of parameters after command
                        0x5f, // command 0x5f (disconnect)
                        0     // checksum (will be calculated)
                      };
    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive disconnect response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}

// Read RAM using command 0x44
// Gamma 5 allows reading all bytes within 0x0000-0x053f only
tsat_result_t tsat_read_ram(uint16_t address, uint8_t size)
{
    uart_puts(UART_DEBUG, "PERFORM READ RAM\r\n");

    // send read ram block
    uint8_t block[] = { 0x10, // only responds if this is 2-0xff
                        0x01, // only responds if this is 1
                        0x03, // number of parameters after command
                        0x44, // command
                        LOW(address),
                        HIGH(address),
                        size,
                        0     // checksum (will be calculated)
                      };
    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive read ram response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x44) && (tsat_rx_buf[1] == size)) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}

/* Write RAM using command 0x45
 *
 * Most radios only allow writing to some ranges of memory.  This can be
 * seen in the Gamma 5 disassembly at sub_5e47.  However, usually the range
 * 0x0040-0x053f is allowed (the first 1.5K RAM, including the stack!).
 * See the RCE function below for more info on this.
 *
 * This command has a dual use.  In addition to writing to RAM, the radios check
 * if the address is a magic number (0x1462).  See the Gamma 5 disassembly at
 * lab_5c2e.  When the magic number is received, the radio does not write to RAM
 * but instead it disables the filtering that prevents the SAFE code locations
 * from being read from the EEPROM.  It also has other side effects.  See the
 * EEPROM filter disable functions below for more info.
 */
tsat_result_t tsat_write_ram(uint16_t address, uint8_t size, uint8_t *data)
{
    uart_puts(UART_DEBUG, "PERFORM WRITE RAM\r\n");

    uint8_t block[64] = {0};
    block[0] = 0x10;          // only responds if this is 2-0xff
    block[1] = 0x01;          // only responds if this is 1
    block[2] = 2 + size;      // number of parameters after command
    block[3] = 0x45;          // command
    block[4] = LOW(address);
    block[5] = HIGH(address);
    for (uint8_t i=0; i<size; i++) { block[6+i] = data[i]; }
    // one more byte in the buffer is used for the checksum written by tsat_send_block()

    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive write ram response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
        // code indicates normal write ram success
        return TSAT_SUCCESS;
    } else if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x20)) {
        // code indicates writing magic number for eeprom filter disable succeeded
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}


/* Read any memory without restrictions by using Remote Code Execution (RCE)
 * on most radios that use the M38869FFAHP microcontroller.
 *
 * Works on:
 *   VW Gamma 5  1J0035186D "VW_0004"
 *   VW Rhapsody 1J0035156  "SW_001"
 *   VW Rhapsody 1J0035156A "SW_002"
 *
 * Does not work on:
 *   Skoda Symphony 1U0035156E "SK_0015"
 *   Skoda Symphony MP3 SKZA7H 1U0035156F "SK_004" (MCU is M306N5FCTFP)
 *
 * This is used to dump the firmware of the VW Rhapsody radio.  It has been
 * tested and found to be reliable on both the VW Gamma 5 and VW Rhapsody.  On
 * the VW Gamma 5, the firmware has a KWP1281 command that will dump the firmware.
 * On the VW Rhapsody, there is no command in KWP1281 or the TechniSat protocol
 * that can dump the firmware.  This RCE is the only way to do it.
 *
 * On the Skoda Symphony 1U0035156E "SK_0015", the "write RAM" command
 * fails when writing to the stack page.
 */
tsat_result_t tsat_rce_read_memory(uint16_t address, uint16_t size)
{
    tsat_result_t tresult = TSAT_SUCCESS;
    uint8_t chunk_size = 8;

    while (size > 0) {
        if (size < chunk_size) { chunk_size = size; }

        // mitsubishi 3886 series assembly payload that sends <chunk_size>
        // bytes out the uart starting at <address>.  we can only send
        // chunks because blocking for too long will cause the radio to reset.
        uint16_t code_address = 0x01c0;
        uint8_t code[] = {
            0x78,                               //        sei
            0xa2, 0x00,                         //        ldx #0
            0xbd, LOW(address), HIGH(address),  // loop:  lda address,x
            0x85, 0x18,                         //        sta TB_RB
            0x17, 0x19, 0xfd,                   // wait1: bbc 0,SIO1STS,wait1
            0x57, 0x19, 0xfd,                   // wait2: bbc 2,SIO1STS,wait2
            0xa5, 0x18,                         //        lda TB_RB
            0xe8,                               //        inx
            0xe0, chunk_size,                   //        cpx #chunk_size
            0xd0, 0xee,                         //        bne loop
            0x58,                               //        cli
            0x60,                               //        rts
        };

        // a return address on the stack will be overwritten, causing an
        // rts instruction to execute the payload.
        uint16_t stack_address = 0x01fc;
        uint8_t stack[] = {
            // -1 because rts increments the address after popping it
            LOW(code_address-1), HIGH(code_address-1),
        };

        // write code payload
        tresult = tsat_write_ram(code_address, sizeof(code), code);
        if (tresult != TSAT_SUCCESS) { return tresult; }

        // overwrite the stack
        tresult = tsat_write_ram(stack_address, sizeof(stack), stack);
        if (tresult != TSAT_SUCCESS) { return tresult; }

        // payload should be executing now.  receive the bytes it sends.
        // the payload sends raw bytes without any technisat protocol framing.
        // if code execution was not achieved, a timeout will probably occur.
        uart_puts(UART_DEBUG, "MEM: ");
        uart_puthex16(UART_DEBUG, address);
        uart_puts(UART_DEBUG, ": ");
        for (uint8_t i=0; i<chunk_size; i++) {
          uint8_t c;
          tresult = _recv_byte(&c); // echoes byte received to debug uart
          if (tresult != TSAT_SUCCESS) { return tresult; }
        }
        uart_puts(UART_DEBUG, "\r\n");

        // if the payload worked as expected, the radio should now be back in a
        // a state where it can receive another technisat protocol command.
        size -= chunk_size;
        address += chunk_size;
    }

    return tresult;
}


tsat_result_t tsat_hello(void)
{
    uart_puts(UART_DEBUG, "PERFORM HELLO\r\n");

    // send hello block
    uint8_t block[] = { 0x10, // only responds if this is 2-0xff
                        0x01, // only responds if this is 1
                        0x00, // number of parameters after command
                        0x5e, // command 0x5e
                        0     // checksum (will be calculated)
                      };
    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive hello response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}


/*
 * Disable EEPROM filtering that prevents some locations, particularly
 * the SAFE code, from being read.  This uses command 0x4d, which has
 * fewer side effects than command 0x45.
 *
 * Works on:
 *   VW Gamma 5  1J0035186D "VW_0004"
 *   VW Rhapsody 1J0035156  "SW_001"
 *   VW Rhapsody 1J0035156A "SW_002"
 *
 * Does not work on:
 *   Skoda Symphony 1U0035156E "SK_0015"
 *   Skoda Symphony MP3 SKZA7H 1U0035156F "SK_004"
 *
 * On the Skoda Symphony, the command returns the "success" status code
 * but the EEPROM filter is not actually disabled.  Reading the SAFE code
 * area of the EEPROM returns all zeroes.
 */
tsat_result_t tsat_disable_eeprom_filter_0x4d(void)
{
    uart_puts(UART_DEBUG, "PERFORM DISABLE EEPROM FILTER\r\n");

    // send disable eeprom filter block
    uint8_t block[] = { 0x10, // only responds if this is 2-0xff
                        0x01, // only responds if this is 1
                        0x01, // number of parameters after command
                        0x4d, // command 0x4d
                        0x04, // param 0: 0x04 = disable eeprom filtering
                        0     // checksum (will be calculated)
                      };
    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive disable eeprom filter response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}


/* Disable EEPROM filtering that prevents some locations, particularly
 * the SAFE code, from being read.  This uses command 0x45, which has
 * unknown side effects.  One side effect of 0x45 is that the radio may
 * not respond to a subsequent connection on address 0x7c unless the radio
 * is unplugged first.  It is preferable to use command 0x4d (see above)
 * instead.  However, it is necessary to use 0x45 on the Skoda Symphony
 * because 0x4d does not work on that radio.
 *
 * Works on:
 *   VW Gamma 5  1J0035186D "VW_0004"
 *   VW Rhapsody 1J0035156  "SW_001"
 *   VW Rhapsody 1J0035156A "SW_002"
 *   Skoda Symphony 1U0035156E "SK_0015"
 *   Skoda Symphony MP3 SKZA7H 1U0035156F "SK_004"
 */
tsat_result_t tsat_disable_eeprom_filter_0x45(void)
{
    uart_puts(UART_DEBUG, "Warning: Radio may not respond to a subsequent "
                          "connection on 0x7C without being unplugged first.\r\n");

    uint16_t magic_address = 0x1462;
    uint8_t byte_count = 0;
    uint8_t data[] = {0};

    return tsat_write_ram(magic_address, byte_count, data);
}


/*
 * If EEPROM filtering is enabled, some protected locations (particularly
 * the SAFE code) will be returned as zeroes.
 */
tsat_result_t tsat_read_eeprom(uint16_t address, uint8_t size)
{
    uart_puts(UART_DEBUG, "PERFORM READ EEPROM\r\n");

    // send read eeprom block
    uint8_t block[] = { 0x10,           // only responds if this is 2-0xff
                        0x01,           // only responds if this is 1
                        0x03,           // number of parameters after command
                        0x48,           // command 0x48 (read eeprom)
                        LOW(address),   // param 0: eeprom address low
                        HIGH(address),  // param 1: eeprom address high
                        size,           // param 2: number of bytes to read
                        0,              // checksum (will be calculated)
                      };
    tsat_result_t result = tsat_send_block(block);
    if (result != TSAT_SUCCESS) { return result; }

    // receive read eeprom response block
    result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if (tsat_rx_buf[2] == 0x48) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}


/*
 * Read the SAFE code from the EEPROM.  The SAFE code is protected so
 * EEPROM filtering must be disabled first.
 */
tsat_result_t tsat_read_safe_code_bcd(uint16_t *safe_code)
{
    *safe_code = 0;

    tsat_result_t result = tsat_read_eeprom(0x000c, 4);
    if (result != TSAT_SUCCESS) { return result; }

    // safe code should be 4 ascii chars.  if filtering is still
    // enabled then we will get all zeroes instead of ascii chars.
    if ((tsat_rx_buf[3] == 0) && (tsat_rx_buf[4] == 0) &&
        (tsat_rx_buf[5] == 0) && (tsat_rx_buf[6] == 0)) {

        return TSAT_SAFE_CODE_FILTERED;
    }

    // convert 4 ascii chars to 16-bit bcd number
    *safe_code += (tsat_rx_buf[3] - 0x30) << 12;
    *safe_code += (tsat_rx_buf[4] - 0x30) << 8;
    *safe_code += (tsat_rx_buf[5] - 0x30) << 4;
    *safe_code += (tsat_rx_buf[6] - 0x30);

    return TSAT_SUCCESS;
}


tsat_result_t tsat_read_cluster_id(uint16_t *cluster_id)
{
    *cluster_id = 0;

    tsat_result_t result = tsat_read_eeprom(0x355, 2);
    if (result != TSAT_SUCCESS) { return result; }

    *cluster_id += tsat_rx_buf[3];      // low byte
    *cluster_id += tsat_rx_buf[4] << 8; // high byte

    return TSAT_SUCCESS;
}


tsat_result_t tsat_write_eeprom(uint16_t address, uint8_t size, uint8_t *data)
{
    uart_puts(UART_DEBUG, "PERFORM WRITE EEPROM\r\n");

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
    uart_puts(UART_DEBUG, "\r\n");

    // receive read eeprom response block
    tsat_result_t result = tsat_receive_block();
    if (result != TSAT_SUCCESS) { return result; }

    // check status
    if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
        return TSAT_SUCCESS;
    } else {
        return TSAT_UNEXPECTED;
    }
}


tsat_result_t tsat_connect(uint8_t address, uint32_t baud)
{
    uart_puts(UART_DEBUG, "\r\nCONNECT ");
    uart_puthex(UART_DEBUG, 0x7c);
    uart_puts(UART_DEBUG, " TECHNISAT PROTOCOL\r\n");

    uart_init(UART_KLINE, baud);

    // Send address at 5 baud
    uart_disable(UART_KLINE);
    kwp_send_address(address);
    uart_enable(UART_KLINE);

    // try to receive a block
    // gamma 5 sends a block, rhapsody sends nothing
    tsat_result_t result = tsat_receive_block();

    if (result == TSAT_SUCCESS) {
        // radio sent a block (probably gamma 5)
        // check status
        if ((tsat_rx_buf[2] == 0x5e) && (tsat_rx_buf[3] == 0x00)) {
            return TSAT_SUCCESS;
        } else {
            return TSAT_UNEXPECTED;
        }
    } else if (result == TSAT_TIMEOUT) {
        // radio didn't send a block (probably rhapsody)
        // send hello to see if it's there
        uart_puts(UART_DEBUG, "Timeout; trying hello\r\n");
        return tsat_hello();
    } else {
        // error
        return result;
    }
}
