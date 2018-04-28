#ifndef CONVERT_PICTOGRAPHS_H
#define CONVERT_PICTOGRAPHS_H

#include <avr/pgmspace.h>

#define PICTOGRAPH_NONE 0
#define PICTOGRAPH_PERIOD 1
#define PICTOGRAPH_MIX 2
#define PICTOGRAPH_TAPE_METAL 10
#define PICTOGRAPH_TAPE_DOLBY 11
#define PICTOGRAPH_HIDDEN_MODE_AMFM 20  // Premium 4 only
#define PICTOGRAPH_HIDDEN_MODE_CD 21    // Premium 4 only
#define PICTOGRAPH_HIDDEN_MODE_TAPE 22  // Premium 4 only

uint8_t convert_upd_pictograph_data_to_codes(
    uint8_t *pictograph_data_in, uint8_t *pictograph_codes_out);
uint8_t convert_code_to_upd_pictograph_data(
    uint8_t pictograph_code, uint8_t *pictograph_data_out);

#endif
