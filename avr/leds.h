#include "main.h"
#include <stdint.h>
#include <util/delay.h>

#ifndef LEDS_H
#define LEDS_H

#define LED_PORT PORTD
#define LED_DDR DDRD

void led_init();
void led_set(uint8_t lednum, uint8_t state);
void led_blink(uint8_t lednum, uint16_t times);

#endif
