#include "autobaud.h"
#include "kwp1281.h"
#include "uart.h"
#include "printf.h"
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
        case KWP_SYNC_NOT_0X55:     return "Line activity during sync but not 0x55 as expected";
        case KWP_BAD_KEYWORD:       return "Bad keyword received (not KWP1281)";
        case KWP_BAD_ECHO:          return "Bad echo received";
        case KWP_BAD_COMPLEMENT:    return "Bad complement received";
        case KWP_BAD_BLK_LENGTH:    return "Bad block length received";
        case KWP_BAD_BLK_END:       return "Bad block end marker byte received";
        case KWP_RX_OVERFLOW:       return "RX buffer overflow";
        case KWP_TX_BLK_MALFORMED:  return "Malformed block in TX buffer (block length too short)";
        case KWP_UNEXPECTED:        return "Unexpected block title received";
        case KWP_DATA_TOO_SHORT:    return "Length of data returned is shorter than expected";
        case KWP_DATA_TOO_LONG:     return "Length of data returned is longer than expected";
        case KWP_ADDR_BAD_START:    return "Bad start bit received while receiving address";
        case KWP_ADDR_BAD_PARITY:   return "Bad parity bit received while receiving address";
        case KWP_ADDR_BAD_STOP:     return "Bad stop bit received while receiving address";
        case KWP_ADDR_LINE_BUSY:    return "Line activity detected while receiving address";
        default:                    return "???";
    }
}


// If result is success, do nothing.  Otherwise, report the error and halt.
void kwp_panic_if_error(kwp_result_t result)
{
    if (result == KWP_SUCCESS) { return; }

    const char *msg = kwp_describe_result(result);
    uart_flush_tx(UART_DEBUG);
    printf("\r\n\r\n*** KWP PANIC: %s\r\n", msg);
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
    uart_status_t uart_status = uart_blocking_get_with_timeout(UART_KLINE, KWP_ECHO_TIMEOUT_MS, &echo);
    if (uart_status == UART_NOT_READY) { return KWP_TIMEOUT; }
    if (echo != tx_byte) { return KWP_BAD_ECHO; }

    printf("%02X ", tx_byte);
    return KWP_SUCCESS;
}


// Send byte and receive its complement
static kwp_result_t _send_byte_recv_compl(uint8_t tx_byte)
{
    kwp_result_t result = _send_byte(tx_byte);
    if (result != KWP_SUCCESS) { return result; }

    uint8_t complement;
    uart_status_t uart_status = uart_blocking_get_with_timeout(UART_KLINE, KWP_RECV_TIMEOUT_MS, &complement);
    if (uart_status == UART_NOT_READY) { return KWP_TIMEOUT; }
    if (complement != (tx_byte ^ 0xff)) { return KWP_BAD_COMPLEMENT; }

    return KWP_SUCCESS;
}


// Receive byte only
static kwp_result_t _recv_byte(uint8_t *rx_byte_out)
{
    uart_status_t uart_status = uart_blocking_get_with_timeout(UART_KLINE, KWP_RECV_TIMEOUT_MS, rx_byte_out);
    if (uart_status == UART_NOT_READY) { return KWP_TIMEOUT; }

    printf("%02X ", *rx_byte_out);
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
    uart_status_t uart_ready = uart_blocking_get_with_timeout(UART_KLINE, KWP_ECHO_TIMEOUT_MS, &echo);
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
    // minimum block length of 3 = counter + title + end
    if (block_length < 3) { return KWP_TX_BLK_MALFORMED; }

    buf[1] = ++kwp_block_counter;   // insert block counter
    buf[block_length] = 0x03;       // insert block end

    printf("SEND: ");

    // send each byte and receive its complement, except block end
    kwp_result_t result;
    uint8_t i;
    for (i=0; i<block_length; i++) {
        result = _send_byte_recv_compl(buf[i]);
        if (result != KWP_SUCCESS) { return result; }
    }

    // send block end, do not receive complement
    result = _send_byte(buf[i]);
    if (result != KWP_SUCCESS) { return result; }

    printf("\r\n");
    return KWP_SUCCESS;
}


// Receive a block
kwp_result_t kwp_receive_block(void)
{
    printf("RECV: ");

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
                kwp_block_counter = c;  // incremented in kwp_send_block()
                // fall through

                /* We used to track the block counter and halt on error if the
                 * module sent a block counter out of sequence.  That had to be
                 * removed because:
                 *
                 * - The VW Rhapsody radio 1J0035156 made by TechniSat has
                 *   a bug where it does not always send the correct block
                 *   counter.  TechniSat fixed this bug in the VW Rhapsody
                 *   radio 1J0035156A.
                 * 
                 * - The Digifant ECM 037906023AC made by Siemens with EPROM
                 *   markings "FAEB09 001584" has broken block number handling.
                 *   The three identification blocks are always sent with a
                 *   block counter of 0x01, 0x02, and 0x03 respectively.  Any
                 *   other block is always sent with block counter of 0xFF.
                 */

            default:
                bytes_remaining--;
        }
    }

    _delay_ms(KWP_INTERBLOCK_MS);
    printf("\r\n");
    return KWP_SUCCESS;
}


// Receive a block; halt unless it has the expected title
kwp_result_t kwp_receive_block_expect(uint8_t title)
{
    kwp_result_t result = kwp_receive_block();
    if (result != KWP_SUCCESS) { return result; }
    if (kwp_rx_buf[2] == title) { return KWP_SUCCESS; }

    uart_flush_tx(UART_DEBUG);
    printf("\r\n\r\nExpected to receive title 0x%02X, got 0x%02X\r\n",
      title, kwp_rx_buf[2]);

    return KWP_UNEXPECTED;
}


static kwp_result_t _send_ack_block(void)
{
    printf("PERFORM ACK\r\n");
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
kwp_result_t kwp_acknowledge(void)
{
  kwp_result_t result = _send_ack_block();
  if (result != KWP_SUCCESS) { return result; }

  return kwp_receive_block_expect(KWP_ACK);
}

/*
 * For the unknown byte, see:
 *   delco/vw_premium_5/disasm/software23.asm         near 0x508a, 0x2ac6
 *   clarion/vw_premium_4/disasm/pu1666a_mainmcu.asm  near 0xba7a, 0xbaef
 *   technisat/vw_gamma_5/disasm/gamma5.asm           near 0xa595, 0xa127
 */
kwp_result_t kwp_send_login_block(uint16_t safe_code, uint8_t unknown, uint16_t workshop)
{
    printf("PERFORM LOGIN\r\n");
    uint8_t block[] = {
        0x08,               // block length
        0,                  // placeholder for block counter
        KWP_LOGIN,          // block title
        HIGH(safe_code),    // safe code high byte
        LOW(safe_code),     // safe code low byte
        unknown,            // unknown byte; bit 0 influences coding
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

/* A fault data block is in the receive buffer.  Process it and receive
 * more fault data blocks if available.  This function is used to handle
 * the responses for both reading faults and clearing faults.  
 *
 * It has been observed with several modules that if there are no
 * faults, the module will send a faults response block with one
 * special fault that means "no fault" (code=0xFFFF, elaboration=0x88).
 *
 * Otherwise, it has been observed that the module will send a faults
 * response block with up to 4 faults.  We must reply with ACK.  The
 * module will then send a faults response with up to 4 more faults, or
 * it will reply with ACK to indicate no more faults.  We must ACK each
 * successive faults response until the module finally replies with
 * an ACK block to indicate it has sent all its faults.
 *
 * This function does not assume 4 faults is a magic number and will
 * process as many faults as are returned in each response block.  This
 * function will make as many requests as needed to retrieve all of
 * the faults.
 */
static kwp_result_t _process_fault_block_and_receive_more()
{
    // the caller should have received the first fault block
    // already, which is now in the buffer.
    if (kwp_rx_buf[2] != KWP_R_FAULTS) { return KWP_UNEXPECTED; }

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
              faults_count++;

              printf("FAULT: NUM=%02X CODE=%04X ELABORATION=%02X\r\n",
                     faults_count, fault_code, elaboration_code);
            }

            pos += 3;
        }

        // send an ack block to check for more faults
        // (if the last response returned fewer than 4 faults, we may be
        //  able to stop here, but it seems safer to always do this.)
        kwp_result_t result = _send_ack_block();
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

    printf("Module sent %d faults total.\r\n", faults_count);
    return KWP_SUCCESS;
}

static kwp_result_t _send_read_faults_block(void)
{
    printf("PERFORM READ FAULTS\r\n");
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
kwp_result_t kwp_read_faults(void)
{
    kwp_result_t result = _send_read_faults_block();
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_R_FAULTS);
    if (result != KWP_SUCCESS) { return result; }

    return _process_fault_block_and_receive_more(false);
}

static kwp_result_t _send_clear_faults_block(void)
{
    printf("PERFORM CLEAR FAULTS\r\n");
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
kwp_result_t kwp_clear_faults(void)
{
    kwp_result_t result = _send_clear_faults_block();
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block();
    if (result != KWP_SUCCESS) { return result; }

    /* Special case: NAK response
     *
     * When a clear faults block is sent to the Digifant ECM 037906023AC
     * made by Siemens with EEPROM markings "FAEB09 001584", NAK seems
     * to always be returned first.  Sending the clear faults block once
     * more after the NAK will succeed.  Is this a bug in the ECM?
     */
    if (kwp_rx_buf[2] == KWP_NAK) {
        printf("Received NAK for clear faults; trying once more.\r\n");

        result = _send_clear_faults_block();
        if (result != KWP_SUCCESS) { return result; }

        kwp_result_t result = kwp_receive_block();
        if (result != KWP_SUCCESS) { return result; }
    }

    /* Special case: ACK response
     *
     * When a clear faults block is sent to most modules, they will respond
     * with a fault data block.  The Digifant ECM mentioned above instead
     * responds with ACK.  To make clearing the faults on that module work
     * like the others, we detect the ACK and send a read faults block
     * in order to receive a fault data block.
     */
    if (kwp_rx_buf[2] == KWP_ACK) { 
        printf("Received ACK for clear faults; trying read faults.\r\n");

        result = _send_read_faults_block();
        if (result != KWP_SUCCESS) { return result; }

        result = kwp_receive_block_expect(KWP_R_FAULTS);
        if (result != KWP_SUCCESS) { return result; }
    }

    // However we got here (special cases hit or not), we should
    // have a fault data block in the receive buffer now.
    if (kwp_rx_buf[2] != KWP_R_FAULTS) { 
        return KWP_UNEXPECTED; 
    }

    result = _process_fault_block_and_receive_more();
    if (result != KWP_SUCCESS) { return result; }

    printf("Clear faults finished.\r\n");
    return KWP_SUCCESS;
}


kwp_result_t kwp_send_group_reading_block(uint8_t group)
{
    printf("PERFORM GROUP READ\r\n");
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
 */
kwp_result_t kwp_read_group(uint8_t group)
{
    kwp_result_t result = kwp_send_group_reading_block(group);
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block();
    if (result != KWP_SUCCESS) { return result; }

    /*
     * Handle ACK response
     */

    // in some rare cases, a module may return an ACK title instead
    // of the usual 0xE7 title.  this happens when the group number
    // is valid but there are no measurements to return.  this can be
    // observed on both the vw premium 4 radio (clarion) and on the
    // audi chorus radio (blaupunkt) by reading the secret group 0x19.
    uint8_t block_title = kwp_rx_buf[2];
    if (block_title == KWP_ACK) { return KWP_SUCCESS; }

    // some modules like 043906022E don't return the group reading in
    // an 0xE7 block.  when such modules receive a 0x29 group reading
    // request, they first send a 0x02 block with header data that
    // describes the data that will follow.  each successive 0x29
    // group reading is then answered with an 0xF4 data block.
    if (block_title == KWP_R_GROUP_READ_HEADER) {
        result = kwp_send_group_reading_block(group);
        if (result != KWP_SUCCESS) { return result; }

        result = kwp_receive_block();
        if (result != KWP_SUCCESS) { return result; }

        block_title = kwp_rx_buf[2];
        if (block_title != KWP_R_GROUP_READ_DATA) { return KWP_UNEXPECTED; }
    }

    if (block_title == KWP_R_GROUP_READ_DATA) { return KWP_SUCCESS; }

    /*
     * Handle 0xE7 measurements or string response
     */
    if (block_title != KWP_R_GROUP_READING) { return KWP_UNEXPECTED; }

    /*
     * 0xE7 measurements response:
     *   0F xx E7 01 C8 16 05 0F 7C 14 64 7E 04 4B 6D 03
     *   LL CC TT A0 A1 A2 B0 B1 B2 C0 C1 C2 D0 D1 D2 EE
     *
     *   LL    = Block length
     *   CC    = Block counter
     *   TT    = Block title (0xE7 = response to group reading)
     *   A0    = Measurement 1 Formula (0x01 = RPM)
     *   A1,A2 = Measurement 1 Value
     *   B0    = Measurement 2 Formula (0x05 = deg C)
     *   B1,B2 = Measurement 2 Value
     *   C0    = Measurement 3 Formula (0x14 = %)
     *   C1,B2 = Measurement 3 Value
     *   D0    = Measurement 4 Formula (0x04 = ATDC/BTDC)
     *   D1,D2 = Measurement 4 Value
     *   EE    = Block end
     *
     * 0xE7 string response:
     *   2C xx E7 3F .. .. .. 03
     *   LL CC TT A0 SS SS SS EE
     *
     *   LL = Block length
     *   CC = Block counter
     *   TT = Block title (0xE7 = response to group reading)
     *   A0 = Measurement 1 Formula (0x3F = String)
     *   SS = String data (0 or more bytes; variable)
     *   EE = Block end
     */

    uint8_t datalen = kwp_rx_buf[0] - 3;  // block length - (counter + title + end)

    // all 0xE7 responses must have at least one byte after the block title
    // (the first formula byte)
    if (datalen < 1) { return KWP_DATA_TOO_SHORT; }

    /*
     * Handle 0xE7 string response
     *
     * VAG-1552 program card "US/CDN/2.0 1.03.1995" receives a string response
     * successfully but does not display it.  It always shows a blank line
     * on the LCD where the string should be shown.
     *
     * VAG-1552 program cards "GB/5.A 1999-04-01" and "GB/6.0 2000-06-01"
     * receive a string of 1-40 bytes and display it on the LCD.
     */

    // if the first formula byte is 0x3F, this is the special string
    // response.  the rest of the bytes are the string.  this has only
    // been seen on the vw gamma 5 (technisat) radio groups 0x50 & 0x51.
    // the string length was 40 bytes for both groups.  the length of
    // 40 bytes corresponds directly to the 40 characters on the second
    // line of the vag 1552's 40x2 character lcd.  we don't assume 40 is
    // a magic number so we accept 0 or more bytes for the string.
    if (kwp_rx_buf[3] == 0x3F) {
        printf("STRING: \"%.*s\"\r\n", datalen, &kwp_rx_buf[4]);
        return KWP_SUCCESS;
    }

    /*
     * Handle 0xE7 measurements response
     */

    // module may send up to 4 measurements (4 * 3 bytes = 12)
    // groups with fewer than 4 measurements are common
    if (datalen > 12) { return KWP_DATA_TOO_LONG; }

    // must receive 3 bytes for each measurement
    if (datalen % 3 != 0) { return KWP_DATA_TOO_SHORT; }

    // print each measurement
    uint8_t cell = 1; // measuring block cell 1 of 4
    uint8_t pos = 3;  // rx buffer position: first byte after block title
    while (pos <= datalen) {
        uint8_t formula = kwp_rx_buf[pos+0];
        uint16_t value = WORD(kwp_rx_buf[pos+1], kwp_rx_buf[pos+2]);

        printf("MEAS: GROUP=%02X CELL=%02X FORMULA=%02X VALUE=%04X\r\n",
                group, cell, formula, value);

        pos += 3;
        cell++;
    }

    return KWP_SUCCESS;
}


static kwp_result_t _send_read_ident_block(void)
{
    printf("PERFORM READ IDENTIFICATION\r\n");
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
 *  - 1/4: VAG Number               "1J0035180B  "  (Block length=0x0F)
 *  - 2/4: Component Info Part 1    " Radio DE2  "  (Block length=0x0F)
 *  - 3/4: Component Info Part 2    "       0001"   (Block length=0x0E)
 *  - 4/4: Coding and Workshop Code                 (Block length=0x08)
 *
 * In some rare cases, like the Premium 5 radio in manufacturing mode (address
 * 0x7C), there will be no ASCII/data blocks sent during the initial connection.
 */
static kwp_result_t _receive_all_ident_blocks(void)
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
static void _print_identification(void)
{
    // print vag number
    // the first byte of the vag number is special.  if it has bit 7
    // set, it means that more identifying information can be requested
    // by sending block title 0x00.  mask bit 7 to get the ascii char.
    printf("VAG Number: \"%c%.12s\"\r\n", kwp_vag_number[0] & 0b01111111, &kwp_vag_number[1]);

    // print component info
    printf("Component:  \"%.12s%.12s\"\r\n", kwp_component_1, kwp_component_2);
}

/*
 * Read the module's identification, including its VAG part number
 * and component info.  Populate the globals and print them.
 */
kwp_result_t kwp_read_identification(void)
{
    kwp_result_t result = _send_read_ident_block();
    if (result != KWP_SUCCESS) { return result; }

    result = _receive_all_ident_blocks();
    if (result != KWP_SUCCESS) { return result; }

    _print_identification();
    return KWP_SUCCESS;
}


static kwp_result_t _send_read_mem_block(uint8_t title, uint16_t address, uint8_t length)
{
    printf("PERFORM READ xx MEMORY\r\n");
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

        printf("MEM: %04X: ", address);
        for (uint8_t i=0; i<datalen; i++) {
            printf("%02X ", kwp_rx_buf[3 + i]);
        }
        printf("\r\n");

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

static kwp_result_t _send_f0_block(void)
{
    printf("PERFORM TITLE F0\r\n");
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

static kwp_result_t _delco_login_mfg(void)
{
    kwp_result_t result = kwp_send_login_block(0x4f43, 0x4c, 0x4544);  // "OCLED"
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_ACK);
    return result;
}

static kwp_result_t _delco_read_eeprom_word_be(uint16_t eeprom_address, uint16_t *word)
{
    kwp_result_t result = _send_read_mem_block(KWP_READ_ROM_EEPROM, eeprom_address, 0x02);
    if (result != KWP_SUCCESS) { return result; }

    result = kwp_receive_block_expect(KWP_R_READ_ROM_EEPROM);
    if (result != KWP_SUCCESS) { return result; }

    *word = WORD(kwp_rx_buf[3], kwp_rx_buf[4]); // big-endian
    return KWP_SUCCESS;
}

kwp_result_t kwp_p5_login_mfg(void)
{
    return _delco_login_mfg();
}

kwp_result_t kwp_p5_read_safe_code_bcd(uint16_t *safe_code)
{
    uint16_t eeprom_address = 0x0014;
    return _delco_read_eeprom_word_be(eeprom_address, safe_code);
}

kwp_result_t kwp_p5_read_cluster_id(uint16_t *cluster_id)
{
    uint16_t eeprom_address = 0x0065;
    return _delco_read_eeprom_word_be(eeprom_address, cluster_id);
}

static kwp_result_t _send_calc_rom_checksum_block(void)
{
    printf("PERFORM ROM CHECKSUM\r\n");
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

// Dump the firmware (0x0000-0xEFFF) with workarounds
// for the bug in the read memory command
kwp_result_t kwp_p5_dump_firmware()
{
    // read 0x0000 - 0xEFEF in chunks of 32 bytes
    kwp_result_t result = kwp_read_ram(0, 0xeff0, 32);
    if (result != KWP_SUCCESS) { return result; }

    // due to a bug in the read memory command, the bytes near the
    // end do not read correctly unless we read them individually

    // read 0xEFF0 - 0xEFFE in chunks of 1 byte
    result = kwp_read_ram(0xeff0, 15, 1);
    if (result != KWP_SUCCESS) { return result; }

    // also due to the bug, the last byte (0xEFFF) can't be read
    // at all.  however, the last two bytes (0xEFFE-0xEFFF) are
    // the checksum.  to get the missing byte, we ask the firmware
    // to calculate its checksum.  as long as the firmware is good,
    // the calculated checksum will match the bytes in 0xEFFE-0xEFFF.

    // calculate checksum to determine byte at 0xEFFF
    uint16_t rom_checksum = 0;
    result = kwp_p5_calc_rom_checksum(&rom_checksum);
    if (result != KWP_SUCCESS) { return result; }

    printf("ROM Checksum: %04X\r\n", rom_checksum);

    uint8_t assumed_byte_at_efff = HIGH(rom_checksum);
    printf("MEM: EFFF: %02X\r\n", assumed_byte_at_efff);

    return KWP_SUCCESS;
}

// Seat Liceo or VW Konzern 2004 DAC or MP3 mfg mode (address 0x7c) only ====

kwp_result_t kwp_sl_login_mfg(void)
{
    return _delco_login_mfg();
}

kwp_result_t kwp_sl_read_safe_code_bcd(uint16_t *safe_code)
{
    uint16_t eeprom_address = 0x0028;
    return _delco_read_eeprom_word_be(eeprom_address, safe_code);
}

kwp_result_t kwp_sl_read_cluster_id(uint16_t *cluster_id)
{
    uint16_t eeprom_address = 0x0097;
    return _delco_read_eeprom_word_be(eeprom_address, cluster_id);
}

// VW SAM 2002 mfg mode (address 0x7c) only =================================

kwp_result_t kwp_sam_2002_login_mfg(void)
{
    return _delco_login_mfg();
}

kwp_result_t kwp_sam_2002_read_safe_code_bcd(uint16_t *safe_code)
{
    uint16_t eeprom_address = 0x002C;
    return _delco_read_eeprom_word_be(eeprom_address, safe_code);
}

// ==========================================================================

// Read the state of the K-line
// Assumes pin is configured for reading
static uint8_t _read_k() {
    return (uint8_t)(PIND & _BV(PD2)) == _BV(PD2);
}

// Set the state of the K-line
// Assumes pin is configured for writing
static void _write_k(uint8_t state) {
    if (state) {
        PORTD |= _BV(PD3);  // high
    } else {
        PORTD &= ~_BV(PD3); // low
    }
}

// Send address byte at 5 baud
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

        _write_k(bit);
        _delay_ms(200);         // 1000ms / 5bps = 200ms per bit
    }
}

// Receive address byte at 5 baud
// This is blocking so it will hang for at least 2 seconds
// If no address is received, it will block forever
kwp_result_t kwp_recv_address(uint8_t *address)
{
    *address = 0;

    // Wait 500ms to ensure K-line is not in use
    for (uint16_t i=0; i<500; i++) {
        uint8_t bit = _read_k();
        if (bit == 0) { return KWP_ADDR_LINE_BUSY; }
        _delay_ms(1);
    }

    // Wait for falling edge start of start bit
    while (_read_k() == 1);

    // Falling edge of start bit has been detected.  Now wait half
    // of one bit period, so that we are in the middle of the start bit.
    _delay_ms(200 / 2);
    uint8_t start = _read_k();
    if (start != 0) { return KWP_ADDR_BAD_START; }

    uint8_t data = 0;
    uint8_t expected_parity = 1;

    // Receive the 7 data bits
    for (uint8_t i=0; i<7; i++) {
        // Wait one full bit period.  Since we started in the middle of the
        // start bit, one full bit period puts us in the middle of a bit.
        _delay_ms(200);

        uint8_t bit = _read_k();
        data = (data >> 1);
        if (bit) { data |= 0x80; }
        expected_parity ^= bit;
    }

    // One more rotation because no 8th data bit is sent
    data = data >> 1;

    // Receive the parity bit
    _delay_ms(200);
    uint8_t parity = _read_k();
    if (parity != expected_parity) { return KWP_ADDR_BAD_PARITY; }

    // Receive the stop bit
    _delay_ms(200);
    uint8_t stop = _read_k();
    if (stop != 1) { return KWP_ADDR_BAD_STOP; }

    *address = data;
    return KWP_SUCCESS;
}


// TODO restore support for a fixed baud rate (no autobaud)
kwp_result_t kwp_connect(uint8_t address)
{
    // Initialize connection state
    memset(kwp_vag_number,  0, sizeof(kwp_vag_number));
    memset(kwp_component_1, 0, sizeof(kwp_component_1));
    memset(kwp_component_2, 0, sizeof(kwp_component_2));

    // Send address at 5 baud to wake up the module
    printf("\r\nCONNECT %02x\r\n", address);
    uart_disable(UART_KLINE);
    kwp_send_address(address);

    // Receive sync byte and detect its baud rate
    uint32_t actual_baud_rate;
    uint32_t normal_baud_rate;
    kwp_result_t result = autobaud_sync(&actual_baud_rate, &normal_baud_rate);
    if (result != KWP_SUCCESS) { return result; }

    // Re-enable UART at detected baud rate
    uart_init(UART_KLINE, normal_baud_rate);
    kwp_baud_rate = normal_baud_rate;

    // Print the baud rate info
    printf("BAUD: %d (DETECTED %d)\r\n", (int)normal_baud_rate, (int)actual_baud_rate);

    // Receive two-byte keyword that identifies the module's protocol
    printf("KWRECV: ");
    uint16_t keyword = 0;
    result = _recv_keyword(&keyword);
    if (result != KWP_SUCCESS) { return result; }
    if (keyword != KWP_1281) { return KWP_BAD_KEYWORD; }

    // Send response to keyword
    printf("\r\nKWSEND: ");
    _delay_ms(KWP_POSTKEYWORD_MS);
    result = _send_byte((keyword & 0xff) ^ 0xff);
    if (result != KWP_SUCCESS) { return result; }

    // Receive all identification blocks until we control the connection
    printf("\r\n");
    result = _receive_all_ident_blocks();
    if (result != KWP_SUCCESS) { return result; }

    // Print the identification info
    _print_identification();
    return KWP_SUCCESS;
}

kwp_result_t kwp_retrying_connect(uint8_t address)
{
    for (uint8_t try=0; try<2; try++) {
        kwp_result_t result = kwp_connect(address);
        if (result == KWP_SUCCESS) { return result; }
        if (result == KWP_BAD_KEYWORD) { return result; }

        const char *msg = kwp_describe_result(result);
        printf((char *)msg);
        _delay_ms(KWP_CONNECT_RETRY_MS);
    }
    return KWP_TIMEOUT;
}

static kwp_result_t _send_disconnect_block(void)
{
    printf("PERFORM DISCONNECT\r\n");
    uint8_t block[] = {
        0x03,             // block length
        0,                // placeholder for block counter
        KWP_DISCONNECT,   // block title
        0,                // placeholder for block end
    };
    return kwp_send_block(block);
}

kwp_result_t kwp_disconnect(void)
{
    _send_disconnect_block();

    // the module is expected to disconnect immediately.  it does not send
    // a response block.
    uart_disable(UART_KLINE);

    // we need to wait some time to allow the module to get back to a state
    // where it can respond to the 5 baud init again.  this time varies by
    // module.  vw rhapsody (technisat) is not reliable below 2000ms.
    _delay_ms(KWP_DISCONNECT_MS);

    return KWP_SUCCESS;
}
