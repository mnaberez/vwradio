#ifndef AUTOBAUD_H
#define AUTOBAUD_H

#include "kwp1281.h"

#if F_CPU == 20000000
#define AUTOBAUD_PRESCALER  _BV(CS11)       /* 20 MHz / 8 prescaler = 8 MHz */
#define AUTOBAUD_PERIOD     0.4             /* 0.4 uS is the period of 8 MHz */
#else
#error "Automatic baud rate detection is not supported for this value of F_CPU"
#endif

kwp_result_t autobaud_sync(uint32_t *actual_baud_rate, uint32_t *normal_baud_rate);
void autobaud_debug();

#endif
