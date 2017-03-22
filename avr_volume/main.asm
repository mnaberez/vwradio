;VW Premium IV Radio (Clarion PU-1666A) Volume Monitor
;
;Passively captures SPI commands from the radio's microcontroller to its
;Mitsubishi M62419FP sound controller, decodes the commands, computes
;the programmed attenuator values in dB, then dumps the values out
;the UART at 115200 bps, N-8-1.
;
;Atmel ATMega1284 running at 20 MHz
;
;Pin  9: /RESET to GND through pushbutton, 10K pullup to Vcc
;               also connect to Atmel-ICE AVR port pin 6 nSRST
;Pin 10: Vcc (connect to radio's 5V)
;Pin 11: GND (connect to radio's GND)
;Pin 12: XTAL2 (to 20 MHz crystal with 18pF cap to GND)
;Pin 13: XTAL1 (to 20 MHz crystal and 18pF cap to GND)
;...
;Pin 15: PD1/TXD (to PC's serial RXD)
;...
;Pin 24: PC2 JTAG TCK (to Atmel-ICE AVR port pin 1 TCK)
;Pin 25: PC3 JTAG TMS (to Atmel-ICE AVR port pin 5 TMS)
;Pin 26: PC4 JTAG TDO (to Atmel-ICE AVR port pin 3 TDO)
;Pin 27: PC5 JTAG TDI (to Atmel-ICE AVR port pin 9 TDI)
;...
;Pin 30: AVCC connect directly to Vcc (also to Atmel-ICE AVR port pin 4 VTG)
;Pin 31: GND (also to Atmel-ICE AVR port pins 2 GND and 10 GND)
;Pin 32: AREF connect to GND through 0.1 uF cap
;...
;Pin 39: PA1 M62419FP Clock
;Pin 40: PA0 M62419FP Data
;

.include "m1284def.asm"


;Buffers for M62419FP commands (rx buf -> work buf)
.equ packet_rx_buf   = SRAM_START       ;2 byte buffer used for ISR receive
.equ packet_work_buf = SRAM_START+$02 	;2 byte buffer used during parsing
;Buffer used to track M62419FP state across commands
.equ m62419fp_buf    = SRAM_START+$04   ;12 byte buffer for M62419FP state


;Offsets into M62419FP state buffer
.equ ch0             = 0                ;Channel 0:
.equ ch0_att1        = ch0+0            ;  ATT1 5-bit code
.equ ch0_att2        = ch0+1            ;  ATT2 2-bit code
.equ ch0_loudness    = ch0+2            ;  Loudness flag
.equ ch0_input       = ch0+3            ;  Input selector 2-bit code
.equ ch1             = ch0_input+1      ;Channel 1:
.equ ch1_att1        = ch1+0            ;  ATT1 5-bit code
.equ ch2_att2        = ch1+1            ;  ATT2 2-bit code
.equ ch3_loudness    = ch1+2            ;  Loudness flag
.equ ch4_input       = ch1+3            ;  Input selector 2-bit code
.equ common          = ch4_input+1      ;Common to both channels:
.equ fadesel         = common+0         ;  Fader Select flag
.equ fader           = common+1         ;  Fader 4-bit code
.equ bass            = common+2         ;  Bass 4-bit tone code
.equ treble          = common+3         ;  Treble 4-bit tone code


.org 0
    rjmp reset

.org PCI0addr
	rjmp spi_isr_pcint0

.org 0+INT_VECTORS_SIZE


reset:
	ldi r16, low(RAMEND) 		;Initialize the stack pointer
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	rcall uart_init 			;15200 bps, N-8-1
	rcall spi_init              ;Set up for M62419FP receive on interrupt
	sei                         ;Enable interrupts
    rcall dump_buffer_to_uart
loop:
    ;Set Y-pointer to a buffer that will receive a packet
    ldi YL, low(packet_work_buf)
    ldi YH, high(packet_work_buf)

    ;Wait for an M62419FP command packet
    rcall spi_get_packet        ;Try to get a new packet in packet_work_buf
    brcc loop                   ;Loop until one is ready

    rcall parse_cmd_into_buffer
    rcall dump_buffer_to_uart
    rjmp loop


parse_cmd_into_buffer:
    ld r16, Y                   ;Load command packet low byte
    andi r16, 1                 ;Mask off all except data select bit
    brne parse_fade_tone        ;Branch if it's a tone command
    rcall parse_vol_cmd_into_buffer
    rjmp parse_done
parse_fade_tone:
    rcall parse_fade_tone_cmd_into_buffer
parse_done:
    ret


parse_vol_cmd_into_buffer:
    ;Set Z-pointer for buffer area for channel 0 or 1
    ldi ZL, low(m62419fp_buf)   ;Base address of M62419FP registers buffer
    ldi ZH, high(m62419fp_buf)
    ldd r16, Y+1                ;Load command packet high byte
    sbrc r16, 5                 ;Skip next instruction if this is channel 0
    adiw ZH:ZL, ch1             ;Add offset for channel 1

    ;Parse command, save in buffer
    rcall cmd_parse_att1        ;Parse ATT1 code from packet
    st Z+, r16
    rcall cmd_parse_att2        ;Parse ATT1 code from packet
    st Z+, r16
    rcall cmd_parse_loudness    ;Parse loudness from packet
    st Z+, r16
    rcall cmd_parse_input       ;Parse input selector from packet
    st Z+, r16
    ret


parse_fade_tone_cmd_into_buffer:
    ;Set Z-pointer to buffer area for fader
    ldi ZL, low(m62419fp_buf+common)
    ldi ZH, high(m62419fp_buf+common)
    rcall cmd_parse_fadesel
    st Z+, r16
    rcall cmd_parse_fader
    st Z+, r16
    rcall cmd_parse_bass
    st Z+, r16
    rcall cmd_parse_treble
    st Z+, r16
    ret


dump_buffer_to_uart:
;Dump the virtual M62419FP register state to the UART, along with
;the calculated attenuation values in dB.
;
;Format of the dump:
;  Byte  0: Number of bytes to follow (always 15)
;  Byte  1: CH0 ATT1 5-bit code
;  Byte  2: CH0 ATT2 2-bit code
;  Byte  3: CH0 Attenuation (ATT1+ATT2) in dB
;  Byte  4: CH0 Loudness flag
;  Byte  5: CH0 Input Selector 2-bit code
;  Byte  6: CH1 ATT1 5-bit code
;  Byte  7: CH1 ATT2 2-bit code
;  Byte  8: CH1 Attenuation (ATT1+ATT2) in dB
;  Byte  9: CH1 Loudness flag
;  Byte 10: CH1 Input Selector 2-bit code
;  Byte 11: Fader Select flag
;  Byte 12: Fader 4-bit code
;  Byte 13: Fader Attenuation in dB
;  Byte 14: Bass 4-bit code
;  Byte 15: Treble 4-bit code
;
;Destroys R16, R17, R18, Z-pointer.
;
    ldi r16, 15
    rcall uart_send_byte        ;Send number of bytes to follow
    clr r18                     ;Channel number = 0
dump_loop:
    ;Set Z-pointer to buffer area for channel 0 or 1
    ldi ZL, low(m62419fp_buf)   ;Base address of M62419FP registers buffer
    ldi ZH, high(m62419fp_buf)
    sbrc r18, 0                 ;Skip next instruction if this is channel 0
    adiw ZH:ZL, ch1             ;Add offset for channel 1 registers

    ;Send ATT1 and ATT2 codes, calculate ATT1+ATT2 in dB and send it
    ld r16, Z+                  ;Load ATT1 code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_att1_db      ;Convert ATT1 to dB
    push r16                    ;Save ATT1 dB on the stack
    ld r16, Z+                  ;Load ATT2 code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_att2_db      ;Convert it to dB
    mov r17, r16                ;Move ATT2 dB into R17
    pop r16                     ;Recall ATT1 dB into R16
    rcall cmd_calc_att_sum_db   ;Caculate sum of R16 + R17 in dB
    rcall uart_send_byte        ;Send it

    ;Send other registers
    ld r16, Z+                  ;Load and send loudness
    rcall uart_send_byte
    ld r16, Z+                  ;Load and send input selector
    rcall uart_send_byte

    inc r18                     ;Increment channel number
    cpi r18, 2                  ;Finished both channels?
    brne dump_loop              ;  No: dump next channel

    ;Set Z-pointer to buffer area for fader
    ldi ZL, low(m62419fp_buf+common)
    ldi ZH, high(m62419fp_buf+common)

    ld r16, Z+                  ;Load and send fader select
    rcall uart_send_byte

    ld r16, Z+                  ;Load fader 4-bit code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_fader_db     ;Convert it to dB
    rcall uart_send_byte        ;Send it

    ld r16, Z+                  ;Load bass 4-bit code
    rcall uart_send_byte        ;Send it

    ld r16, Z+                  ;Load treble 4-bit code
    rcall uart_send_byte        ;Send it
    ret


.include "m62419fp_spi.asm"     ;M62419FP SPI receive
.include "m62419fp_cmd.asm"     ;M52419FP SPI command packet parsing
.include "uart.asm"             ;UART routines
