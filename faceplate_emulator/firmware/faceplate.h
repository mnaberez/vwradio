#pragma once

#include <stdint.h>
#include "updemu.h"

void faceplate_spi_init(void);
void faceplate_spi_release(void);
void faceplate_service_lof(void);
uint8_t faceplate_lof_asserted(void);
void faceplate_clear_display(void);
void faceplate_send_upd_command(upd_command_t *cmd);
void faceplate_update_from_upd_if_dirty(upd_state_t *state);
void faceplate_read_key_data(volatile uint8_t *key_data);

volatile uint8_t faceplate_online;
