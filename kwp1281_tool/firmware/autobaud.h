#pragma once

#include "kwp1281.h"

#if F_CPU == 20000000                       /* 20 MHz crystal */
#define AUTOBAUD_PRESCALER  _BV(CS11)       /* 20 MHz / 8 prescaler = 2.5 MHz */
#define AUTOBAUD_PERIOD     0.4             /* 0.4 uS is the period of 2.5 MHz */

#elif F_CPU == 18432000                     /* 18.432 MHz crystal */
#define AUTOBAUD_PRESCALER  _BV(CS11)       /* 18.432 MHz / 8 prescaler = 2.304 MHz */
#define AUTOBAUD_PERIOD     0.434           /* 0.434 uS is the period of 2.304 MHz */

#elif F_CPU == 16000000                     /* 16 MHz crystal */
#define AUTOBAUD_PRESCALER  _BV(CS11)       /* 16 MHz / 8 prescaler = 2 MHz */
#define AUTOBAUD_PERIOD     0.5             /* 0.5 uS is the period of 2 MHz */

#else
#error "Automatic baud rate detection is not supported for this value of F_CPU"
#endif

kwp_result_t autobaud_sync(uint32_t *actual_baud_rate, uint32_t *normal_baud_rate);
void autobaud_debug(void);
