#ifndef FACEPLATE_H
#define FACEPLATE_H

#include <stdint.h>
#include "updemu.h"

void faceplate_spi_init();
void faceplate_spi_release();
void faceplate_service_lof();
uint8_t faceplate_lof_asserted();
void faceplate_clear_display();
void faceplate_send_upd_command();
void faceplate_update_from_upd_if_dirty(upd_state_t *state);
void faceplate_read_key_data(volatile uint8_t *key_data);

volatile uint8_t faceplate_online;

#endif
