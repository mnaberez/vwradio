#include <avr/io.h>

/* Disable pass-through mode.  This is how this interface
 * is normally used.
 *
 * TXD and RXD on the FT232RL are connected to the first
 * UART on this microcontroller.  The K-line is connected
 * to the second UART via the L9637D.  The host PC can't
 * directly control the K-line, it can only communicate
 * with this microcontroller.
 */
void passthru_disable(void)
{
    DDRD |= _BV(PD7);   // PD7 = output
    PORTD &= ~_BV(PD7); // low = not pass-thru mode
}

/* Enable pass-through mode.  This allows software written
 * for "dumb" cables to work with this interface.
 *
 * TXD and RXD on the FT232RL are connected directly to
 * the K-line via the L9637D.  The first UART on this
 * microcontroller can still receive data from the host PC
 * but transmit goes nowhere.  The second UART can still
 * receive data from the K-line but transmit goes nowhere.
 */
void passthru_enable(void)
{
    DDRD |= _BV(PD7);   // PD7 = output
    PORTD |= _BV(PD7);  // high = pass-thru mode
}
