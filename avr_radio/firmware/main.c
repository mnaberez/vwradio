/*
 * Pin  1: PB0 T0 (unused)
 * Pin  2: PB1 T1 (unused)
 * Pin  3: PB2 STB in from radio
 * Pin  4: PB3 /SS out (software generated from STB, connect to PB4)
 * Pin  5: PB4 /SS in (connect to PB3)
 * Pin  6: PB5 MOSI in (to radio's DAT)
 * Pin  7: PB6 MISO out (connect to PB5 through 10K resistor)
 * pin  8: PB7 SCK in from radio
 * pin  9: /RESET to GND through pushbutton, 10K pullup to Vcc
 *                also connect to Atmel-ICE AVR port pin 6 nSRST
 * pin 10: Vcc (connect to unswitched 5V)
 * Pin 11: GND (connect to radio's GND)
 * Pin 12: XTAL2 (to 20 MHz crystal with 18pF cap to GND)
 * Pin 13: XTAL1 (to 20 MHz crystal and 18pF cap to GND)
 * Pin 14: PD0/RXD0 (to PC's serial TXD)
 * Pin 15: PD1/TXD0 (to PC's serial RXD)
 * Pin 16: PD2/RXD1 MISO in (from faceplate's DAT)
 * Pin 17: PD3/TXD1 MOSI out (connect to PD2 through 10K resistor)
 * Pin 18: PD4/XCK1 SCK out (to faceplate's CLK)
 * Pin 19: PD5 (out to faceplate's STB)
 * Pin 20: PD6 (in from faceplate's /BUS)
 * Pin 21: PD7 (out to radio's /BUS)
 * Pin 22: PC0 I2C SDA (unused)
 * Pin 23: PC1 I2C SCL (unused)
 * Pin 24: PC2 JTAG TCK (to Atmel-ICE AVR port pin 1 TCK)
 * Pin 25: PC3 JTAG TMS (to Atmel-ICE AVR port pin 5 TMS)
 * Pin 26: PC4 JTAG TDO (to Atmel-ICE AVR port pin 3 TDO)
 * Pin 27: PC5 JTAG TDI (to Atmel-ICE AVR port pin 9 TDI)
 * Pin 28: PC6 TOSC1 (to RTC crystal) (unused)
 * Pin 29: PC7 TOSC2 (to RTC crystal) (unused)
 * Pin 30: AVCC connect directly to Vcc (also to Atmel-ICE AVR port pin 4 VTG)
 * Pin 31: GND (also to Atmel-ICE AVR port pins 2 GND and 10 GND)
 * Pin 32: AREF connect to GND through 0.1 uF cap
 * Pin 33: PA7 Red LED anode through 180 ohm resistor
 * Pin 34: PA6 Green LED anode through 180 ohm resistor
 * Pin 35: PA5 (unused)
 * Pin 36: PA4 (unused)
 * Pin 37: PA3 /POWER_EJECT from radio
 * Pin 38: PA2 EJECT from radio
 * Pin 39: PA1 /LOF in (from radio, also tied to faceplate's /LOF in)
 * Pin 40: PA0 (unused)
 */

#include "main.h"

#include <stdint.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#include "cmd.h"
#include "faceplate.h"
#include "leds.h"
#include "radio_spi.h"
#include "radio_state.h"
#include "uart.h"
#include "updemu.h"

/* Blink red forever if an unhandled interrupt occurs.
 * This code should never been called.
 */
ISR(BADISR_vect)
{
    led_fatal(LED_CODE_BADISR);
}

/*************************************************************************
 * Main
 *************************************************************************/

int main()
{
    radio_model = RADIO_MODEL_PREMIUM_4;
    run_mode = RUN_MODE_RUNNING;
    auto_display_passthru = 1;
    auto_key_passthru = 1;

    led_init();
    uart_init();
    cmd_init();
    radio_spi_init();
    upd_init(&emulated_upd_state);
    upd_init(&faceplate_upd_state);
    sei();

    while (1)
    {
        // service bytes from uart
        if (buf_has_byte(&uart_rx_buffer))
        {
            uint8_t c;
            c = buf_read_byte(&uart_rx_buffer);
            cmd_receive_byte(c);
        }

        if (run_mode == RUN_MODE_STOPPED)
        {
            continue;
        }

        // process a command from the radio if one is available
        if (upd_rx_buf.read_index != upd_rx_buf.write_index)
        {
            upd_command_t cmd;
            cmd = upd_rx_buf.cmds[upd_rx_buf.read_index];
            upd_rx_buf.read_index++;

            upd_process_command(&emulated_upd_state, &cmd);
        }

        // handle faceplate turn on or turn off
        faceplate_service_lof();

        if (faceplate_online) {
            // read keys from faceplate, schedule them to be sent to radio
            if (auto_key_passthru)
            {
                faceplate_read_key_data(upd_tx_key_data);
            }

            // update radio state and faceplate as needed
            radio_state_update_from_upd_if_dirty(&radio_state, &emulated_upd_state);
            if (auto_display_passthru)
            {
                faceplate_update_from_upd_if_dirty(&emulated_upd_state);
            }

            // clear dirty state for next time
            emulated_upd_state.dirty_flags = UPD_DIRTY_NONE;
        }
    }

}
