#ifndef CONVERT_PICTS_H
#define CONVERT_PICTS_H

#include <avr/pgmspace.h>

#define PICT_NONE 0
#define PICT_PERIOD 1
#define PICT_MIX 2
#define PICT_TAPE_METAL 10
#define PICT_TAPE_DOLBY 11
#define PICT_HIDDEN_MODE_AMFM 20  // Premium 4 only
#define PICT_HIDDEN_MODE_CD 21    // Premium 4 only
#define PICT_HIDDEN_MODE_TAPE 22  // Premium 4 only

uint8_t convert_upd_pict_data_to_codes(
    uint8_t *pict_data_in, uint8_t *pict_codes_out);
uint8_t convert_code_to_upd_pict_data(
    uint8_t pict_code, uint8_t *pict_data_out);

#endif
