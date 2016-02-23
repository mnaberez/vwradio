#ifndef UPDEMU_H
#define UPDEMU_H

// Selected RAM area
#define UPD_RAM_DISPLAY_DATA 0
#define UPD_RAM_PICTOGRAPH 1
#define UPD_RAM_CHARGEN 2
#define UPD_RAM_NONE 0xFF
// Address increment mode
#define UPD_INCREMENT_OFF 0
#define UPD_INCREMENT_ON 1
// RAM sizes
#define UPD_DISPLAY_DATA_RAM_SIZE 0x19
#define UPD_PICTOGRAPH_RAM_SIZE 0x08
#define UPD_CHARGEN_RAM_SIZE 0x70

// upd16432b command request
typedef struct
{
    uint8_t data[32];
    uint8_t size;
} upd_command_t;

typedef struct
{
    uint8_t ram_area;  // Selected RAM area
    uint8_t ram_size;  // Size of selected RAM area
    uint8_t address;   // Current address in that area
    uint8_t increment; // Address increment mode on/off

    uint8_t display_data_ram[UPD_DISPLAY_DATA_RAM_SIZE];
    uint8_t display_data_ram_dirty; // 0=no changes, 1=changed

    uint8_t pictograph_ram[UPD_PICTOGRAPH_RAM_SIZE];
    uint8_t pictograph_ram_dirty; // 0=no changes, 1=changed

    uint8_t chargen_ram[UPD_CHARGEN_RAM_SIZE];
    uint8_t chargen_ram_dirty; // 0=no changes, 1=changed
} upd_state_t;

void upd_init(upd_state_t *state);
void upd_process_command(upd_state_t *state, upd_command_t *cmd);
void upd_clear_dirty_flags(upd_state_t *state);

upd_state_t emulated_upd_state;

#endif
