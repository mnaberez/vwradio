#ifndef KWP1281_H
#define KWP1281_H

#include <stdbool.h>
#include <stdint.h>

// Result codes for functions
typedef enum
{
    KWP_SUCCESS = 0,
    KWP_TIMEOUT = 1,
    KWP_SYNC_BAD_BAUD = 2,
    KWP_SYNC_NOT_0X55 = 3,
    KWP_BAD_KEYWORD = 4,
    KWP_BAD_ECHO = 5,
    KWP_BAD_COMPLEMENT = 6,
    KWP_BAD_BLK_LENGTH = 7,
    KWP_BAD_BLK_END = 8,
    KWP_RX_OVERFLOW = 9,
    KWP_UNEXPECTED = 10,
    KWP_DATA_TOO_SHORT = 11,
    KWP_DATA_TOO_LONG = 12,
} kwp_result_t;

kwp_result_t kwp_connect(uint8_t address, uint32_t baud);
kwp_result_t kwp_autoconnect(uint8_t address);
void kwp_send_address(uint8_t address);
kwp_result_t kwp_send_group_reading_block(uint8_t group);
kwp_result_t kwp_send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop);
kwp_result_t kwp_send_block(uint8_t *buf);
kwp_result_t kwp_receive_block();
kwp_result_t kwp_receive_block_expect(uint8_t title);
kwp_result_t kwp_read_ram(uint16_t start_address, uint16_t total_size, uint8_t chunk_size);
kwp_result_t kwp_read_rom_or_eeprom(uint16_t start_address, uint16_t total_size, uint8_t chunk_size);
kwp_result_t kwp_read_eeprom(uint16_t start_address, uint16_t total_size, uint8_t chunk_size);
kwp_result_t kwp_login_safe(uint16_t safe_code);
kwp_result_t kwp_read_identification();
kwp_result_t kwp_read_group(uint8_t group);
kwp_result_t kwp_read_faults();
kwp_result_t kwp_clear_faults();
kwp_result_t kwp_p4_read_safe_code_bcd(uint16_t *safe_code);
kwp_result_t kwp_p5_login_mfg();
kwp_result_t kwp_p5_read_safe_code_bcd(uint16_t *safe_code);
kwp_result_t kwp_p5_calc_rom_checksum(uint16_t *rom_checksum);
kwp_result_t kwp_sl_login_mfg();
kwp_result_t kwp_sl_read_safe_code_bcd(uint16_t *safe_code);
kwp_result_t kwp_acknowledge();
kwp_result_t kwp_disconnect();
void kwp_print_module_info();
const char * kwp_describe_result(kwp_result_t result);
void kwp_panic_if_error(kwp_result_t result);

bool kwp_is_first_block;        // flag: true until first block is received
uint8_t kwp_block_counter;      // block counter; valid after first rx block
uint8_t kwp_rx_buf[256];        // all bytes received for the current block
uint8_t kwp_rx_size;            // number of bytes used in kwp_rx_buf
uint32_t kwp_baud_rate;         // baud rate of current connection

uint8_t kwp_vag_number[16];     // "1J0035180D  "
uint8_t kwp_component_1[16];    // " RADIO 3CP  "
uint8_t kwp_component_2[16];    // "        0001"

// Protocol Keywords
#define KWP_1281        0x018a  // KWP1281 protocol

// Module Addresses
#define KWP_ENGINE      0x01
#define KWP_RADIO       0x56
#define KWP_RADIO_MFG   0x7C    // Delco Premium 5, TechniSat Gamma 5

// Delays (all in milliseconds)
#define KWP_INTERBYTE_MS    1     /* Delay to wait between individual bytes in a block */
#define KWP_INTERBLOCK_MS   10    /* Delay to wait between blocks */
#define KWP_SYNC_TIMEOUT_MS 1000  /* Timeout if no initial sync byte from module for this long */
#define KWP_RECV_TIMEOUT_MS 3000  /* Timeout if no byte received from module for this long */
#define KWP_ECHO_TIMEOUT_MS 100   /* Timeout if our byte echo is not received for this long */
#define KWP_POSTKEYWORD_MS  30    /* Delay to wait after initial 55 01 8A before sending 75 */
#define KWP_DISCONNECT_MS   5000  /* Do nothing for this long to disconnect */
#define KWP_AUTOCONNECT_MS  2000  /* Between auto-connect tries */

// Block Titles
//                                                                          Premium 4   5
#define KWP_READ_IDENT          0x00  /* Read Identification                        X   X       */
#define KWP_READ_RAM            0x01  /* Read RAM                                   X   X       */
#define KWP_READ_ROM_EEPROM     0x03  /* Read ROM or EEPROM                         *1  *1      */
#define KWP_OUTPUT_TESTS        0x04  /* Actuator/Output Tests                      X   X       */
#define KWP_CLEAR_FAULTS        0x05  /* Clear Faults                               X   X       */
#define KWP_END_SESSION         0x06  /* End Session                                X   X       */
#define KWP_READ_FAULTS         0x07  /* Read Faults                                X   X       */
#define KWP_SINGLE_READING      0x08  /* Single Reading                                         */
#define KWP_ACK                 0x09  /* Request or Response to Acknowledge         X   X       */
#define KWP_NAK                 0x0A  /* Request or Response to No Acknowledge      X   X       */
#define KWP_WRITE_EEPROM        0x0C  /* Write EEPROM                                   X       */
#define KWP_RECODING            0x10  /* Recoding                                   X   X       */
#define KWP_READ_EEPROM         0x19  /* Read EEPROM                                X           */
#define KWP_CUSTOM              0x1B  /* Request or Response to Custom                  *2      */
#define KWP_ADAPTATION          0x21  /* Adaptation                                             */
#define KWP_BASIC_SETTING       0x28  /* Basic Setting                                          */
#define KWP_GROUP_READING       0x29  /* Group Reading                              X   X       */
#define KWP_LOGIN               0x2B  /* Login                                      X   X       */
#define KWP_R_GROUP_READING     0xE7  /* Response to Group Reading                  X   X       */
#define KWP_SAFE_CODE           0xF0  /* Request or Response to R/W SAFE Code       X           */
#define KWP_R_OUTPUT_TEST       0xF5  /* Response to Actuator/Output Tests          X   X       */
#define KWP_R_ASCII_DATA        0xF6  /* Response with ASCII Data/ID code           X   X       */
#define KWP_R_WRITE_EEPROM      0xF9  /* Response to Write EEPROM                       X       */
#define KWP_R_FAULTS            0xFC  /* Response to Read or Clear Faults           X   X       */
#define KWP_R_READ_ROM_EEPROM   0xFD  /* Response to Read ROM or EEPROM             X   X       */
#define KWP_R_READ_RAM          0xFE  /* Response to Read RAM                       X   X       */

// *1 On Premium 4, block title 0x03 reads ROM (MB89677AR)
//    On Premium 5, block title 0x03 reads EEPROM (24C04)
//
// *2 Premium 5 only, and only when connected to address 0x7c

#endif
