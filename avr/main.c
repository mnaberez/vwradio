/* Pine 3: PB2 STB from radio in
 * Pin  4: PB3 /SS out (software generated, connect to PB4)
 * Pin  5: PB4 /SS in (connect to PB3)
 * Pin  6: PB5 MOSI (to radio's DAT)
 * Pin  7: PB6 MISO (not connected for now)
 * pin  8: PB7 SCK (to radio's CLK)
 * Pin 11: GND
 * Pin 14: PD0/RXD (to PC's serial TXD)
 * Pin 15: PD1/TXD (to PC's serial RXD)
 * Pin 18: PD4: Green LED
 * Pin 19: PD5: Red LED
 */

#ifndef F_CPU
#define F_CPU 20000000UL
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>
#include <util/delay.h>
#define BAUD 115200
#include <util/setbaud.h>

#define LED_PORT PORTD
#define LED_DDR DDRD
#define LED_RED PD6
#define LED_GREEN PD5

/*************************************************************************
 * LED
 *************************************************************************/

void led_init()
{
    LED_DDR = _BV(LED_GREEN) | _BV(LED_RED);
    LED_PORT = 0;
}

void led_set(uint8_t lednum, uint8_t state)
{
    if (state)
    {
        LED_PORT |= _BV(lednum);
    }
    else
    {
        LED_PORT &= ~_BV(lednum);
    }
}

void led_blink(uint8_t lednum, uint16_t times)
{
    while (times > 0)
    {
        led_set(lednum, 1);
        _delay_ms(250);
        led_set(lednum, 0);
        _delay_ms(250);
        times -= 1;
    }
}

/*************************************************************************
 * Ring Buffers for UART
 *************************************************************************/

typedef struct
{
    uint8_t data[129];
    uint8_t write_index;
    uint8_t read_index;
} ringbuffer_t;

void buf_init(volatile ringbuffer_t *buf)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        buf->read_index = 0;
        buf->write_index = 0;
    }
}

void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        buf->data[buf->write_index++] = c;
        if (buf->write_index == 129) { buf->write_index = 0; }
    }
}

uint8_t buf_read_byte(volatile ringbuffer_t *buf)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        uint8_t c = buf->data[buf->read_index++];
        if (buf->read_index == 129) { buf->read_index = 0; }
        return c;
    }
}

uint8_t buf_has_byte(volatile ringbuffer_t *buf)
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        return buf->read_index != buf->write_index;
    }
}

/*************************************************************************
 * UART
 *************************************************************************/

volatile ringbuffer_t uart_rx_buffer;
volatile ringbuffer_t uart_tx_buffer;

void uart_init(void)
{
    // Baud Rate
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
#if USE_2X
    UCSR0A |= _BV(U2X0);
#else
    UCSR0A &= ~(_BV(U2X0));
#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); // N-8-1
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   // Enable RX and TX
    // Enable the USART Recieve Complete
    UCSR0B |= _BV(RXCIE0);

    buf_init(&uart_rx_buffer);
    buf_init(&uart_tx_buffer);
}

void uart_flush_tx()
{
    while (buf_has_byte(&uart_tx_buffer)) {}
}

void uart_putc(uint8_t c)
{
    buf_write_byte(&uart_tx_buffer, c);
    // Enable UDRE interrupts
    UCSR0B |= _BV(UDRIE0);
}

void uart_puts(uint8_t *str)
{
    while (*str != '\0')
    {
        uart_putc(*str);
        str++;
    }
}

void uart_puthex_nib(uint8_t c)
{
    if (c < 10) // 0-9
    {
        uart_putc(c + 0x30);
    }
    else // A-F
    {
        uart_putc(c + 0x37);
    }
}

void uart_puthex_byte(uint8_t c)
{
    uart_puthex_nib((c & 0xf0) >> 4);
    uart_puthex_nib(c & 0x0f);
}

void uart_puthex_16(uint16_t w)
{
    uart_puthex_byte((w & 0xff00) >> 8);
    uart_puthex_byte((w & 0x00ff));
}

// USART Receive Complete
ISR(USART0_RX_vect)
{
    uint8_t c;
    c = UDR0;
    buf_write_byte(&uart_rx_buffer, c);
}

// USART Data Register Empty (USART is ready to transmit a byte)
ISR(USART0_UDRE_vect)
{
    if (buf_has_byte(&uart_tx_buffer))
    {
        uint8_t c;
        c = buf_read_byte(&uart_tx_buffer);
        UDR0 = c;
    }
    else
    {
        // Disable UDRE interrupts
        UCSR0B &= ~_BV(UDRE0);
    }
}

/*************************************************************************
 * SPI Slave interface to Radio
 *************************************************************************/

#define START_OF_SPI_PACKET 0x100
#define END_OF_SPI_PACKET   0x101

volatile uint16_t spi_slave_data[2048]; // values > 0xFF used as markers
volatile uint16_t spi_slave_data_index;

void spi_slave_init(void)
{
    spi_slave_data_index = 0;

    // PB2 as input (STB from radio)
    DDRB &= ~_BV(PB2);
    // PB3 as output (/SS output we'll make in software from STB)
    DDRB |= _BV(PB3);
    // PB3 state initially high (/SS not asserted)
    PORTB |= _BV(PB3);
    // Set pin change enable mask 1 for PB2 (PCINT10) only
    PCMSK1 = _BV(PCINT10);
    // Any transition generates the pin change interrupt
    EICRA = _BV(ISC11);
    // Enable interrupts from pin change group 1 only
    PCICR = _BV(PCIE1);

    // PB4 as input (AVR hardware SPI /SS input)
    DDRB &= ~_BV(PB4);
    // PB5 as input (AVR hardware SPI MOSI)
    DDRB &= ~_BV(PB5);

    // SPI data output register initially 0
    SPDR = 0;

    // SPE=1 SPI enabled, MSTR=0 SPI slave,
    // DORD=0 MSB first, CPOL=1, CPHA=1
    // SPIE=1 SPI interrupts enabled
    SPCR = _BV(SPE) | _BV(CPOL) | _BV(CPHA) | _BV(SPIE);
}

// When STB from radio changes, set /SS output to inverse of STB.
ISR(PCINT1_vect)
{
    if (PINB & _BV(PB2)) // STB=high
    {
        spi_slave_data[spi_slave_data_index++] = START_OF_SPI_PACKET;
        PORTB &= ~_BV(PB3); // /SS=low
    }
    else
    {
        spi_slave_data[spi_slave_data_index++] = END_OF_SPI_PACKET;
        PORTB |= _BV(PB3); // /SS=high
    }
}

// SPI Serial Transfer Complete
ISR(SPI_STC_vect)
{
    spi_slave_data[spi_slave_data_index++] = SPDR;

    if (spi_slave_data_index == 2048)
    {
        SPCR = 0; // stop all spi
        PCICR = 0; // stop pin change interrupts
    }
}

/*************************************************************************
 * Command Interpreter
 *************************************************************************/

uint8_t cmd_buf[256];
uint8_t cmd_buf_index;
uint8_t cmd_expected_length;

#define ACK 0x06
#define NAK 0x15

#define CMD_SET_LED 0x01
#define CMD_ECHO 0x02
#define CMD_ARG_GREEN_LED 0x00
#define CMD_ARG_RED_LED 0x01

void cmd_init()
{
    cmd_buf_index = 0;
    cmd_expected_length = 0;
}

/* Start or restart the command timeout timer.
 * Call this after each byte of the command is received.
 */
void cmd_timer_start()
{
    // set timer1 CTC mode (CS11=0, CS10=1 = prescaler 1024)
    TCCR1B = (1 << CS12) | (0 << CS11) | (1 << CS10);

    // set compare value (2 seconds at 18.432MHz with prescaler 1024)
    OCR1A = 39062;

    // set initial count
    TCNT1 = 0;

    // enable timer1 compare interrupt
    TIMSK1 = (1 << OCIE1A);
}

/* Stop the command timeout timer.
 * Call this after the last byte of a command has been received.
 */
void cmd_timer_stop()
{
    // stop timer1
    TCCR1B = 0;
    // disable timer1 compare interrupt
    TIMSK1 = 0;
}

/* Command timeout has occurred while receiving command bytes.  We forget the
 * buffer and don't send any reply.  This allows the client to resynchronize
 * by waiting longer than the timeout.
 */
ISR(TIMER1_COMPA_vect)
{
    cmd_timer_stop();
    cmd_init();
}

void cmd_reply_ack(void)
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(ACK);  // ACK byte
    uart_flush_tx();
}

void cmd_reply_nak(void)
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(NAK);  // NAK byte
    uart_flush_tx();
}

/* Command: Echo
 * Arguments: <arg1> <arg2> <arg3> ...
 * Returns: <ack> <arg1> <arg1> <arg3> ...
 *
 * Echoes the arguments received back to the client.  If no args were
 * received after the command byte, an empty ACK response is returned.
 */
void cmd_do_echo(void)
{
    uart_putc(cmd_buf_index); // number of bytes to follow
    uart_putc(ACK); // ACK byte
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++) {
        uart_putc(cmd_buf[i]);
        uart_flush_tx();
    }
}

/* Command: Set LED
 * Arguments: <led number> <led state>
 * Returns: <ack|nak>
 *
 * Turns one of the LEDs on or off.  Returns a NAK if the LED
 * number is not recognized.
 */
void cmd_do_set_led(void)
{
    if (cmd_buf_index != 3)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t led_num = cmd_buf[1];
    uint8_t led_state = cmd_buf[2];

    if (led_num == CMD_ARG_RED_LED)
    {
        led_set(LED_RED, led_state);
    }
    else if (led_num == CMD_ARG_GREEN_LED)
    {
        led_set(LED_GREEN, led_state);
    }
    else
    {
        cmd_reply_nak();
        return;
    }

    cmd_reply_ack();
}

/* Dispatch a command.  A complete command packet has been received.  The
 * command buffer has one more bytes.  The first byte is the command byte.
 * Dispatch to a handler, or return a NAK if the command is unrecognized.
 */
void cmd_dispatch(void)
{
    switch (cmd_buf[0])
    {
        case CMD_SET_LED:
            cmd_do_set_led();
            break;
        case CMD_ECHO:
            cmd_do_echo();
            break;
        default:
            cmd_reply_nak();
    }
}

/* Receive a command byte.  Commands are executed immediately after the
 * last byte has been received.
 *
 * Format of a command request:
 *   <number of bytes to follow> <command byte> <arg> <arg> ...
 * Examples:
 *   01 AB         Command AB, no args
 *   03 DE AA 55   Command DE, args: [AA, 55]
 *
 * Format of a command response:
 *   <number of bytes to follow> <ack|nak> <arg> <arg> ...
 * Examples:
 *   01 06         Command acknowledged, no args
 *   02 06 AA      Command acknowledged, args: [AA]
 *   01 15         Command not acknowledged, no args
 *   03 15 AA 55   Command not acknowledged, args: [AA, 55]
 */
void cmd_receive_byte(uint8_t c)
{
    // receive command length byte
    if (cmd_expected_length == 0)
    {
        if (c == 0) // invalid, command length must be 1 byte or longer
        {
            cmd_reply_nak();
            cmd_init();
        }
        else
        {
            cmd_expected_length = c;
            cmd_timer_start();
        }
    }
    // receive command byte(s)
    else
    {
        cmd_buf[cmd_buf_index++] = c;
        cmd_timer_start();

        if (cmd_buf_index == cmd_expected_length)
        {
            cmd_timer_stop();
            cmd_dispatch();
            cmd_init();
        }
    }
}

/*************************************************************************
 * Main
 *************************************************************************/

void capture_and_dump_spi(void)
{
    // capture 2048 bytes of spi data
    if (spi_slave_data_index == 2048) {
        // dump captured spi data to uart
        uint16_t i;
        for (i=0; i<spi_slave_data_index; i++)
        {
            if (spi_slave_data[i] == START_OF_SPI_PACKET)
            {
                uart_puts("<start>");
            }
            else if (spi_slave_data[i] == END_OF_SPI_PACKET)
            {
                uart_puts("<end>\n");
            }
            else
            {
                uart_puthex_byte(spi_slave_data[i]);
                uart_putc(' ');
            }
            uart_flush_tx();
        }
        uart_puts("\n\n");

        // start capturing again
        spi_slave_init();
    }
}

void receive_and_run_command(void)
{
    uint8_t c;
    if (buf_has_byte(&uart_rx_buffer))
    {
        c = buf_read_byte(&uart_rx_buffer);
        cmd_receive_byte(c);
    }
}

int main(void)
{
    led_init();
    uart_init();
    cmd_init();
    spi_slave_init();
    sei();

    while(1)
    {
        capture_and_dump_spi();
    }
}
