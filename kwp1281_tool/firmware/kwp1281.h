#ifndef KWP1281_H
#define KWP1281_H

#include <stdint.h>

void kwp_connect(uint8_t address, uint32_t baud);
void kwp_send_read_ram_block(uint16_t address, uint8_t length);
void kwp_send_read_eeprom_block(uint16_t address, uint8_t length);
void kwp_send_group_reading_block(uint8_t group);
void kwp_send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop);
void kwp_send_f0_block();
void kwp_send_ack_block();
void kwp_receive_block();
void kwp_receive_block_expect(uint8_t title);
void kwp_read_ram(uint16_t start_address, uint16_t size);
void kwp_read_eeprom();
uint16_t kwp_read_safe_code_bcd();

uint8_t kwp_is_first_block;     // flag: 0=no blocks received, 1=otherwise
uint8_t kwp_block_counter;      // block counter; valid after first rx block
uint8_t kwp_rx_buf[256];        // all bytes received for the current block
uint8_t kwp_rx_size;            // number of bytes used in kwp_rx_buf

uint8_t kwp_vag_number[16];     // "1J0035180D  "
uint8_t kwp_component_1[16];    // " RADIO 3CP  "
uint8_t kwp_component_2[16];    // "        0001"

// Module Addresses
#define KWP_RADIO 0x56

// Block Titles
//                                                                      Premium 4   5
#define KWP_READ_ID         0x00  /* Read Identification                        X   X       */
#define KWP_READ_RAM        0x01  /* Read RAM                                   X   X       */
#define KWP_READ_ROM        0x03  /* Read ROM                                   X   X       */
#define KWP_OUTPUT_TESTS    0x04  /* Actuator/Output Tests                      X   X       */
#define KWP_CLEAR_FAULTS    0x05  /* Clear Faults                               X   X       */
#define KWP_END_SESSION     0x06  /* End Session                                X   X       */
#define KWP_READ_FAULTS     0x07  /* Read Faults                                X   X       */
#define KWP_SINGLE_READING  0x08  /* Single Reading                                         */
#define KWP_ACK             0x09  /* Acknowledge                                X   X       */
#define KWP_NAK             0x0A  /* No Acknowledge                             X   X       */
#define KWP_WRITE_EEPROM    0x0C  /* Write EEPROM                                   X       */
#define KWP_RECODING        0x10  /* Recoding                                   X   X       */
#define KWP_READ_EEPROM     0x19  /* Read EEPROM                                X           */
#define KWP_ADAPTATION      0x21  /* Adaptation                                             */
#define KWP_BASIC_SETTING   0x28  /* Basic Setting                                          */
#define KWP_GROUP_READING   0x29  /* Group Reading                              X   X       */
#define KWP_LOGIN           0x2B  /* Login                                      X   X       */
#define KWP_R_GROUP_READING 0xE7  /* Response to Group Reading                  X   X       */
#define KWP_SAFE_CODE       0xF0  /* Request or Response to R/W SAFE Code       X           */
#define KWP_R_OUTPUT_TEST   0xF5  /* Response to Actuator/Output Tests          X   X       */
#define KWP_R_ASCII_DATA    0xF6  /* Response with ASCII Data/ID code           X   X       */
#define KWP_R_WRITE_EEPROM  0xF9  /* Response to Write EEPROM                       X       */
#define KWP_R_FAULTS        0xFC  /* Response to Read or Clear Faults           X   X       */
#define KWP_R_READ_EEPROM   0xFD  /* Response to Read ROM or Read EEPROM        X   X       */
#define KWP_R_READ_RAM      0xFE  /* Response to Read RAM                       X   X       */

#endif
