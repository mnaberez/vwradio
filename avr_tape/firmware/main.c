/*
 * Pin  1: PB0 CLOCK in/out: connect to radio's CLOCK and to PB7
 * Pin  2: PB1 SWITCH out to radio, needs 3.3K pull-down to GND
 * Pin  3: PB2 /ENABLE in from radio, needs 3.3K pull-up to 5V
 * Pin  4: PB3 /SS out: connect to PB4
 * Pin  5: PB4 /SS in:  connect to PB3 (/SS out)
 * Pin  6: PB5 MOSI in: connect to radio's DAT
 * Pin  7: PB6 MISO (unused)
 * pin  8: PB7 SCK in: connect to PB0 (CLOCK in/out)
 * pin  9: /RESET to GND through pushbutton, 10K pullup to Vcc
 *                also connect to Atmel-ICE AVR port pin 6 nSRST
 * pin 10: Vcc (connect to unswitched 5V)
 * Pin 11: GND (connect to radio's GND)
 * Pin 12: XTAL2 (to 20 MHz crystal with 18pF cap to GND)
 * Pin 13: XTAL1 (to 20 MHz crystal and 18pF cap to GND)
 * Pin 14: PD0/RXD0 (to PC's serial TXD)
 * Pin 15: PD1/TXD0 (to PC's serial RXD)
 * Pin 16: PD2/RXD1 (unused)
 * Pin 17: PD3/TXD1 (unused)
 * Pin 18: PD4 to GND through pushbutton, 10K pullup to Vcc
 * Pin 19: PD5 Green LED anode through 180 ohm resistor
 * Pin 20: PD6 Red LED anode through 180 ohm resistor
 * Pin 21: PD7 (unused)
 * Pin 22: PC0 I2C SDA (unused)
 * Pin 23: PC1 I2C SCL (unused)
 * Pin 24: PC2 JTAG TCK (to Atmel-ICE AVR port pin 1 TCK)
 * Pin 25: PC3 JTAG TMS (to Atmel-ICE AVR port pin 5 TMS)
 * Pin 26: PC4 JTAG TDO (to Atmel-ICE AVR port pin 3 TDO)
 * Pin 27: PC5 JTAG TDI (to Atmel-ICE AVR port pin 9 TDI)
 * Pin 28: PC6 TOSC1 (unused)
 * Pin 29: PC7 TOSC2 (unused)
 * Pin 30: AVCC connect directly to Vcc (also to Atmel-ICE AVR port pin 4 VTG)
 * Pin 31: GND (also to Atmel-ICE AVR port pins 2 GND and 10 GND)
 * Pin 32: AREF connect to GND through 0.1 uF cap
 * Pin 33: PA7 (unused)
 * Pin 34: PA6 (unused)
 * Pin 35: PA5 (unused)
 * Pin 36: PA4 (unused)
 * Pin 37: PA3 (unused)
 * Pin 38: PA2 (unused)
 * Pin 39: PA1 (unused)
 * Pin 40: PA0 (unused)
 *
 * Tie FE/ME out permanently low (means non-metal tape)
 * Tie MONITOR out permanently high (means no error condition)
 */

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
