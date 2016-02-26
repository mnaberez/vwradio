/* Pin  1: PB0 (not connected)
 * Pin  2: PB1 (not connected)
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
 * Pin 19: PD5 Green LED
 * Pin 20: PD6 Red LED
 * Pin 21: PD7 STB out to faceplate
 * Pin 39: PA1 (not connected)
 * Pin 40: PA0 (not connected)
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
    run_mode = RUN_MODE_NORMAL;

    led_init();
    uart_init();
    cmd_init();
    radio_spi_init();
    faceplate_spi_init();
    upd_init(&emulated_upd_state);
    upd_init(&faceplate_upd_state);
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
                faceplate_update_from_upd_if_dirty(&emulated_upd_state);
                upd_clear_dirty_flags(&emulated_upd_state);
            }
        }

        // read keys from faceplate and send to radio
        faceplate_read_key_data(upd_tx_key_data);
    }
}
