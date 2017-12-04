#ifndef KWP1281_H
#define KWP1281_H

#include <stdint.h>
#include "main.h"

void send_address(uint8_t address);
void send_byte(uint8_t c);
void send_byte_recv_compl(uint8_t c);
uint8_t recv_byte();
uint8_t recv_byte_send_compl();
void wait_for_55_01_8a();
void connect();
void read_all_ram();
void send_read_ram_block(uint16_t address, uint8_t length);
void send_read_eeprom_block(uint16_t address, uint8_t length);
void send_group_reading_block(uint8_t group);
void send_login_block(uint16_t safe_code, uint8_t fern, uint16_t workshop);
void send_f0_block();
void send_ack_block();
void receive_block();

#endif
