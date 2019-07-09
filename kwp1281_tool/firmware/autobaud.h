#ifndef AUTOBAUD_H
#define AUTOBAUD_H

#include "kwp1281.h"

#if F_CPU == 20000000
#define AUTOBAUD_PRESCALER  _BV(CS11)       /* 20 MHz / 8 prescaler = 8 MHz */
#define AUTOBAUD_PERIOD     0.4             /* 0.4 uS is the period of 8 MHz */
#else
#error "Automatic baud rate detection is not supported for this value of F_CPU"
#endif

volatile uint16_t _autobaud_edges;          /* Count of negative edges received */
volatile uint16_t _autobaud_start_count;    /* ICR1 at first negative edge */
volatile uint16_t _autobaud_end_count;      /* ICR1 at second negative edge */

kwp_result_t autobaud_sync(uint32_t *actual_baud_rate, uint32_t *normal_baud_rate);

void autobaud_debug();

#endif
