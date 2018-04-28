#ifndef LEDS_H
#define LEDS_H

#include <stdint.h>

#define LED_PORT PORTA
#define LED_DDR DDRA
#define LED_RED PA7
#define LED_GREEN PA6

#define LED_CODE_BADISR 3

void led_init();
void led_set(uint8_t lednum, uint8_t state);
void led_blink(uint8_t lednum, uint16_t times);
void led_fatal(uint8_t code);

#endif
