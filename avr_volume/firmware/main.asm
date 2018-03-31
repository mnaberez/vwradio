;VW Premium IV Radio (Clarion PU-1666A) Volume Monitor
;
;Passively captures SPI commands from the radio's microcontroller to its
;Mitsubishi M62419FP sound controller, decodes the commands, computes
;the programmed attenuator values in dB, then dumps the values out
;the UART at 115200 bps, N-8-1.
;
.include "m1284def.asm"


.equ ram             = SRAM_START
;Buffers for M62419FP command packets (isr buf -> rx buf -> work buf)
.equ packet_bitcount = ram      ;Counts down bits remaining to rx in packet
.equ packet_isr_buf  = ram+$01  ;2 bytes to accumulate SPI packet bits in ISR
.equ packet_rx_buf   = ram+$03  ;2 bytes for complete SPI packet received
.equ packet_work_buf = ram+$05  ;2 bytes for SPI packet used during parsing
;Buffer used to track M62419FP state across commands
.equ m62419fp_buf    = ram+$07  ;12 byte buffer for M62419FP state


;Offsets into M62419FP state buffer
.equ ch0             = 0                ;Channel 0 (Right):
.equ ch0_att1        = ch0+0            ;  ATT1 5-bit code
.equ ch0_att2        = ch0+1            ;  ATT2 2-bit code
.equ ch0_loudness    = ch0+2            ;  Loudness flag (0=off, 1=on)
.equ ch0_input       = ch0+3            ;  Input selector 2-bit code
.equ ch1             = ch0_input+1      ;Channel 1 (Left):
.equ ch1_att1        = ch1+0            ;  ATT1 5-bit code
.equ ch2_att2        = ch1+1            ;  ATT2 2-bit code
.equ ch3_loudness    = ch1+2            ;  Loudness bit (0=off, 1=on)
.equ ch4_input       = ch1+3            ;  Input selector 2-bit code
.equ common          = ch4_input+1      ;Common to both channels:
.equ fadesel         = common+0         ;  Fader Select flag (0=front, 1=rear)
.equ fader           = common+1         ;  Fader 4-bit code
.equ bass            = common+2         ;  Bass 4-bit tone code
.equ treble          = common+3         ;  Treble 4-bit tone code


.org 0
    rjmp reset

.org PCI0addr
    rjmp spi_isr_pcint0

.org 0+INT_VECTORS_SIZE


reset:
    ldi r16, low(RAMEND)        ;Initialize the stack pointer
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16

    rcall uart_init             ;15200 bps, N-8-1
    rcall spi_init              ;Set up for M62419FP receive on interrupt
    sei                         ;Enable interrupts

loop:
    ;Set Y-pointer to a buffer that will receive a packet
    ldi YL, low(packet_work_buf)
    ldi YH, high(packet_work_buf)

    ;Set Z-pointer to M62419FP registers buffer
    ldi ZL, low(m62419fp_buf)
    ldi ZH, high(m62419fp_buf)

wait:
    ;Wait for an M62419FP command packet
    rcall spi_get_packet        ;Try to get a new packet into bufer at Y
    brcc wait                   ;Loop until one is ready

    rcall cmd_parse             ;Parse command at Y into registers at Z
    rcall cmd_parse             ;Parse command at Y into registers at Z
    rcall dump_to_uart
    rjmp loop


dump_to_uart:
;Dump the virtual M62419FP register state to the UART, along with
;the calculated attenuation values in dB.
;
;Format of the dump:
;  Byte  0: Number of bytes to follow
;  Byte  1: CH0 ATT1 5-bit code
;  Byte  2: CH0 ATT2 2-bit code
;  Byte  3: CH0 Attenuation (ATT1+ATT2) in signed dB
;  Byte  4: CH0 Loudness flag
;  Byte  5: CH0 Input Selector 2-bit code
;  Byte  6: CH1 ATT1 5-bit code
;  Byte  7: CH1 ATT2 2-bit code
;  Byte  8: CH1 Attenuation (ATT1+ATT2) in signed dB
;  Byte  9: CH1 Loudness flag
;  Byte 10: CH1 Input Selector 2-bit code
;  Byte 11: Fader Select flag
;  Byte 12: Fader 4-bit code
;  Byte 13: Fader Attenuation in signed dB
;  Byte 14: Bass 4-bit code
;  Byte 15: Bass tone in signed dB
;  Byte 16: Treble 4-bit code
;  Byte 17: Treble tone in signed dB
;
;Destroys R16, R17, R18, Z-pointer.
;
    ldi r16, 17
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
    rcall cmd_calc_att1_db      ;Convert ATT1 to signed dB
    push r16                    ;Save ATT1 dB on the stack
    ld r16, Z+                  ;Load ATT2 code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_att2_db      ;Convert it to signed dB
    mov r17, r16                ;Move ATT2 dB into R17
    pop r16                     ;Recall ATT1 dB into R16
    rcall cmd_calc_att_sum_db   ;Caculate sum of R16 + R17 in signed dB
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
    rcall cmd_calc_fader_db     ;Convert it to signed dB
    rcall uart_send_byte        ;Send it

    ld r16, Z+                  ;Load bass 4-bit code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_tone_db      ;Convert it to signed dB
    rcall uart_send_byte        ;Send it

    ld r16, Z+                  ;Load treble 4-bit code
    rcall uart_send_byte        ;Send it
    rcall cmd_calc_tone_db      ;Convert it to signed dB
    rcall uart_send_byte        ;Send it
    ret


.include "m62419fp_spi.asm"     ;M62419FP SPI receive
.include "m62419fp_cmd.asm"     ;M52419FP SPI command packet parsing
.include "uart.asm"             ;UART routines
