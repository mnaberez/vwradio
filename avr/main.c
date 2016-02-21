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
 * Run Mode
 *************************************************************************/

#define RUN_MODE_NORMAL 0
#define RUN_MODE_TEST 1

volatile uint8_t run_mode;

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
    uint8_t data[256];
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
}

uint8_t buf_read_byte(volatile ringbuffer_t *buf)
{
    uint8_t c = buf->data[buf->read_index++];
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

void uart_init()
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
    if (uart_tx_buffer.read_index != uart_tx_buffer.write_index)
    {
        UDR0 = uart_tx_buffer.data[uart_tx_buffer.read_index++];
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

// upd16432b command request
typedef struct
{
    uint8_t data[32];
    uint8_t size;
} upd_command_t;

// ring buffer for receiving upd16432b commands from radio
typedef struct
{
    volatile upd_command_t cmds[256];
    volatile uint8_t read_index;
    volatile uint8_t write_index;
    volatile upd_command_t *cmd_at_write_index;
} upd_rx_buf_t;
volatile upd_rx_buf_t upd_rx_buf;

// key data bytes that will be transmitted if the radio sends
// a read key data command
volatile uint8_t upd_tx_key_data[4];

void radio_spi_init()
{
    // initialize buffer to receive commands
    upd_rx_buf.read_index = 0;
    upd_rx_buf.write_index = 0;
    upd_rx_buf.cmd_at_write_index = &upd_rx_buf.cmds[upd_rx_buf.write_index];
    upd_rx_buf.cmd_at_write_index->size = 0;

    // initialize key press data to be sent
    uint8_t i;
    for (i=0; i<sizeof(upd_tx_key_data); i++)
    {
        upd_tx_key_data[i] = 0;
    }
    // PB0 as input (POWER button output to radio)
    // Drive PB0 low to push POWER button, otherwise set as high impedance
    DDRB &= ~_BV(PB0);
    PORTB &= ~_BV(PB0);
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
    // PB6 initially as input (AVR hardware SPI MISO)
    // MISO and MOSI are wired together as a single line to the radio (DAT),
    // so we don't set MISO as an output until we need to send data on it.
    DDRB &= ~_BV(PB6);

    // SPI data output register (MISO) initially 0
    SPDR = 0;

    // SPE=1 SPI enabled, MSTR=0 SPI slave,
    // DORD=0 MSB first, CPOL=1, CPHA=1
    // SPIE=1 SPI interrupts enabled
    SPCR = _BV(SPE) | _BV(CPOL) | _BV(CPHA) | _BV(SPIE);
}

// Pin Change Interrupt: Fires for any change of STB
ISR(PCINT1_vect)
{
    if (PINB & _BV(PB2))
    {
        // STB=high: start of transfer
        PORTB &= ~_BV(PB3); // /SS=low

        upd_rx_buf.cmd_at_write_index->size = 0;
    }
    else
    {
        // STB=low: end of transfer
        PORTB |= _BV(PB3); // /SS=high

        // SPI data output register (MISO) = 0 to set up for next transfer
        SPDR = 0;
        // MISO might be configured as an output if we were just sending data,
        // so set it back to an input until the next time we need to send data.
        DDRB &= ~_BV(PB6);

        // copy the current spi command into the circular buffer
        // empty transfers and key data request commands are ignored
        if ((upd_rx_buf.cmd_at_write_index->size !=0) &&
            ((upd_rx_buf.cmd_at_write_index->data[0] & 0x44) != 0x44))
        {
            upd_rx_buf.write_index++;
            upd_rx_buf.cmd_at_write_index =
                &upd_rx_buf.cmds[upd_rx_buf.write_index];
        }
    }
}

// SPI Serial Transfer Complete
ISR(SPI_STC_vect)
{
    // get index for current command data or key request data
    uint8_t index = upd_rx_buf.cmd_at_write_index->size;

    // store data byte from MOSI into current command
    upd_rx_buf.cmd_at_write_index->data[index] = SPDR;

    // if current command is a key data request, load the byte to send on MISO
    if ((index < sizeof(upd_tx_key_data)) &&
        ((upd_rx_buf.cmd_at_write_index->data[0] & 0x44) == 0x44))
    {
        // Load key data byte that will be sent on MISO
        SPDR = upd_tx_key_data[index];
        // Set MISO as an output
        DDRB |= _BV(PB6);
    }
    else
    {
        SPDR = 0;
    }

    // advance data index in current command
    upd_rx_buf.cmd_at_write_index->size = ++index;

    // handle command size overflow
    if (index == sizeof(upd_rx_buf.cmd_at_write_index->data))
    {
        upd_rx_buf.cmd_at_write_index->size = 0;
    }
}

// Push the radio's POWER button momentarily.
// This should turn the radio either on or off.
void radio_push_power_button()
{
    // configure POW line as output, drive it low
    DDRB |= _BV(PB0);
    PORTB &= ~_BV(PB0);
    // wait for radio to see POWER button
    _delay_ms(100);
    // return POW line to high-z input
    DDRB &= ~_BV(PB0);
}

/*************************************************************************
 * SPI Master Interface to Faceplate
 *************************************************************************/

void faceplate_spi_init()
{
    // PA0: RST out to faceplate
    DDRA |= _BV(PA0);
    PORTA |= _BV(PA0);
    // PA1: LOF out to faceplate
    DDRA |= _BV(PA1);
    PORTA |= _BV(PA1);

    // PD2/RXD1 MISO as input (from faceplate's DAT)
    DDRD &= ~_BV(PD2);
    // PD3/TXD1 MOSI as output (to faceplate's DAT through 10K resistor?)
    DDRD |= _BV(PD3);
    // PD4/XCK1 SCK as output (to faceplate's CLK)
    DDRD |= _BV(PD4);
    // PD7 as output (to faceplate's STB)
    DDRD |= _BV(PD7);
    // PD7 initially low (faceplate STB = not selected)
    PORTD &= ~_BV(PD7);

    // must be done first
    UBRR1 = 0;
    // preset transmit complete flag
    UCSR1A = _BV(TXC1);
    // Master SPI mode, CPOL=1 (bit 1), CPHA=1 (bit 0)
    UCSR1C = _BV(UMSEL10) | _BV(UMSEL11) | 2 | 1;
    // transmit enable and receive enable
    UCSR1B = _BV(TXEN1) | _BV(RXEN1);
    // must be done last
    // spi clock (9 = 1mhz for 20mhz clock)
    UBRR1 = 9;
}

uint8_t faceplate_spi_xfer_byte(uint8_t c)
{
    // wait for transmitter ready
    while ((UCSR1A & _BV(UDRE1)) == 0);

    // send byte
    UDR1 = c;

    // wait for receiver ready
    while ((UCSR1A & _BV (RXC1)) == 0);

    // receive byte, return it
    return UDR1;
}

void faceplate_spi_send_cmd(uint8_t size, uint8_t *data)
{
    // STB=high (start of transfer)
    PORTD |= _BV(PD7);

    // Send each byte
    uint8_t i;
    for (i=0; i<size; i++)
    {
        faceplate_spi_xfer_byte(data[i]);
    }

    // STB=low (end of transfer)
    PORTD &= ~_BV(PD7);
}

void faceplate_spi_clear()
{
    // Display Setting command
    uint8_t data1[] = {0x04};
    faceplate_spi_send_cmd(1, data1);
    // Status command
    uint8_t data2[] = {0xcf};
    faceplate_spi_send_cmd(1, data2);

    // Data Setting command: write to pictograph ram
    uint8_t data3[] = {0x41};
    faceplate_spi_send_cmd(1, data3);
    // Address Setting command, pictograph data
    uint8_t data4[] = {0x80, 0, 0, 0, 0, 0, 0, 0, 0,};
    faceplate_spi_send_cmd(9, data4);

    // Data Setting command: write to display data ram
    uint8_t data5[] = {0x40};
    faceplate_spi_send_cmd(1, data5);
    // Address Setting command, display data
    uint8_t data6[] = {0x80, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
                             0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,};
    faceplate_spi_send_cmd(17, data6);
}

/*************************************************************************
 * NEC uPD16432B LCD Controller Emulator
 *************************************************************************/

// Selected RAM area
#define UPD_RAM_DISPLAY_DATA 0
#define UPD_RAM_PICTOGRAPH 1
#define UPD_RAM_CHARGEN 2
#define UPD_RAM_NONE 0xFF
// Address increment mode
#define UPD_INCREMENT_OFF 0
#define UPD_INCREMENT_ON 1
// RAM sizes
#define UPD_DISPLAY_DATA_RAM_SIZE 0x19
#define UPD_PICTOGRAPH_RAM_SIZE 0x08
#define UPD_CHARGEN_RAM_SIZE 0x70

typedef struct
{
    uint8_t ram_area;  // Selected RAM area
    uint8_t ram_size;  // Size of selected RAM area
    uint8_t address;   // Current address in that area
    uint8_t increment; // Address increment mode on/off

    uint8_t display_data_ram[UPD_DISPLAY_DATA_RAM_SIZE];
    uint8_t pictograph_ram[UPD_PICTOGRAPH_RAM_SIZE];
    uint8_t chargen_ram[UPD_CHARGEN_RAM_SIZE];
} upd_state_t;

upd_state_t upd_state;

void upd_init()
{
    uint8_t i;
    for (i=0; i<UPD_DISPLAY_DATA_RAM_SIZE; i++)
    {
        upd_state.display_data_ram[i] = 0;
    }
    for (i=0; i<UPD_PICTOGRAPH_RAM_SIZE; i++)
    {
        upd_state.pictograph_ram[i] = 0;
    }
    for (i=0; i<UPD_CHARGEN_RAM_SIZE; i++)
    {
        upd_state.chargen_ram[i] = 0;
    }
    upd_state.ram_area = UPD_RAM_NONE;
    upd_state.ram_size = 0;
    upd_state.address = 0;
    upd_state.increment = UPD_INCREMENT_OFF;
}

void _upd_wrap_address()
{
    if (upd_state.address >= upd_state.ram_size)
    {
        upd_state.address = 0;
    }
}

void _upd_write_data_byte(uint8_t b)
{
    switch (upd_state.ram_area)
    {
        case UPD_RAM_DISPLAY_DATA:
            upd_state.display_data_ram[upd_state.address] = b;
            break;

        case UPD_RAM_PICTOGRAPH:
            upd_state.pictograph_ram[upd_state.address] = b;
            break;

        case UPD_RAM_CHARGEN:
            upd_state.chargen_ram[upd_state.address] = b;
            break;

        case UPD_RAM_NONE:
        default:
            return;
    }

    if (upd_state.increment == UPD_INCREMENT_ON)
    {
        upd_state.address++;
        _upd_wrap_address();
    }
}

void _upd_process_address_setting_cmd(uint8_t cmd)
{
    uint8_t address;
    address = cmd & 0b00011111;

    switch (upd_state.ram_area)
    {
        case UPD_RAM_DISPLAY_DATA:
        case UPD_RAM_PICTOGRAPH:
            upd_state.address = address;
            _upd_wrap_address();
            break;

        case UPD_RAM_CHARGEN:
            // for chargen, address is character number (valid from 0 to 0x0F)
            if (address < 0x10)
            {
                upd_state.address = address * 7; // 7 bytes per character
            }
            else
            {
                upd_state.address = 0;
            }
            break;

        case UPD_RAM_NONE:
        default:
            address = 0;
            break;
    }
}

void _upd_process_data_setting_cmd(uint8_t cmd)
{
    uint8_t mode;
    mode = cmd & 0b00000111;

    // set ram target area
    switch (mode)
    {
        case UPD_RAM_DISPLAY_DATA:
            upd_state.ram_area = UPD_RAM_DISPLAY_DATA;
            upd_state.ram_size = UPD_DISPLAY_DATA_RAM_SIZE;
            // TODO does the real uPD16432B reset the address?
            break;

        case UPD_RAM_PICTOGRAPH:
            upd_state.ram_area = UPD_RAM_PICTOGRAPH;
            upd_state.ram_size = UPD_PICTOGRAPH_RAM_SIZE;
            // TODO does the real uPD16432B reset the address?
            break;

        case UPD_RAM_CHARGEN:
            upd_state.ram_area = UPD_RAM_CHARGEN;
            upd_state.ram_size = UPD_CHARGEN_RAM_SIZE;
            // TODO does the real uPD16432B reset the address?
            break;

        case UPD_RAM_NONE:
        default:
            upd_state.ram_area = UPD_RAM_NONE;
            upd_state.ram_size = 0;
            upd_state.address = 0;
    }

    // set increment mode
    switch (mode)
    {
        // only these modes support setting increment on/off
        case UPD_RAM_DISPLAY_DATA:
        case UPD_RAM_PICTOGRAPH:
            upd_state.increment = ((cmd & 0b00001000) == 0);
            break;

        // other modes always increment and also reset address
        default:
            upd_state.increment = 1;
            upd_state.address = 0;
            break;
    }

    // TODO changing data mode may make current address out of bounds
    // what does the real uPD16432B do when data setting is changed?
    _upd_wrap_address();
}

void upd_process_command(upd_command_t *updcmd)
{
    // No SPI bytes were received while STB was asserted
    if (updcmd->size == 0)
    {
        return;
    }

    // Process command byte
    uint8_t cmd;
    cmd = updcmd->data[0];
    switch (cmd & 0b11000000)
    {
        case 0b01000000:
            _upd_process_data_setting_cmd(cmd);
            break;

        case 0b10000000:
            _upd_process_address_setting_cmd(cmd);
            break;

        default:
            break;
    }

    // Process data bytes
    if ((upd_state.ram_area != UPD_RAM_NONE) && (updcmd->size > 1))
    {
        uint8_t i;
        for (i=1; i<updcmd->size; i++)
        {
            _upd_write_data_byte(updcmd->data[i]);
        }
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
#define CMD_SET_RUN_MODE 0x03
#define CMD_UPD_DUMP_STATE 0x10
#define CMD_UPD_RESET 0x11
#define CMD_UPD_PROCESS_COMMAND 0x12
#define CMD_RADIO_LOAD_KEY_DATA 0x20
#define CMD_RADIO_PUSH_POWER_BUTTON 0x21
#define CMD_ARG_GREEN_LED 0x00
#define CMD_ARG_RED_LED 0x01
#define CMD_ARG_RUN_MODE_NORMAL 0x00
#define CMD_ARG_RUN_MODE_TEST 0x01

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

void cmd_reply_ack()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(ACK);  // ACK byte
    uart_flush_tx();
}

void cmd_reply_nak()
{
    uart_putc(0x01); // 1 byte to follow
    uart_putc(NAK);  // NAK byte
    uart_flush_tx();
}

/* Command: Reset uPD16432B Emulator
 * Arguments: none
 * Returns: <ack>
 *
 * Reset the uPD16432B Emulator to its default state.  This does not
 * affect the UPD key data output bytes (upd_tx_key_data).
 */
void cmd_do_upd_reset()
{
    if (cmd_buf_index != 1)
    {
        cmd_reply_nak();
        return;
    }

    upd_init();
    cmd_reply_ack();
}

/* Command: Dump uPD16432B Emulator State
 * Arguments: none
 * Returns: <ack> <all bytes in upd_state>
 *
 * Dumps the current state of the uPD16432B Emulator.
 */
void cmd_do_upd_dump_state()
{
    if (cmd_buf_index != 1)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t size = 1 + // ACK byte
                   1 + // Selected RAM area
                   1 + // Size of selected RAM area
                   1 + // Current address in that area
                   1 + // Address increment mode on/off
                   UPD_DISPLAY_DATA_RAM_SIZE +
                   UPD_PICTOGRAPH_RAM_SIZE +
                   UPD_CHARGEN_RAM_SIZE;

    uart_putc(size); // number of bytes to follow
    uart_putc(ACK); // ACK byte
    uart_putc(upd_state.ram_area);
    uart_putc(upd_state.ram_size);
    uart_putc(upd_state.address);
    uart_putc(upd_state.increment);
    uart_flush_tx();
    uint8_t i;
    for (i=0; i<UPD_DISPLAY_DATA_RAM_SIZE; i++)
    {
        uart_putc(upd_state.display_data_ram[i]);
    }
    uart_flush_tx();
    for (i=0; i<UPD_PICTOGRAPH_RAM_SIZE; i++)
    {
        uart_putc(upd_state.pictograph_ram[i]);
    }
    uart_flush_tx();
    for (i=0; i<UPD_CHARGEN_RAM_SIZE; i++)
    {
        uart_putc(upd_state.chargen_ram[i]);
    }
    uart_flush_tx();
}

/* Command: Process uPD16432B Emulator Command
 * Arguments: <cmd byte> <cmd arg byte1> <cmd arg byte2> ...
 * Returns: <ack>
 *
 * Sends a fake SPI command to the uPD16432B Emulator.  The
 * arguments are the SPI bytes that would be received by the uPD16432B
 * while it is selected with STB high.
 */
void cmd_do_upd_process_command()
{
    upd_command_t updcmd;

    // Bail out if size of bytes from UART exceeds uPD16432B command max size.
    // -1 because first byte in cmd_buf is CMD_UPD_PROCESS_COMMAND not SPI data
    if ((cmd_buf_index - 1) > sizeof(updcmd.data))
    {
        return cmd_reply_nak();
    }

    // Popular uPD16432B command request with bytes from UART
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
        updcmd.data[i-1] = cmd_buf[i];
    }
    updcmd.size = i-1;

    // Process uPD16432B command request as if we received it over SPI
    upd_process_command(&updcmd);
    return cmd_reply_ack();
}

/* Command: Load uPD16432B Emulator Key Data
 * Arguments: <cmd byte> <key0> <key1> <key2> <key3>
 * Returns: <ack>
 *
 * Load the four bytes of the uPD16432B emulator key data.  These bytes
 * will be sent to the radio whenever a key data request command is received.
 * The same bytes will be sent for every key data request until the bytes
 * are changed.  Set {0, 0, 0, 0} to indicate no keys pressed.
 */
void cmd_do_radio_load_key_data()
{
    if (cmd_buf_index != 5)
    {
        cmd_reply_nak();
        return;
    }

    // load the four key data bytes
    uint8_t i;
    for (i=0; i<4; i++)
    {
        upd_tx_key_data[i] = cmd_buf[i+1];
    }

    cmd_reply_ack();
    return;
}

/* Command: Echo
 * Arguments: <arg1> <arg2> <arg3> ...
 * Returns: <ack> <arg1> <arg1> <arg3> ...
 *
 * Echoes the arguments received back to the client.  If no args were
 * received after the command byte, an empty ACK response is returned.
 */
void cmd_do_echo()
{
    uart_putc(cmd_buf_index); // number of bytes to follow
    uart_putc(ACK); // ACK byte
    uint8_t i;
    for (i=1; i<cmd_buf_index; i++)
    {
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
void cmd_do_set_led()
{
    if (cmd_buf_index != 3)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t led_num = cmd_buf[1];
    uint8_t led_state = cmd_buf[2];

    switch (led_num)
    {
        case CMD_ARG_RED_LED:
            led_set(LED_RED, led_state);
            break;

        case CMD_ARG_GREEN_LED:
            led_set(LED_GREEN, led_state);
            break;

        default:
            cmd_reply_nak();
            return;
    }

    cmd_reply_ack();
}

/* Command: Set Run Mode
 * Arguments: <mode>
 * Returns: <ack|nak>
 *
 * Sets the current running mode (one of the RUN_MODE_* constants).  In
 * test mode, SPI commands from the radio are ignored so the uPD16432B
 * code can be tested.
 */
void cmd_do_set_run_mode()
{
    if (cmd_buf_index != 2)
    {
        cmd_reply_nak();
        return;
    }

    uint8_t mode = cmd_buf[1];

    switch (mode)
    {
        case CMD_ARG_RUN_MODE_NORMAL:
            run_mode = RUN_MODE_NORMAL;
            break;

        case CMD_ARG_RUN_MODE_TEST:
            run_mode = RUN_MODE_TEST;
            break;

        default:
            return cmd_reply_nak();
    }

    cmd_reply_ack();
}

/* Command: Push Radio Power Button
 * Arguments: <mode>
 * Returns: <ack|nak>
 *
 * Push the radio's power button momentarily.  This should either turn
 * the radio on or off.
 */
void cmd_do_push_power_button()
{
    if (cmd_buf_index != 1)
    {
        cmd_reply_nak();
        return;
    }

    radio_push_power_button();
    cmd_reply_ack();
}

/* Dispatch a command.  A complete command packet has been received.  The
 * command buffer has one more bytes.  The first byte is the command byte.
 * Dispatch to a handler, or return a NAK if the command is unrecognized.
 */
void cmd_dispatch()
{
    switch (cmd_buf[0])
    {
        case CMD_SET_LED:
            cmd_do_set_led();
            break;
        case CMD_ECHO:
            cmd_do_echo();
            break;
        case CMD_SET_RUN_MODE:
            cmd_do_set_run_mode();
            break;

        case CMD_UPD_DUMP_STATE:
            cmd_do_upd_dump_state();
            break;
        case CMD_UPD_RESET:
            cmd_do_upd_reset();
            break;
        case CMD_UPD_PROCESS_COMMAND:
            cmd_do_upd_process_command();
            break;

        case CMD_RADIO_LOAD_KEY_DATA:
            cmd_do_radio_load_key_data();
            break;
        case CMD_RADIO_PUSH_POWER_BUTTON:
            cmd_do_push_power_button();
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

// copy emulated upd display to real faceplate
void copy_emulated_upd_to_faceplate()
{
    uint8_t data[17];
    uint8_t i;

    // send data setting command: write to display data ram
    data[0] = 0x40;
    faceplate_spi_send_cmd(1, data);

    // send address setting command + display data
    data[0] = 0x80;
    for (i=0; i<16; i++)
    {
        data[i+1] = upd_state.display_data_ram[i];
    }
    faceplate_spi_send_cmd(1+16, data);

    // send data setting command: write to pictograph ram
    data[0] = 0x41;
    faceplate_spi_send_cmd(1, data);

    // send address setting command + pictograph data
    data[0] = 0x80;
    for (i=0; i<8; i++)
    {
        data[i+1] = upd_state.pictograph_ram[i];
    }
    faceplate_spi_send_cmd(1+8, data);
}

int main()
{
    run_mode = RUN_MODE_NORMAL;

    led_init();
    uart_init();
    cmd_init();
    radio_spi_init();
    faceplate_spi_init();
    upd_init();
    sei();

    // clear faceplate
    faceplate_spi_clear();

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
            upd_command_t updcmd;
            updcmd = upd_rx_buf.cmds[upd_rx_buf.read_index];
            upd_rx_buf.read_index++;

            if (run_mode != RUN_MODE_TEST)
            {
                upd_process_command(&updcmd);
                copy_emulated_upd_to_faceplate();
            }
        }

    }
}
