;M62419FP Command Parsing
;
;These routines parse data from the 14-bit M62419FP commands received.  They
;all operate on a 2-byte buffer at the Y-pointer and are intended to run in
;the main loop.  See the M62419FP datasheet for the command format and
;conversions from codes to dB.
;
;  High Byte
;                  |   5   |   4   |   3   |   2   |   1   |   0   |
;  ----------------+-------+-------+-------+-------+-------+-------+
;                  | CH0/1 |CH/BOTH|            ATT1               |  DS=0
;                  |             BASS              |      TREB     |  DS=1
;
;  Low Byte
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  ATT1 |      ATT2     |  LOUD |     INPUT     |   0   |  DS   |  DS=0
;  |     TREB      |             FADER             |FADESEL|  DS   |  DS=1
;


cmd_parse:
;Parse any M62419FP command and update virtual M62419FP registers.
;
;Reads 2-byte command packet at Y.
;Updates M62419FP registers buffer at Z.
;
    ld r16, Y                   ;Load command packet low byte
    sbrs r16, 0                 ;Skip next if data select bit = 1
    rjmp cmd_parse_ds0          ;Parse command with ds=0 (vol/loud/input)
    rjmp cmd_parse_ds1          ;Parse command with ds=1 (bass/treb/fade)


cmd_parse_ds0:
;Parse an M62419FP command with data select bit = 0 (volume/loudness/input).
;
;Reads 2-byte command packet at Y.
;Updates M62419FP registers buffer at Z.
;
    ldd r16, Y+1                ;Load command packet high byte
    sbrc r16, 4                 ;Skip next if bit 4 indicates both channels
    rjmp cpds0_single           ;Jump to handle single channel only
    call cpds0_parse            ;Parse into channel 0 registers, then
    rjmp cpds0_parse_ch1        ;  parse into channel 1 registers and return
cpds0_single:
    sbrs r16, 5                 ;Skip next if bit 5 indicates channel 1
    rjmp cpds0_parse            ;Parse into channel 0 registers and return
    rjmp cpds0_parse_ch1        ;Parse into channel 1 registers and return
cpds0_parse:
    rcall cmd_parse_att1        ;Parse ATT1 code
    std Z+0, r16
    rcall cmd_parse_att2        ;Parse ATT2 code
    std Z+1, r16
    rcall cmd_parse_loudness    ;Parse loudness flag
    std Z+2, r16
    rcall cmd_parse_input       ;Parse input selector
    std Z+3, r16
    ret
cpds0_parse_ch1:
    adiw ZH:ZL, ch1             ;Add offset for channel 1
    call cpds0_parse            ;Parse command into channel 1 registers
    sbiw ZH:ZL, ch1             ;Restore original Z pointer
    ret


cmd_parse_ds1:
;Parse an M62419FP command with data select bit = 1 (bass/treble/fader).
;
;Reads 2-byte command packet at Y.
;Updates M62419FP registers buffer at Z.
;
    rcall cmd_parse_fadesel     ;Parse fade select flag
    std Z+fadesel, r16
    rcall cmd_parse_fader       ;Parse fader code
    std Z+fader, r16
    rcall cmd_parse_bass        ;Parse bass code
    std Z+bass, r16
    rcall cmd_parse_treble      ;Parse treble code
    std Z+treble, r16
    ret


cmd_parse_input:
;Parse input selector from an M62419FP command packet.
;Command must have data select bit = 0 (volume/loudness/input).
;
;0=D/CD, 1=B/FM, 2=C/TAPE, 3=A/AM
;
;Reads 2-byte command packet at Y-pointer.
;Stores 2-bit input selector code in R16.
;
    ;00111010 1111xx00 -> 0000000xx
    ld r16, Y               ;Read low byte
    lsr r16
    lsr r16
    andi r16, 0b00000011
    ret


cmd_parse_loudness:
;Parse loudness from an M62419FP command packet.
;Command must have data select bit = 0 (volume/loudness/input)
;
;0=Loudness off, 1=Loudness on
;
;Reads 2-byte command packet at Y-pointer.
;Stores 1-bit loudness flag (1=loudness on) in R16.
;
    ;00111010 111x0100 -> 0000000x
    ld r16, Y               ;Read low byte
    bst r16, 4              ;Set T flag to loudness bit
    clr r16
    bld r16, 0              ;Set bit 0 from T flag
    ret


cmd_parse_att1:
;Parse ATT1 attenuator code from an M62419FP command packet.
;Command must have data select bit = 0 (volume/loudness/input)
;
;Reads 2-byte command packet at Y-pointer.
;Stores 5-bit ATT1 code in R16.
;
    ;0011xxxx x1110100 -> 000xxxxx
    ld r16, Y               ;Read low byte
    rol r16
    ldd r16, Y+1            ;Read high byte
    rol r16
    andi r16, 0b00011111
    ret


cmd_parse_att2:
;Parse ATT2 attenuator code from an M62419FP command packet.
;Command must have data select bit = 0 (volume/loudness/input)
;
;Reads 2-byte command packet at Y-pointer.
;Stores 2-bit ATT2 code in R16.
;
    ;00111010 1xx10100 -> 000000xx
    ld r16, Y               ;Read low byte
    swap r16
    lsr r16
    andi r16, 0b00000011
    ret


cmd_parse_fadesel:
;Parse fader select bit from an M62419FP command packet.
;Command must have data select bit = 1 (bass/treble/fader)
;
;0=Fader attenuates front, 1=Fader attenuates rear
;
;Reads 2-byte command packet at Y-pointer
;Stores 1-bit fader select flag in R16
;
    ;00100110 010001x1 -> 0000000x
    ld r16, Y               ;Read low byte
    lsr r16
    andi r16, 0b00000001
    ret


cmd_parse_fader:
;Parse fader code from an M62419FP command packet.
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit fader code in R16
;
    ;00100110 01xxxx01 -> 0000xxxx
    ld r16, Y               ;Read low byte
    lsr r16
    lsr r16
    andi r16, 0b00001111
    ret


cmd_parse_bass:
;Parse bass tone code from an M62419FP command packet
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit tone code in R16
;
    ;00xxxx10 01000101 -> 0000xxxx
    ldd r16, Y+1            ;Read high byte
    lsr r16
    lsr r16
    andi r16, 0b00001111
    ret


cmd_parse_treble:
;Parse treble tone code from an M62419FP command packet
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit tone code in R16
;
    ;001001xx xx000101 -> 0000xxxx
    ld r16, Y               ;Read low byte
    bst r16, 6              ;Save bit 6 of low byte in T
    lsl r16                 ;Save bit 7 of low byte in carry
    ldd r16, Y+1            ;Read high byte
    rol r16                 ;Rotate in bit 7 from low byte
    lsl r16                 ;Rotate in a zero
    bld r16, 0              ;  then replace it with bit 6 from low byte
    andi r16, 0b00001111
    ret


cmd_calc_att1_db:
;Calculate ATT1 value in dB from ATT1 code.
;Infinity (ATT1 code 0) is returned as -100 dB.
;ATT1 codes undefined in the datasheet are returned as -127 dB.
;
;Reads 5-bit ATT1 code from R16.
;Stores signed dB value in R16.
;
    push ZL
    push ZH
    ldi ZL, low(att1_to_db * 2) ;Base address of lookup table
    ldi ZH, high(att1_to_db * 2)

    cpi r16, 0x20               ;ATT2 code 0x20 and above are invalid
    rjmp finish_db_lookup       ;Look up dB value, return it in R16


cmd_calc_att2_db:
;Calculate ATT2 value in dB from ATT2 code.
;ATT2 codes undefined in the datasheet are returned as -127 dB.
;
;Reads 2-bit ATT2 code from R16.
;Stores signed dB value in R16.
;Destroys R17.
;
    push ZL
    push ZH
    ldi ZL, low(att2_to_db * 2) ;Base address of lookup table
    ldi ZH, high(att2_to_db * 2)

    cpi r16, 0x04               ;ATT2 code 0x04 and above are invalid
    rjmp finish_db_lookup       ;Look up dB value, return it in R16


cmd_calc_fader_db:
;Calculate fader value in dB from a fader code.
;Infinity (fader code 0x0F) is returned as -100 dB.
;Fader codes undefined in the datasheet are returned as -127 dB.
;
;Reads 4-bit fader code from R16.
;Stores signed dB value in R16.
;
    push ZL
    push ZH
    ldi ZL, low(fade_to_db * 2) ;Base address of lookup table
    ldi ZH, high(fade_to_db * 2)

    cpi r16, 0x10               ;Fader code 0x10 and above are invalid
    rjmp finish_db_lookup       ;Look up dB value, return it in R16


cmd_calc_tone_db:
;Calculate tone value in dB from a tone code (bass or treble).
;Tone codes undefined in the datasheet are returned as -127 dB.
;
;Reads 4-bit tone code from R16.
;Stores signed dB value in R16.
;
    push ZL
    push ZH
    ldi ZL, low(tone_to_db * 2) ;Base address of lookup table
    ldi ZH, high(tone_to_db * 2)

    cpi r16, 0x10               ;Tone code 0x10 and above are invalid

    ;Fall through into finish_db_lookup to look up dB value, return it in R16


finish_db_lookup:
    brsh finish_invalid         ;Branch if equal or greater (invalid code)

    add ZL, r16                 ;Add index to table base address
    clr r16
    adc ZH, r16
    lpm r16, Z                  ;Read dB value from table

    pop ZH
    pop ZL
    ret                         ;Return dB value in R16
finish_invalid:
    ldi r16, -127               ;-127 dB = undefined
    ret                         ;Return dB value in R16


att1_to_db:
    .db -100,  -20,  -52, -127,  -68,   -4,  -36, -127  ;-100 = infinity
    .db  -76,  -12,  -44, -127,  -60, -127,  -28, -127  ;-127 = undefined
    .db  -80,  -16,  -48, -127,  -64,    0,  -32, -127
    .db  -72,   -8,  -40, -127,  -56, -127,  -24, -127

att2_to_db:
    .db   -3,   -1,   -2,    0

fade_to_db:
    .db -100,  -10,  -20,   -3,  -45,   -6,  -14,   -1  ;-100 = infinity
    .db  -60,   -8,  -16,   -2,  -30,   -4,  -12,    0

tone_to_db:
    .db -127,   -2,  -10,    6, -127,    2,   -6,   10  ;-127 = undefined
    .db -127,    0,   -8,    8,  -12,    4,   -4,   12


cmd_calc_att_sum_db:
;Calculate the total attenuation of two signed dB values.
;If either is undefined (-127), the sum is undefined (-127).
;
;Reads a signed dB value from R16
;Reads a signed dB value from R17
;Returns total attenuation as signed dB value in R16.  R17 unchanged.
;
    cpi r16, -127               ;Is ATT1 undefined?
    breq cas_invalid            ;  Yes: sum will also be undefined

    cpi r17, -127               ;Is ATT2 undefined?
    breq cas_invalid            ;  Yes: sum will also be undefined

    add r16, r17                ;ATT1 and ATT2 are valid, so add them
    rjmp cas_done

cas_invalid:
    ldi r16, -127               ;-127 dB = undefined

cas_done:
    ret                         ;Return dB value in R16
