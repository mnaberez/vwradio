#ifndef RADIO_SPI_H
#define RADIO_SPI_H

#include <stdint.h>
#include "updemu.h"

// ring buffer for receiving upd16432b commands from radio
typedef struct
{
    volatile upd_command_t cmds[256];
    volatile uint8_t read_index;
    volatile uint8_t write_index;
    volatile upd_command_t *cmd_at_write_index;
} upd_rx_buf_t;
volatile upd_rx_buf_t upd_rx_buf;

void radio_spi_init();

#endif
