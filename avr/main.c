/* Pin  1: PB0 POW out (drive low to push POWER button, else high-z)
 * Pin  2: PB1 (not connected for now)
 * Pin  3: PB2 STB in from radio
 * Pin  4: PB3 /SS out (software generated from STB, connect to PB4)
 * Pin  5: PB4 /SS in (connect to PB3)
 * Pin  6: PB5 MOSI in (to radio's DAT)
 * Pin  7: PB6 MISO out (connect to PB5 through 10K resistor)
 * pin  8: PB7 SCK in from radio
 * Pin 11: GND (connect to radio's GND)
 * Pin 14: PD0/RXD (to PC's serial TXD)
 * Pin 15: PD1/TXD (to PC's serial RXD)
 * Pin 16: PD2/RXD1 MISO in (from faceplate's DAT)
 * Pin 17: PD3/TXD1 MOSI out (to faceplate's DAT through 10K resistor)
 * Pin 18: PD4/XCK1 SCK out (to faceplate's CLK)
 * Pin 19: PD5: Green LED
 * Pin 20: PD6: Red LED
 * Pin 21: PD7: STB out to faceplate
 * Pin 39: PA1: LOF out to faceplate
 * Pin 40: PA0: RST out to faceplate
 */

#include "main.h"

#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "cmd.h"
#include "faceplate.h"
#include "leds.h"
#include "radio.h"
#include "uart.h"
#include "updemu.h"

/*************************************************************************
 * Main
 *************************************************************************/

// copy emulated upd display to real faceplate
void copy_emulated_upd_to_faceplate()
{
    if (emulated_upd_state.display_data_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x40, // data setting command: display data ram
            sizeof(emulated_upd_state.display_data_ram),
            emulated_upd_state.display_data_ram
        );
        emulated_upd_state.display_data_ram_dirty = 0;
    }

    if (emulated_upd_state.pictograph_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x41, // data setting command: pictograph ram
            sizeof(emulated_upd_state.pictograph_ram),
            emulated_upd_state.pictograph_ram
            );
        emulated_upd_state.pictograph_ram_dirty = 0;
    }

    if (emulated_upd_state.chargen_ram_dirty == 1)
    {
        faceplate_write_upd_ram(
            0x4a, // data setting command: chargen ram
            sizeof(emulated_upd_state.chargen_ram),
            emulated_upd_state.chargen_ram
            );
        emulated_upd_state.chargen_ram_dirty = 0;
    }
}

int main()
{
    run_mode = RUN_MODE_NORMAL;

    led_init();
    uart_init();
    cmd_init();
    radio_spi_init();
    faceplate_spi_init();
    upd_init(&emulated_upd_state);
    sei();

    // clear faceplate
    faceplate_clear_display();

    while (1)
    {
        // service bytes from uart
        if (buf_has_byte(&uart_rx_buffer))
        {
            uint8_t c;
            c = buf_read_byte(&uart_rx_buffer);
            cmd_receive_byte(c);
        }

        // service commands from radio
        if (upd_rx_buf.read_index != upd_rx_buf.write_index)
        {
            upd_command_t cmd;
            cmd = upd_rx_buf.cmds[upd_rx_buf.read_index];
            upd_rx_buf.read_index++;

            if (run_mode != RUN_MODE_TEST)
            {
                upd_process_command(&emulated_upd_state, &cmd);
                copy_emulated_upd_to_faceplate();
            }
        }

    }
}
