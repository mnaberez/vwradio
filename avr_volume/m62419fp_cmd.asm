;M62419FP Command Parsing
;
;These routines parse data from the M62419FP commands received.  They all
;operate on the work buffer (packet_work_buf) and are intended to run in
;the main loop.  See the M62419FP datasheet for the command format and
;conversions from codes to dB.
;

cmd_parse_input:
;Parse input selector from an M62419FP command packet.
;Command must have data select bit = 0 (volume/loudness/input)
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
;Parse Fader Select bit from an M62419FP command packet.
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 1-bit Fader Select flag in R16
;
    ;00100110 010001x1 -> 0000000x
    ld r16, Y               ;Read low byte
    lsr r16
    andi r16, 0b00000001
    ret


cmd_parse_fader:
;Parse Fader attenuator code from an M62419FP command packet.
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit Fader code in R16
;
    ;00100110 01xxxx01 -> 0000xxxx
    ld r16, Y               ;Read low byte
    lsr r16
    lsr r16
    andi r16, 0b00001111
    ret


cmd_parse_bass:
;Parse Bass tone code from an M62419FP command packet
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit Bass code in R16
;
    ;00xxxx10 01000101 -> 0000xxxx
    ldd r16, Y+1            ;Read high byte
    lsr r16
    lsr r16
    andi r16, 0b00001111
    ret


cmd_parse_treble:
;Parse Treble tone code from an M62419FP command packet
;Command must have data select bit = 1 (bass/treble/fader)
;
;Reads 2-byte command packet at Y-pointer
;Stores 4-bit Treble code in R16
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
;Calculate Fader value in dB from Fader code.
;Infinity (Fader code 0x0F) is returned as -100 dB.
;Fader codes undefined in the datasheet are returned as -127 dB.
;
;Reads 4-bit Fader code from R16.
;Stores signed dB value in R16.
;
    push ZL
    push ZH
    ldi ZL, low(fade_to_db * 2) ;Base address of lookup table
    ldi ZH, high(fade_to_db * 2)

    cpi r16, 0x10               ;Fader code 0x10 and above are invalid
    rjmp finish_db_lookup       ;Look up dB value, return it in R16


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
