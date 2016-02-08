/*
 * Pin 11: GND
 * Pin 14: PD0/RXD
 * Pin 15: PD1/TXD
 * Pin 18: PD4: Green LED
 * Pin 19: PD5: Red LED
 */

#ifndef F_CPU
#define F_CPU 18432000UL
#endif

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BAUD 57600
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
    buf->read_index = 0;
    buf->write_index = 0;
}

void buf_write_byte(volatile ringbuffer_t *buf, uint8_t c)
{
    buf->data[buf->write_index++] = c;
    if (buf->write_index == 129) { buf->write_index = 0; }
}

uint8_t buf_read_byte(volatile ringbuffer_t *buf)
{
    uint8_t c = buf->data[buf->read_index++];
    if (buf->read_index == 129) { buf->read_index = 0; }
    return c;
}

uint8_t buf_has_byte(volatile ringbuffer_t *buf)
{
    return buf->read_index != buf->write_index;
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
 * Command Interpreter
 *************************************************************************/

uint8_t cmd_buf[128];
uint8_t cmd_buf_index;
uint8_t cmd_expected_length;

#define ACK 0x06
#define NAK 0x15

#define CMD_SET_LED 0x01
#define CMD_ARG_GREEN_LED 0x00
#define CMD_ARG_RED_LED 0x01

void cmd_init()
{
    cmd_buf_index = 0;
    cmd_expected_length = 0;
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

void cmd_do_set_led(void)
{
    // 0        1           2
    // command, led number, led state

    if (cmd_buf_index != 3)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t led_num = cmd_buf[1];

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

void cmd_process_buffer(void)
{
    // 0=command, 1=arg, 2=arg, ...

    if (cmd_buf[0] == CMD_SET_LED)
    {
        cmd_do_set_led();
    }
    else // unrecognized command
    {
        cmd_reply_nak();
    }

    cmd_init();
}

/* Receive a command byte.  Commands are processed immediately after the
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
    // receive command length
    if (cmd_expected_length == 0)
    {
        if (c == 0) // invalid, command length must be 1 byte or longer
        {
            cmd_reply_nak();
        }
        else
        {
            cmd_expected_length = c;
        }
    }
    // receive command byte(s)
    else
    {
        cmd_buf[cmd_buf_index++] = c;

        if (cmd_buf_index == cmd_expected_length)
        {
            cmd_process_buffer();
        }
    }
}

/*************************************************************************
 * Main
 *************************************************************************/

int main(void)
{
    led_init();
    uart_init();
    sei();

    uint8_t c;
    while(1)
    {
        if (buf_has_byte(&uart_rx_buffer))
        {
            c = buf_read_byte(&uart_rx_buffer);
            cmd_receive_byte(c);
        }
    }
}
