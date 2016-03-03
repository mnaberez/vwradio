#ifndef MAIN_H
#define MAIN_H
#define F_CPU 20000000UL
#define BAUD 115200

#include <stdint.h>

#define RUN_MODE_STOPPED 0
#define RUN_MODE_RUNNING 1

// Run mode allows normally processing to be stopped for testing.
volatile uint8_t run_mode;

// If true, the emulated uPD16432B display will be mirrored to the real
// uPD16432B on the faceplate.  In other words, what the radio thinks is
// on the faceplate will be on the real faceplate.
// Set this to false to take over the faceplate display.
volatile uint8_t pass_emulated_upd_display_to_faceplate;

// If true, the keys pressed on the real faceplate will be passed back
// to the radio.  If false, the radio will not see when keys are pressed.
// Set this to false to take over the faceplate keys.
volatile uint8_t pass_faceplate_keys_to_emulated_upd;

// key data bytes that will be transmitted if the radio sends
// a read key data command
volatile uint8_t upd_tx_key_data[4];

#endif
