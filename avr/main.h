#ifndef MAIN_H
#define MAIN_H
#define F_CPU 20000000UL
#define BAUD 115200

#include <stdint.h>

// If true, commands from the radio will be processed by the uPD16432B
// emulator.  If false, commands from the radio will be ignored.  This
// is used to test the emulator code without the radio interfering.
volatile uint8_t pass_radio_commands_to_emulator;

// If true, the emulated uPD16432B display will be mirrored to the real
// uPD16432B on the faceplate.  In other words, what the radio thinks is
// on the faceplate will be on the real faceplate.
// Set this to false to take over the faceplate display.
volatile uint8_t pass_emulator_display_to_faceplate;

// If true, the keys pressed on the real faceplate will be passed back
// to the radio.  If false, the radio will not see when keys are pressed.
// Set this to false to take over the faceplate keys.
volatile uint8_t pass_faceplate_keys_to_radio;

// key data bytes that will be transmitted if the radio sends
// a read key data command
volatile uint8_t upd_tx_key_data[4];

#endif
