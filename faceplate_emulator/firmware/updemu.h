#ifndef UPDEMU_H
#define UPDEMU_H

// Selected RAM area
#define UPD_RAM_NONE 0xFF
#define UPD_RAM_DISPLAY 0
#define UPD_RAM_PICTOGRAPH 1
#define UPD_RAM_CHARGEN 2
#define UPD_RAM_LED 3
// RAM area dirty flags
#define UPD_DIRTY_NONE 0
#define UPD_DIRTY_DISPLAY 1<<UPD_RAM_DISPLAY
#define UPD_DIRTY_PICTOGRAPH 1<<UPD_RAM_PICTOGRAPH
#define UPD_DIRTY_CHARGEN 1<<UPD_RAM_CHARGEN
#define UPD_DIRTY_LED 1<<UPD_RAM_LED
// Address increment mode
#define UPD_INCREMENT_OFF 0
#define UPD_INCREMENT_ON 1
// RAM sizes
#define UPD_DISPLAY_RAM_SIZE 0x19
#define UPD_PICTOGRAPH_RAM_SIZE 0x08
#define UPD_CHARGEN_RAM_SIZE 0x70
#define UPD_LED_RAM_SIZE 0x01

// upd16432b command request
typedef struct
{
    uint8_t data[32];
    uint8_t size;
} upd_command_t;

typedef struct
{
    uint8_t ram_area;    // Selected RAM area
    uint8_t ram_size;    // Size of selected RAM area
    uint8_t address;     // Current address in that area
    uint8_t increment;   // Address increment mode on/off
    uint8_t dirty_flags; // Bitfield of which RAM areas have changed

    uint8_t display_ram[UPD_DISPLAY_RAM_SIZE];
    uint8_t pictograph_ram[UPD_PICTOGRAPH_RAM_SIZE];
    uint8_t chargen_ram[UPD_CHARGEN_RAM_SIZE];
    uint8_t led_ram[UPD_LED_RAM_SIZE];
} upd_state_t;

void upd_init(upd_state_t *state);
void upd_process_command(upd_state_t *state, upd_command_t *cmd);

// State of the emulated uPD16432B
upd_state_t emulated_upd_state;
// State of the real uPD16432B on the faceplate.  The uPD16432B doesn't have a
// way to read its registers so an emulator instance is used to remember them.
upd_state_t faceplate_upd_state;

#endif
