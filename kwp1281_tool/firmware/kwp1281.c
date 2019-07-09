#include "main.h"
#include "autobaud.h"
#include "kwp1281.h"
#include "uart.h"
#include <stdio.h>
#include <string.h>
#include <avr/io.h>
#include <util/delay.h>

// Return a string description of a result
const char * kwp_describe_result(kwp_result_t result) {
    switch (result) {
        case KWP_SUCCESS:           return "Success";
        case KWP_TIMEOUT:           return "Timeout";
        case KWP_SYNC_BAD_BAUD:     return "Baud rate measured from sync is unachievable";
        case KWP_BAD_KEYWORD:       return "Bad keyword received (not KWP1281)";
        case KWP_BAD_ECHO:          return "Bad echo received";
        case KWP_BAD_COMPLEMENT:    return "Bad complement received";
        case KWP_BAD_BLK_LENGTH:    return "Bad block length received";
        case KWP_BAD_BLK_END:       return "Bad block end marker byte received";
        case KWP_RX_OVERFLOW:       return "RX buffer overflow";
        case KWP_UNEXPECTED:        return "Unexpected block title received";
        case KWP_DATA_TOO_SHORT:    return "Length of data returned is shorter than expected";
        case KWP_DATA_TOO_LONG:     return "Length of data returned is longer than expected";
        default:                    return "???";
    }
}


// If result is success, do nothing.  Otherwise, report the error and halt.
void kwp_panic_if_error(kwp_result_t result)
{
    if (result == KWP_SUCCESS) { return; }

    const char *msg = kwp_describe_result(result);
    uart_flush_tx(UART_DEBUG);
    uart_puts(UART_DEBUG, "\r\n\r\n*** KWP PANIC: ");
    uart_puts(UART_DEBUG, (char *)msg);
    uart_puts(UART_DEBUG, "\r\n");
    while(1);
}


// Send byte only
static kwp_result_t _send_byte(uint8_t tx_byte)
{
    _delay_ms(KWP_INTERBYTE_MS);

    // send byte
    uart_blocking_put(UART_KLINE, tx_byte);

    // consume its echo
    uint8_t echo;
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, KWP_ECHO_TIMEOUT_MS, &echo);
    if (!uart_ready) { return KWP_TIMEOUT; }
    if (echo != tx_byte) { return KWP_BAD_ECHO; }

    uart_puthex(UART_DEBUG, tx_byte);
    uart_put(UART_DEBUG, ' ');
    return KWP_SUCCESS;
}


// Send byte and receive its complement
static kwp_result_t _send_byte_recv_compl(uint8_t tx_byte)
{
    kwp_result_t result = _send_byte(tx_byte);
    if (result != KWP_SUCCESS) { return result; }

    uint8_t complement;
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, KWP_RECV_TIMEOUT_MS, &complement);
    if (!uart_ready) { return KWP_TIMEOUT; }
    if (complement != (tx_byte ^ 0xff)) { return KWP_BAD_COMPLEMENT; }

    return KWP_SUCCESS;
}


// Receive byte only
static kwp_result_t _recv_byte(uint8_t *rx_byte_out)
{
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, KWP_RECV_TIMEOUT_MS, rx_byte_out);
    if (!uart_ready) { return KWP_TIMEOUT; }

    uart_puthex(UART_DEBUG, *rx_byte_out);
    uart_put(UART_DEBUG, ' ');
    return KWP_SUCCESS;
}


// Receive byte and send its complement
static kwp_result_t _recv_byte_send_compl(uint8_t *rx_byte_out)
{
    kwp_result_t result = _recv_byte(rx_byte_out);
    if (result != KWP_SUCCESS) { return result; }

    _delay_ms(KWP_INTERBYTE_MS);

    // send complement byte
    uint8_t complement = *rx_byte_out ^ 0xFF;
    uart_blocking_put(UART_KLINE, complement);

    // consume its echo
    uint8_t echo;
    uint8_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, KWP_ECHO_TIMEOUT_MS, &echo);
    if (!uart_ready) { return KWP_TIMEOUT; }
    if (echo != complement) { return KWP_BAD_ECHO; }

    return KWP_SUCCESS;
}


// Receive the two keyword bytes after the 0x55 sync byte
// during the initial connection
static kwp_result_t _recv_keyword(uint16_t *keyword_out)
{
    uint8_t high, low;

    kwp_result_t result = _recv_byte(&high);
    if (result != KWP_SUCCESS) { return result; }

    result = _recv_byte(&low);
    if (result != KWP_SUCCESS) { return result; }

    *keyword_out = WORD(high, low);
    return KWP_SUCCESS;
}


// Send a block
kwp_result_t kwp_send_block(uint8_t *buf)
{
    uint8_t block_length = buf[0];
    uint8_t buf_size = block_length + 1;

    buf[1] = ++kwp_block_counter;   // insert block counter
    buf[buf_size - 1] = 0x03;       // insert block end

    uart_puts(UART_DEBUG, "SEND: ");

    // send each byte and receive its complement, except block end
    kwp_result_t result;
    uint8_t i;
    for (i=0; i<(buf_size-1); i++) {
        result = _send_byte_recv_compl(buf[i]);
        if (result != KWP_SUCCESS) { return result; }
    }

    // send block end, do not receive complement
    result = _send_byte(buf[i]);
    if (result != KWP_SUCCESS) { return result; }

    uart_puts(UART_DEBUG, "\r\n");
    return KWP_SUCCESS;
}


// Receive a block
kwp_result_t kwp_receive_block()
{
    uart_puts(UART_DEBUG, "RECV: ");

    kwp_rx_size = 0;
    memset(kwp_rx_buf, 0, sizeof(kwp_rx_buf));

    uint8_t bytes_remaining = 1;
    uint8_t c;
    kwp_result_t result;

    while (bytes_remaining) {
        if ((kwp_rx_size == 0) || (bytes_remaining > 1)) {
            result = _recv_byte_send_compl(&c);
            if (result != KWP_SUCCESS) { return result; }
        } else {
            // do not send complement for last byte in block (0x03 block end)
            result = _recv_byte(&c);
            if (result != KWP_SUCCESS) { return result; }
            if (c != 0x03) { return KWP_BAD_BLK_END; }
        }

        kwp_rx_buf[kwp_rx_size++] = c;
        if (kwp_rx_size == sizeof(kwp_rx_buf)) { return KWP_RX_OVERFLOW; }

        switch (kwp_rx_size) {
            case 1:  // block length (must be at least 3 for title, counter, end)
                if (c < 3) { return KWP_BAD_BLK_LENGTH; }
                bytes_remaining = c;
                break;
            case 2:  // block counter
                if (kwp_is_first_block) {   // set initial value
                    kwp_block_counter = c;
                    kwp_is_first_block = false;
                } else {
                    kwp_block_counter++;
                    // we used to detect a mismatch in the block counter here but had
                    // to remove the check.  it worked fine on several radios but not
                    // on the vw rhapsody (technisat), which does not always send the
                    // correct block counter.
                }
                // fall through
            default:
                bytes_remaining--;
        }
    }

    _delay_ms(KWP_INTERBLOCK_MS);
    uart_puts(UART_DEBUG, "\r\n");
    return KWP_SUCCESS;
}


// Receive a block; halt unless it has the expected title
kwp_result_t kwp_receive_block_expect(uint8_t title)
{
    kwp_result_t result = kwp_receive_block();
    if (result != KWP_SUCCESS) { return result; }
    if (kwp_rx_buf[2] == title) { return KWP_SUCCESS; }

    uart_flush_tx(UART_DEBUG);
    uart_puts(UART_DEBUG, "\r\n\r\nExpected to receive title 0x");
    uart_puthex(UART_DEBUG, title);
    uart_puts(UART_DEBUG, ", got 0x");
    uart_puthex(UART_DEBUG, kwp_rx_buf[2]);
    uart_puts(UART_DEBUG, "\r\n");

    return KWP_UNEXPECTED;
}


static kwp_result_t _send_ack_block()
{
    uart_puts(UART_DEBUG, "PERFORM ACK\r\n");
    uint8_t block[] = {
        0x03,       // block length
        0,          // placeholder for block counter
        KWP_ACK,    // block title
        0,          // placeholder for block end
    };
    return kwp_send_block(block);
}


/*
 * Send an ACK block and receive the response ACK block.  A module
 * will typically disconnect if it does not receive any blocks
 * for some period of time.  This can be used to keep the connection
 * alive when no other commands need to be sent.
 */
kwp_result_t kwp_acknowledge()
{
  kwp_result_t result = _send_ack_block();
  if (result != KWP_SUCCESS) { return result; }

  return kwp_receive_block_expect(KWP_ACK);
}


kwp_result_t kwp_send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop)
{
    uart_puts(UART_DEBUG, "PERFORM LOGIN\r\n");
    uint8_t block[] = {
        0x08,               // block length
        0,                  // placeholder for block counter
        KWP_LOGIN,          // block title
        HIGH(safe_code),    // safe code high byte
        LOW(safe_code),     // safe code low byte
        fern,               // fern byte
        HIGH(workshop),     // workshop code high byte
        LOW(workshop),      // workshop code low byte
        0,                  // placeholder for block end
    };
    return kwp_send_block(block);
}


// login using the safe code and read the secret group 0x19
// should work on any radio if the safe code is correct
kwp_result_t kwp_login_safe(uint16_t safe_code)
{
    kwp_result_t result = kwp_send_login_block(safe_code, 0x01, 0x869f);
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_ACK);
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_send_group_reading_block(0x19);
    if (result != KWP_SUCCESS) { return result; }

    // all radios require reading group 0x19 to unlock the protected commands.
    // some return ack, some lie and return nak (treat it like ack).
    //   ack: premium 4 (clarion), audi chorus (blaupunkt)
    //   nak: premium 5 (delco), gamma 5 (technisat)
    result = kwp_receive_block();
    return result;
}

/* Receive all fault blocks.  This is used to handle the responses
 * for both reading faults and clearing faults.
 *
 * It has been observed with several modules that if there are no
 * faults, the response will contain one special fault that means
 * "no fault".  Otherwise, it has been observed that the module will
 * send up to 4 faults for the first request.  Each successive request
 * will return up to 4 more.  This function does not assume 4 is a
 * magic number and will process as many faults as are returned in each
 * response.  This function will make as many requests as needed to
 * retrieve all of the faults.
 */
static kwp_result_t _receive_all_fault_blocks()
{
    kwp_result_t result = kwp_receive_block_expect(KWP_R_FAULTS);
    if (result != KWP_SUCCESS) { return result; }

    uint8_t faults_count = 0;

    while(1) {
        /*
         * Response:
         * 0F 0B FC 00 10 10 00 11 11 00 12 12 00 13 13 03
         * LL CC TT A0 A1 A2 B0 B1 B2 C0 C1 C1 D0 D1 D2 EE
         *
         * LL    = Block length
         * CC    = Block counter
         * TT    = Block title (0xFC = response to read faults)
         * A0,A1 = Fault 1 Fault Code (A0=High Byte, A1=Low Byte)
         * A2    = Fault 1 Elaboration Code
         * B0,B1 = Fault 2 Fault Code (B0=High Byte, B1=Low Byte)
         * B2    = Fault 2 Elaboration Code
         * C0,C1 = Fault 2 Fault Code (C0=High Byte, C1=Low Byte)
         * C2    = Fault 2 Elaboration Code
         * D0,D1 = Fault 2 Fault Code (D0=High Byte, D1=Low Byte)
         * D2    = Fault 2 Elaboration Code
         * EE    = Block end
         */

        // block length - (counter + title + end)
        uint8_t datalen = kwp_rx_buf[0] - 3;

        // 3 bytes per fault
        if (datalen % 3 != 0) { return KWP_DATA_TOO_SHORT; }

        // print each fault
        uint8_t pos = 3;  // rx buffer position: first byte after block title
        while (pos <= datalen) {
            uint16_t fault_code = WORD(kwp_rx_buf[pos+0], kwp_rx_buf[pos+1]);
            uint8_t elaboration_code = kwp_rx_buf[pos+2];

            if ((fault_code == 0xFFFF) && (elaboration_code == 0x88)) {
              // this is a special fault that means "no fault".  it has been
              // observed on several modules that when there are no faults,
              // this special fault is returned.  we may be able to stop
              // here but it seems safer to ignore this and keep going just
              // in case any real faults are also returned.

            } else {
              faults_count += 1;

              char msg[60];
              sprintf(msg, "FAULT: NUM=%02X CODE=%04X ELABORATION=%02X\r\n",
                      faults_count, fault_code, elaboration_code);
              uart_puts(UART_DEBUG, msg);
            }

            pos += 3;
        }

        // send an ack block to check for more faults
        // (if the last response returned fewer than 4 faults, we may be
        //  able to stop here, but it seems safer to always do this.)
        result = _send_ack_block();
        if (result != KWP_SUCCESS) { return result; }
        result = kwp_receive_block();
        if (result != KWP_SUCCESS) { return result; }

        // if the response to ack is ack, there are no more faults
        if (kwp_rx_buf[2] == KWP_ACK) { break; }

        // otherwise, the response to ack should be a new faults block
        if (kwp_rx_buf[2] != KWP_R_FAULTS) { return KWP_UNEXPECTED; }

        // in the insane case we receive too many faults, bail out
        if (faults_count > 200) { return KWP_UNEXPECTED; }
    }

    return KWP_SUCCESS;
}

static kwp_result_t _send_read_faults_block()
{
    uart_puts(UART_DEBUG, "PERFORM READ FAULTS\r\n");
    uint8_t block[] = {
        0x03,               // block length
        0,                  // placeholder for block counter
        KWP_READ_FAULTS,    // block title
        0,                  // placeholder for block end
    };
    return kwp_send_block(block);
}

/**
 * Read all fault codes (Diagnotic Trouble Codes / DTCs) in the
 * module and print them.
 */
kwp_result_t kwp_read_faults()
{
    kwp_result_t result = _send_read_faults_block();
    if (result != KWP_SUCCESS) { return result; }

    return _receive_all_fault_blocks();
}

static kwp_result_t _send_clear_faults_block()
{
    uart_puts(UART_DEBUG, "PERFORM CLEAR FAULTS\r\n");
    uint8_t block[] = {
        0x03,               // block length
        0,                  // placeholder for block counter
        KWP_CLEAR_FAULTS,   // block title
        0,                  // placeholder for block end
    };
    return kwp_send_block(block);
}

/**
 * Clear all fault codes (Diagnotic Trouble Codes / DTCs) in the
 * module.  This may or may not actually clear them, depending
 * on if the module decides the faults can be cleared.  After
 * clearing, any remaining DTCs are read from the module and printed.
 */
kwp_result_t kwp_clear_faults()
{
    kwp_result_t result = _send_clear_faults_block();
    if (result != KWP_SUCCESS) { return result; }

    return _receive_all_fault_blocks();
}


kwp_result_t kwp_send_group_reading_block(uint8_t group)
{
    uart_puts(UART_DEBUG, "PERFORM GROUP READ\r\n");
    uint8_t block[] = {
        0x04,               // block length
        0,                  // placeholder for block counter
        KWP_GROUP_READING,  // block title
        group,              // group number
        0,                  // placeholder for block end
    };
    return kwp_send_block(block);
}

/*
 * Perform a group reading (measuring blocks) for the specific group,
 * receive the response block and validate it.
 *
 * TODO: figure out what to do about advanced id's (groups 0x50 & 0x51)
 * found in the Gamma 5 (TechniSat) radio.  Those responses are an 0xE7
 * block title but the data does not conform to the usual 0xE7 format.
 */
kwp_result_t kwp_read_group(uint8_t group)
{
    kwp_result_t result = kwp_send_group_reading_block(group);
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block();
    if (result != KWP_SUCCESS) { return result; }

    // in some rare cases, a module may return an ACK title instead
    // of the usual 0xE7 title.  this happens when the group number
    // is valid but there are no measurements to return.  this can be
    // observed on both the vw premium 4 radio (clarion) and on the
    // audi chorus radio (blaupunkt) by reading the secret group 0x19.
    uint8_t block_title = kwp_rx_buf[2];
    if (block_title == KWP_ACK) { return KWP_SUCCESS; }

    // otherwise, expect the typical 0xE7 response title
    if (block_title != KWP_R_GROUP_READING) { return KWP_UNEXPECTED; }

    /*
     * Response:
     * 0F C7 E7 01 C8 16 05 0F 7C 14 64 7E 04 4B 6D 03
     * LL CC TT A0 A1 A2 B0 B1 B2 C0 C1 C2 D0 D1 D2 EE
     *
     * LL    = Block length
     * CC    = Block counter
     * TT    = Block title (0xE7 = response to group reading)
     * A0    = Measurement 1 Formula (0x01 = RPM)
     * A1,A2 = Measurement 1 Value
     * B0    = Measurement 2 Formula (0x05 = deg C)
     * B1,B2 = Measurement 2 Value
     * C0    = Measurement 3 Formula (0x14 = %)
     * C1,B2 = Measurement 3 Value
     * D0    = Measurement 4 Formula (0x04 = ATDC/BTDC)
     * D1,D2 = Measurement 4 Value
     * EE    = Block end
     */
    uint8_t datalen = kwp_rx_buf[0] - 3;  // block length - (counter + title + end)

    // module may send up to 4 measurements (4 * 3 bytes = 12)
    if (datalen > 12) { return KWP_DATA_TOO_LONG; }

    // must receive 3 bytes for each measurement
    if (datalen % 3 != 0) { return KWP_DATA_TOO_SHORT; }

    // print each measurement
    uint8_t cell = 1; // measuring block cell 1 of 4
    uint8_t pos = 3;  // rx buffer position: first byte after block title
    while (pos <= datalen) {
        uint8_t formula = kwp_rx_buf[pos+0];
        uint16_t value = WORD(kwp_rx_buf[pos+1], kwp_rx_buf[pos+2]);

        char msg[60];
        sprintf(msg, "MEAS: GROUP=%02X CELL=%02X FORMULA=%02X VALUE=%04X\r\n",
                group, cell, formula, value);
        uart_puts(UART_DEBUG, msg);

        pos += 3;
        cell++;
    }

    return KWP_SUCCESS;
}


static kwp_result_t _send_read_ident_block()
{
    uart_puts(UART_DEBUG, "PERFORM READ IDENTIFICATION\r\n");
    uint8_t block[] = {
        0x03,               // block length
        0,                  // placeholder for block counter
        KWP_READ_IDENT,     // block title
        0,                  // placeholder for block end
    };
    return kwp_send_block(block);
}

/*
 * Receive all title 0xF6 ASCII/data blocks identifying this module.
 * This is used in 3 places:
 *
 *  - During the initial connection
 *  - For response to block title 0x00 Read Identification
 *  - For response to block title 0x08 Recoding
 *
 * A module will normally send 4 blocks:
 *
 *  - 3 with component info
 *  - 1 with workshop and coding
 *
 * In some rare cases, like the Premium 5 radio in manufacturing mode (address
 * 0x7C), there will be no ASCII/data blocks sent during the initial connection.
 */
static kwp_result_t _receive_all_ident_blocks()
{
    uint8_t blocks_received = 0;
    while (1) {
        kwp_result_t result = kwp_receive_block();
        if (result != KWP_SUCCESS) { return result; }

        if (kwp_rx_buf[2] == KWP_ACK) { return KWP_SUCCESS; }
        if (kwp_rx_buf[2] != KWP_R_ASCII_DATA) { return KWP_UNEXPECTED; }

        switch (blocks_received++) {
            case 0:    // 0xF6 (ASCII/Data): "1J0035180D  "
                memcpy(&kwp_vag_number,  &kwp_rx_buf[3], 12); break;
            case 1:    // 0xF6 (ASCII/Data): " RADIO 3CP  "
                memcpy(&kwp_component_1, &kwp_rx_buf[3], 12); break;
            case 2:    // 0xF6 (ASCII/Data): "        0001"
                memcpy(&kwp_component_2, &kwp_rx_buf[3], 12); break;
            case 0xFF: // insane case of too many blocks
                return KWP_UNEXPECTED;
            default:   // ignore block
                break;
        }

        result = _send_ack_block();
        if (result != KWP_SUCCESS) { return result; }
    }
}

/*
 * Print the module's identification that has been previously
 * stored in the globals.  The globals are populated after the
 * initial connection and after issuing a read identification.
 */
static void _print_identification()
{
    uart_puts(UART_DEBUG, "VAG Number: \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_vag_number[i]);
    }
    uart_puts(UART_DEBUG, "\"\r\n");

    uart_puts(UART_DEBUG, "Component:  \"");
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_1[i]);
    }
    for (uint8_t i=0; i<12; i++) {
        uart_put(UART_DEBUG, kwp_component_2[i]);
    }
    uart_puts(UART_DEBUG, "\"\r\n");
}

/*
 * Read the module's identification, including its VAG part number
 * and component info.  Populate the globals and print them.
 */
kwp_result_t kwp_read_identification()
{
    kwp_result_t result = _send_read_ident_block();
    if (result != KWP_SUCCESS) { return result; }

    result = _receive_all_ident_blocks();
    if (result != KWP_SUCCESS) { return result; }

    _print_identification();
    return KWP_SUCCESS;
}


int _send_read_mem_block(uint8_t title, uint16_t address, uint8_t length)
{
    uart_puts(UART_DEBUG, "PERFORM READ xx MEMORY\r\n");
    uint8_t block[] = {
        0x06,           // block length
        0,              // placeholder for block counter
        title,          // block title
        length,         // number of bytes to read
        HIGH(address),  // address high
        LOW(address),   // address low
        0,              // placeholder for block end
    };
    return kwp_send_block(block);
}


static kwp_result_t _read_mem(uint8_t req_title, uint8_t resp_title,
                              uint16_t start_address, uint16_t total_size, uint8_t chunk_size)
{
    uint16_t address = start_address;
    uint16_t remaining = total_size;

    while (remaining != 0) {
        if (remaining < chunk_size) { chunk_size = remaining; }

        kwp_result_t result = _send_read_mem_block(req_title, address, chunk_size);
        if (result != KWP_SUCCESS) { return result; }

        result = kwp_receive_block_expect(resp_title);
        if (result != KWP_SUCCESS) { return result; }

        uint8_t datalen = kwp_rx_buf[0] - 3;  // block length - (counter + title + end)
        if (datalen < chunk_size) { return KWP_DATA_TOO_SHORT; }
        if (datalen > chunk_size) { return KWP_DATA_TOO_LONG; }

        uart_puts(UART_DEBUG, "MEM: ");
        uart_puthex16(UART_DEBUG, address);
        uart_puts(UART_DEBUG, ": ");
        for (uint8_t i=0; i<datalen; i++) {
            uart_puthex(UART_DEBUG, kwp_rx_buf[3 + i]);
            uart_put(UART_DEBUG, ' ');
        }
        uart_puts(UART_DEBUG, "\r\n");

        address += chunk_size;
        remaining -= chunk_size;

        result = kwp_acknowledge();
        if (result != KWP_SUCCESS) { return result; }
    }
    return KWP_SUCCESS;
}

kwp_result_t kwp_read_ram(uint16_t start_address, uint16_t total_size, uint8_t chunk_size)
{
    return _read_mem(KWP_READ_RAM, KWP_R_READ_RAM,
                     start_address, total_size, chunk_size);
}

kwp_result_t kwp_read_rom_or_eeprom(uint16_t start_address, uint16_t total_size, uint8_t chunk_size)
{
    return _read_mem(KWP_READ_ROM_EEPROM, KWP_R_READ_ROM_EEPROM,
                     start_address, total_size, chunk_size);
}

kwp_result_t kwp_read_eeprom(uint16_t start_address, uint16_t total_size, uint8_t chunk_size)
{
    return _read_mem(KWP_READ_EEPROM, KWP_R_READ_ROM_EEPROM,
                     start_address, total_size, chunk_size);
}

// VW Premium 4 only ========================================================

static kwp_result_t _send_f0_block()
{
    uart_puts(UART_DEBUG, "PERFORM TITLE F0\r\n");
    uint8_t block[] = {
        0x04,           // block length
        0,              // placeholder for block counter
        KWP_SAFE_CODE,  // block title
        0,              // 0=read
        0,              // placeholder for block end
    };
    return kwp_send_block(block);
}

kwp_result_t kwp_p4_read_safe_code_bcd(uint16_t *safe_code)
{
    kwp_result_t result = _send_f0_block();
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_SAFE_CODE);
    if (result != KWP_SUCCESS) { return result; }

    *safe_code = WORD(kwp_rx_buf[3], kwp_rx_buf[4]);
    return KWP_SUCCESS;
}

// VW Premium 5 mfg mode (address 0x7c) only ================================

static kwp_result_t _delco_login_mfg()
{
    kwp_result_t result = kwp_send_login_block(0x4f43, 0x4c, 0x4544);  // "OCLED"
    if (result != KWP_SUCCESS) { return result; }
    kwp_panic_if_error(result);
    result = kwp_receive_block_expect(KWP_ACK);
    return result;
}

static kwp_result_t _delco_read_safe_code_bcd(uint16_t eeprom_address, uint16_t *safe_code)
{
    kwp_result_t result = _send_read_mem_block(KWP_READ_ROM_EEPROM, eeprom_address, 0x02);
    if (result != KWP_SUCCESS) { return result; }

    kwp_receive_block_expect(KWP_R_READ_ROM_EEPROM);
    if (result != KWP_SUCCESS) { return result; }

    *safe_code = WORD(kwp_rx_buf[3], kwp_rx_buf[4]);
    return KWP_SUCCESS;
}

kwp_result_t kwp_p5_login_mfg()
{
    return _delco_login_mfg();
}

kwp_result_t kwp_p5_read_safe_code_bcd(uint16_t *safe_code)
{
    uint16_t eeprom_address = 0x0014;
    return _delco_read_safe_code_bcd(eeprom_address, safe_code);
}

static kwp_result_t _send_calc_rom_checksum_block()
{
    uart_puts(UART_DEBUG, "PERFORM ROM CHECKSUM\r\n");
    uint8_t block[] = {
        0x05,       // block length
        0,          // placeholder for block counter
        KWP_CUSTOM, // block title
        0x31,       // unknown constant
        0x32,       // subtitle (rom checksum)
        0,          // placeholder for block end
    };
    return kwp_send_block(block);
}

kwp_result_t kwp_p5_calc_rom_checksum(uint16_t *rom_checksum)
{
    kwp_result_t result = _send_calc_rom_checksum_block();
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_CUSTOM);
    if (result != KWP_SUCCESS) { return result; }

    *rom_checksum = WORD(kwp_rx_buf[5], kwp_rx_buf[6]);
    return KWP_SUCCESS;
}

// Seat Liceo mfg mode (address 0x7c) only ==================================

kwp_result_t kwp_sl_login_mfg()
{
    return _delco_login_mfg();
}

kwp_result_t kwp_sl_read_safe_code_bcd(uint16_t *safe_code)
{
    uint16_t eeprom_address = 0x0028;
    return _delco_read_safe_code_bcd(eeprom_address, safe_code);
}

// ==========================================================================

// Switch to 5 baud, send address byte, then switch back to previous settings
// This is blocking so it will hang for about 2 seconds
void kwp_send_address(uint8_t address)
{
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
            PORTD |= _BV(PD3);  // high
        } else {
            PORTD &= ~_BV(PD3); // low
        }
        _delay_ms(200);         // 1000ms / 5bps = 200ms per bit
    }
}

// TODO restore support for a fixed baud rate (no autobaud)
kwp_result_t kwp_connect(uint8_t address, uint32_t baud)
{
    uart_puts(UART_DEBUG, "\r\nCONNECT ");
    uart_puthex(UART_DEBUG, address);
    uart_puts(UART_DEBUG, "\n");

    uart_init(UART_KLINE, baud);

    // Initialize connection state
    kwp_baud_rate = baud;
    kwp_is_first_block = true;
    memset(kwp_vag_number,  0, sizeof(kwp_vag_number));
    memset(kwp_component_1, 0, sizeof(kwp_component_1));
    memset(kwp_component_2, 0, sizeof(kwp_component_2));

    // Send address at 5 baud to wake up the module
    uart_disable(UART_KLINE);
    kwp_send_address(address);

    // Receive sync byte and detect its baud rate
    uint32_t actual_baud_rate = 0;
    uint32_t normal_baud_rate = 0;
    kwp_result_t result = autobaud_sync(&actual_baud_rate, &normal_baud_rate);
    if (result != KWP_SUCCESS) { return result; }

    // Re-enable UART at detected baud rate
    uart_init(UART_KLINE, normal_baud_rate);

    // Print the baud rate info
    char msg[60];
    sprintf(msg, "BAUD: %d (DETECTED %d)\r\n",
      (int)normal_baud_rate, (int)actual_baud_rate);
    uart_puts(UART_DEBUG, msg);

    // Receive two-byte keyword that identifies the module's protocol
    uart_puts(UART_DEBUG, "KWRECV: ");
    uint16_t keyword;
    result = _recv_keyword(&keyword);
    if (result != KWP_SUCCESS) { return result; }
    if (keyword != KWP_1281) { return KWP_BAD_KEYWORD; }

    // Send response to keyword
    uart_puts(UART_DEBUG, "\r\nKWSEND: ");
    _delay_ms(KWP_POSTKEYWORD_MS);
    result = _send_byte((keyword & 0xff) ^ 0xff);
    if (result != KWP_SUCCESS) { return result; }

    // Receive all identification blocks until we control the connection
    uart_puts(UART_DEBUG, "\r\n");
    result = _receive_all_ident_blocks();
    if (result != KWP_SUCCESS) { return result; }

    // Print the identification info
    _print_identification();
    return KWP_SUCCESS;
}

kwp_result_t kwp_autoconnect(uint8_t address)
{
    const uint16_t baud_rates[2] = { 9600, 10400 };

    for (uint8_t try=0; try<2; try++) {
        for (uint8_t baud_index=0; baud_index<2; baud_index++) {
            kwp_result_t result = kwp_connect(address, baud_rates[baud_index]);
            if (result == KWP_SUCCESS) { return result; }
            if (result == KWP_BAD_KEYWORD) { return result; }

            const char *msg = kwp_describe_result(result);
            uart_puts(UART_DEBUG, (char *)msg);
            _delay_ms(KWP_AUTOCONNECT_MS); // delay before next try
        }
    }
    return KWP_TIMEOUT;
}

kwp_result_t kwp_disconnect()
{
    _delay_ms(KWP_DISCONNECT_MS);
    return KWP_SUCCESS;
}
