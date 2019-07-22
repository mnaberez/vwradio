#include "main.h"
#include "autobaud.h"
#include "kwp1281.h"
#include "uart.h"
#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

/*
 * After a module receives its 5 baud address, it transmits a
 * sync byte (0x55) so the tester can synchronize to its baud rate.
 * We use the AVR's Input Capture mode to measure the time between
 * two negative edges, which is time "B" in the diagram below:
 *
 *                         Sync Byte (0x55)
 *
 *   Idle   Start  0   1   2   3   4   5   6   7  Stop     Idle
 *
 *   ------------+   +---+   +---+   +---+   +---+   +---------
 *               |   |   |   |   |   |   |   |   |   |
 *               |   |   |   |   |   |   |   |   |   |
 *               +---+   +---+   +---+   +---+   +---+
 *            0    1   0   1   0   1   0   1   0   1
 *
 *               |<->|
 *                 A = Negative edge to positive edge (1 bit)
 *
 *               |<----->|
 *                 B = Negative edge to negative edge (2 bits)
 *
 *         |<----------- Total (10 bits) ----------->|
 *
 *
 *              A          B            Total
 *  1200 baud   833.33 us  1666.66 us   8333.30 us
 *  2400 baud   416.67 us   833.34 us   4166.70 us
 *  4800 baud   208.33 us   416.66 us   2083.30 us
 *  9600 baud   104.17 us   208.34 us   1041.70 us
 * 10400 baud    96.15 us   192.30 us    961.50 us
 */

static volatile uint8_t _autobaud_edges;           // Count of negative edges received
static volatile uint16_t _autobaud_start_count;    // ICR1 at first negative edge
static volatile uint16_t _autobaud_end_count;      // ICR1 at second negative edge

/*
 * Start input capture.  The time between the first two negative
 * edges is measured, and the total number of edges received is counted.
 */
void _start_input_capture()
{
    _autobaud_edges = 0;
    _autobaud_start_count = 0;
    _autobaud_end_count = 0;

    TCCR1A = 0;                   // disable output compare and waveform generation
    TCCR1B = 0;                   // no noise cancel, capture neg edge, stop timer
    TCNT1 = 0;                    // reset counter
    TIFR1 = _BV(ICF1);            // clear input capture flag (avoids spurious interrupt)
    TIMSK1 |= _BV(ICIE1);         // enable capture interrupt
    TCCR1B |= AUTOBAUD_PRESCALER; // start counting
}

/*
 * Stop input capture
 */
void _stop_input_capture()
{
    TIMSK1 &= ~_BV(ICIE1);  // disable capture interrupt
    TCCR1B = 0;             // no noise cancel, capture neg edge, stop timer
}

/*
 * Normalize a detected baud rate to a supported one.  Baud rates of
 * 1200, 2400, 4800, 9600, and 10400 are supported.  The ranges allow
 * -/+ 4% error.  If normalization fails, 0 is returned.
 */
static uint32_t _normalize_baud_rate(uint32_t baud_rate)
{
    /* thresholds generated with python:
     *
     *   for baud in (1200, 2400, 4800, 9600, 10400):
     *     min = baud - (baud * 0.04)  # -4%
     *     max = baud + (baud * 0.04)  # +4%
     *     print("%d: %d - %d" % (baud, min, max))
     */
    if ((baud_rate >= 1152) && (baud_rate <= 1248)) {
        return 1200;
    } else if ((baud_rate >= 2304) && (baud_rate <= 2496)) {
        return 2400;
    } else if ((baud_rate >= 4608) && (baud_rate <= 4992)) {
        return 4800;
    } else if ((baud_rate >= 9216) && (baud_rate <= 9984)) {
        return 9600;
    } else if ((baud_rate >= 9984) && (baud_rate <= 10816)) {
        return 10400;
    } else {
        return 0;  // error: normalization failed
    };
}

/*
 * Wait until all 5 negative edges of the 0x55 sync byte have been
 * received or timeout.
 */
static void _wait_for_0x55_or_timeout()
{
    uint16_t millis = 0;
    uint8_t submillis = 0;

    // wait for the first negative edge of 0x55
    // after receiving its 5 baud address, the module will not start
    // transmitting for some time.  this will be tens of milliseconds.
    while (_autobaud_edges == 0) {
        _delay_us(50); // 50 us = 0.05 ms
        if (++submillis == 20) {  // 1 ms
            submillis = 0;
            if (++millis == KWP_SYNC_TIMEOUT_MS) { return; }  // timeout
        }
    }

    // first negative edge of 0x55 received
    // now wait for the remaining 4 negative edges within 20ms or timeout
    // 20ms = over 2x the total time of the sync byte at 1200 baud
    for (millis=0; millis<20; millis++) {
        if (_autobaud_edges == 5) { break; }
        _delay_ms(1);
    }

    // wait an additional delay to allow the k-line to return to idle
    // 2ms = over 2x the period of one bit at 1200 baud
    _delay_ms(2);
}

/*
 * Receive the sync byte and measure its baud rate.  Return the
 * actual measured baud rate and the normalized baud rate.
 */
kwp_result_t autobaud_sync(uint32_t *actual_baud_rate, uint32_t *normal_baud_rate)
{
    _start_input_capture();
    _wait_for_0x55_or_timeout();
    _stop_input_capture();

    if (_autobaud_edges == 0) { return KWP_TIMEOUT; }
    if (_autobaud_edges != 5) { return KWP_SYNC_NOT_0X55; }

    // calculate actual baud rate
    uint16_t ticks = _autobaud_end_count - _autobaud_start_count;
    float period = ticks * AUTOBAUD_PERIOD;
    float frequency = (2 * 1000000) / period;   // 2 * because 2 bits per tick
    uint16_t baud_rate = (uint16_t)frequency;

    // normalize baud rate
    *actual_baud_rate = baud_rate;
    *normal_baud_rate = _normalize_baud_rate(baud_rate);
    if (*normal_baud_rate == 0) { return KWP_SYNC_BAD_BAUD; }

    return KWP_SUCCESS;
}

/*
 * Print debug information
 */
void autobaud_debug()
{
    char msg[60];

    sprintf(msg, "\r\nEDGES: %d\r\n", _autobaud_edges);
    uart_puts(UART_DEBUG, msg);

    sprintf(msg, "START: 0x%04x\r\n", _autobaud_start_count);
    uart_puts(UART_DEBUG, msg);

    sprintf(msg, "END:   0x%04x\r\n", _autobaud_end_count);
    uart_puts(UART_DEBUG, msg);

    uint16_t ticks = _autobaud_end_count - _autobaud_start_count;
    sprintf(msg, "TICKS: 0x%04x\r\n\r\n", ticks);
    uart_puts(UART_DEBUG, msg);
}

/*
 * Input Capture interrupt; fires on the negative edges of the
 * sync byte.  We capture the time between the first two negative
 * edges (2 bits) to measure the baud rate.
 */
ISR(TIMER1_CAPT_vect)
{
    if (_autobaud_edges == 0) {
        _autobaud_start_count = ICR1;
    } else if (_autobaud_edges == 1) {
        _autobaud_end_count = ICR1;
    }

    _autobaud_edges++;
}
