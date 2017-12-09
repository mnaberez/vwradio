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
