#ifndef TECHNISAT_H
#define TECHNISAT_H

#include <stdbool.h>
#include <stdint.h>

// Result codes for functions
typedef enum
{
    TSAT_SUCCESS = 0,
    TSAT_TIMEOUT = 1,
    TSAT_BAD_ECHO = 2,
    TSAT_BAD_CHECKSUM = 3,
    TSAT_UNEXPECTED = 4,
} tsat_result_t;

tsat_result_t tsat_connect(uint8_t address, uint32_t baud);
tsat_result_t tsat_disconnect();
tsat_result_t tsat_send_block(uint8_t *buf);
tsat_result_t tsat_disable_eeprom_filter();
tsat_result_t tsat_read_eeprom(uint16_t address, uint8_t size);
tsat_result_t tsat_write_eeprom(uint16_t address, uint8_t size, uint8_t *data);
tsat_result_t tsat_read_safe_code_bcd(uint16_t *safe_code);
tsat_result_t tsat_disconnect();
const char * tsat_describe_result(tsat_result_t result);
void tsat_panic_if_error(tsat_result_t result);

uint8_t tsat_rx_buf[256];        // all bytes received for the current block
uint8_t tsat_rx_size;            // number of bytes used in tsat_rx_buf

#endif
