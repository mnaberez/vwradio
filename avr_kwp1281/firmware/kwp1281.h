#ifndef KWP1281_H
#define KWP1281_H

#include <stdint.h>

void kwp_connect(uint8_t address);
void kwp_send_read_ram_block(uint16_t address, uint8_t length);
void kwp_send_read_eeprom_block(uint16_t address, uint8_t length);
void kwp_send_group_reading_block(uint8_t group);
void kwp_send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop);
void kwp_send_f0_block();
void kwp_send_ack_block();
void kwp_receive_block();
void kwp_read_ram(uint16_t start_address, uint16_t size);

uint8_t kwp_block_counter;
uint8_t kwp_rx_buf[256];
uint8_t kwp_rx_size;

uint8_t kwp_vag_number[16];     // "1J0035180D  "
uint8_t kwp_component_1[16];    // " RADIO 3CP  "
uint8_t kwp_component_2[16];    // "        0001"

#endif
