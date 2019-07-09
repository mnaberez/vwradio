#ifndef AUTOBAUD_H
#define AUTOBAUD_H

#include "kwp1281.h"

#if F_CPU != 20000000
#error "Automatic baud rate detection is not supported for this value of F_CPU"
#endif

kwp_result_t autobaud(uint32_t *actual_baud_rate, uint32_t *normal_baud_rate);

#endif
