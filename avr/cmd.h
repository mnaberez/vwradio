#ifndef CMD_H
#define CMD_H

#include "updemu.h"

#define ACK 0x06
#define NAK 0x15

#define CMD_SET_LED 0x01
#define CMD_ECHO 0x02
#define CMD_SET_RUN_MODE 0x03

#define CMD_EMULATED_UPD_DUMP_STATE 0x10
#define CMD_EMULATED_UPD_SEND_COMMAND 0x11
#define CMD_EMULATED_UPD_RESET 0x12
#define CMD_RADIO_LOAD_KEY_DATA 0x20
#define CMD_RADIO_PUSH_POWER_BUTTON 0x21
#define CMD_FACEPLATE_UPD_DUMP_STATE 0x30
#define CMD_FACEPLATE_UPD_SEND_COMMAND 0x31
#define CMD_FACEPLATE_CLEAR_DISPLAY 0x32
#define CMD_ARG_GREEN_LED 0x00
#define CMD_ARG_RED_LED 0x01
#define CMD_ARG_RUN_MODE_NORMAL 0x00
#define CMD_ARG_RUN_MODE_TEST 0x01

uint8_t cmd_buf[256];
uint8_t cmd_buf_index;
uint8_t cmd_expected_length;

void cmd_init();
void cmd_receive_byte(uint8_t c);

#endif
