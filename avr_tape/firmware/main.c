#include "main.h"
#include "uart.h"
#include "leds.h"

#include <stdint.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>

/*************************************************************************
 * Main
 *************************************************************************/

volatile uint8_t clock_in_use = 0;
volatile uint8_t state = STATE_IDLE_TAPE_OUT;

/* Blink red forever if an unhandled interrupt occurs.
 * This code should never been called.
 */
ISR(BADISR_vect)
{
    while(1)
    {
        led_set(LED_RED, 1);
        _delay_ms(200);
        led_set(LED_RED, 0);
        _delay_ms(200);
    }
}

// Pin Change Interrupt: Fires for any change of /ENABLE
ISR(PCINT1_vect)
{
    // /ENABLE low->high (unselect)
    if (PINB & _BV(PB2)) {
        PORTB |= _BV(PB3); // /SS out = high
        clock_in_use = 0;
    }
    // /ENABLE high->low (select)
    else
    {
        DDRB &= ~_BV(PB0); // CLOCK as input
        PORTB &= ~_BV(PB3); // /SS out = low
        clock_in_use = 1;
    }
}

ISR(SPI_STC_vect)
{
    uint8_t c = SPDR;
    uart_put('0');
    uart_put('x');
    uart_puthex_byte(c);
    uart_put('\n');
    if ((c == 0xac) || (c == 0xa8))
    {
        uart_puts((uint8_t*)"-> PLAY\n");
        state = STATE_STARTING_PLAY;
    }
    else if ((c == 0) && (state == STATE_PLAYING))
    {
        uart_puts((uint8_t*)"-> STOP\n");
        state = STATE_IDLE_TAPE_IN;
    }
}

int main()
{
    uart_init();
    led_init();

    sei();

    DDRB &= ~_BV(PB0);  // CLOCK as input
    DDRB &= ~_BV(PB7);  // SCK as input

    // /ENABLE as input
    DDRB &= ~_BV(PB2);
    PORTB |= _BV(PB2);  // activate internal pull-up

    DDRB |= _BV(PB3);  // /SS out as output
    PORTB |= _BV(PB3); // /SS out initially high

    // Set pin change enable mask 1 for PB2 (PCINT10) only
    PCMSK1 = _BV(PCINT10);
    // Enable interrupts from pin change group 1 only
    PCICR = _BV(PCIE1);

    // PB4 as input (AVR hardware SPI /SS input)
    DDRB &= ~_BV(PB4);
    // PB5 as input (AVR hardware SPI MOSI)
    DDRB &= ~_BV(PB5);

    // SPI data output register (MISO) initially 0
    SPDR = 0;

    // SPE=1 SPI enabled, MSTR=0 SPI slave,
    // DORD=0 MSB first, CPOL=1, CPHA=1
    // SPIE=1 SPI interrupts enabled
    SPCR = _BV(SPE) | _BV(CPOL) | _BV(CPHA) | _BV(SPIE);

    // Pushbutton as input (low=pushed)
    DDRD &= ~_BV(PD4);

    uart_puts((uint8_t*)"RESET!\n\n");
    uart_flush_tx();
    led_set(LED_RED, 1);
    led_set(LED_GREEN, 0);

    DDRB |= _BV(PB1);   // SWITCH as output
    PORTB &= ~_BV(PB1);  // set SWITCH initially low (no tape inserted)
    _delay_ms(200);

    loop_until_bit_is_clear(PIND, PD4); // wait for pushbutton to be pressed

    uart_puts((uint8_t*)"Tape Inserted\n\n");
    uart_flush_tx();
    PORTB |= _BV(PB1); // set SWITCH high (tape inserted)
    _delay_ms(200);

    while (1)
    {
        if (state == STATE_IDLE_TAPE_OUT)
        {
            led_set(LED_RED, 1);
            led_set(LED_GREEN, 0);
            PORTB &= ~_BV(PB1);  // set SWITCH low (no tape inserted)
        }

        if (state == STATE_IDLE_TAPE_IN)
        {
            led_set(LED_RED, 0);
            led_set(LED_GREEN, 0);
            PORTB |= _BV(PB1);  // set SWITCH high (tape inserted)
        }

        if (state == STATE_STARTING_PLAY)
        {
            // SWITCH is already high
            _delay_ms(300);
            PORTB &= ~_BV(PB1); // set SWITCH low
            _delay_ms(337);
            PORTB |= _BV(PB1); // set SWITCH high
            _delay_ms(77);
            PORTB &= ~_BV(PB1); // set SWITCH low

            state = STATE_PLAYING;
        }

        if ((state == STATE_PLAYING) && (!clock_in_use))
        {
            led_set(LED_RED, 0);
            led_set(LED_GREEN, 1);

            // CLOCK low for 1ms
            DDRB |= _BV(PB0);
            PORTB &= ~_BV(PB0); // set CLOCK low
            _delay_ms(1);

            // CLOCK high for 25ms
            DDRB &= ~_BV(PB0); // CLOCK as input (external pull-up makes it high)
            _delay_ms(25);
        }
    }

}
