;M62419FP Command Parsing
;
;These routines parse data from the M62419FP commands received.  They all
;operate on the work buffer (packet_work_buf) and are intended to run in
;the main loop.  See the M62419FP datasheet for the command format and
;conversions from codes to dB.
;

cmd_parse_input:
;Parse input selector from an M62419FP command packet.
;
;Reads command in packet_work_buf.
;Stores 2-bit input selector code in R16.
;
    lds r16, packet_work_buf    ;Read low byte
    lsr r16
    lsr r16
    andi r16, 0b00000011
    ret


cmd_parse_loudness:
;Parse loudness from an M62419FP command packet.
;
;Reads command in packet_work_buf.
;Stores 1-bit loudness flag (1=loudness on) in R16.
;
    lds r16, packet_work_buf    ;Read low byte
    bst r16, 4                  ;Set T flag to loudness bit
    clr r16
    bld r16, 0                  ;Set bit 0 from T flag (loudness bit)
    ret


cmd_parse_att1:
;Parse ATT1 attenuator codes from an M62419FP command packet.
;
;Reads command in packet_work_buf.
;Stores 5-bit ATT1 code in R16.
;
    ;5-bit ATT1 code is made up of bit 7 of low byte & bits 0-3 of high byte
    ;Combine and shift into lower 5 bits of a byte, store it in att1_code
    lds r16, packet_work_buf    ;Read low byte
    rol r16
    lds r16, packet_work_buf+1  ;Read high byte
    rol r16
    andi r16, 0b00011111
    ret


cmd_parse_att2:
;Parse ATT2 attenuator codes from an M62419FP command packet.
;
;Reads command in packet_work_buf.
;Stores 2-bit ATT1 code in R16.
;
    ;2-bit ATT2 code is made up of bits 5-6 of the low byte
    ;Shift into the lower 2 bits of a byte, store it in att2_code
    lds r16, packet_work_buf    ;Read low byte
    swap r16
    lsr r16
    andi r16, 0b00000011
    ret


cmd_calc_att1_db:
;Calculate ATT1 value in dB from ATT1 code.
;Infinity (ATT1 code 0) is returned as 100 dB.
;ATT1 codes undefined in the datasheet are returned as 0xFF dB.
;
;Reads 5-bit ATT1 code from R16.
;Stores attenuation value of ATT1 (dB) in R16.
;
    cpi r16, 0x20
    brsh ca1_invalid            ;Branch if 0x20 or higher (out of range)

    push ZH
    push ZL

    ldi ZL, low(ca1_att1_to_db * 2)   ;Base address of ATT1 to dB table
    ldi ZH, high(ca1_att1_to_db * 2)

    add ZL, r16                 ;Add index to table base address
    clr r16
    adc ZH, r16
    lpm r16, Z                  ;Read dB value from table

    pop ZL
    pop ZH

    ret                         ;Return dB value in R16

ca1_invalid:
    ldi r16, 0xff               ;0xFF dB = undefined
    ret                         ;Return dB value in R16

ca1_att1_to_db:
    .db  100,   20,   52, 0xff,   68,   4,    36, 0xff  ; 100 = infinity
    .db   76,   12,   44, 0xff,   60, 0xff,   28, 0xff  ;0xff = undefined
    .db   80,   16,   48, 0xff,   64,    0,   32, 0xff
    .db   72,    8,   40, 0xff,   56, 0xff,   24, 0xff


cmd_calc_att2_db:
;Calculate ATT2 value in dB from ATT2 code.
;ATT2 codes undefined in the datasheet are returned as 0xFF dB.
;
;Reads 2-bit ATT2 code from R16.
;Returns attenuation value of ATT2 (db) in R16.
;Destroys R17.
;
    cpi r16, 0x04
    brsh ca2_invalid            ;Branch if 0x04 or higher (out of range)

    ldi r17, 3
    cpi r16, 0x00               ;ATT2 code 0x00 = 3 dB
    breq ca2_done

    ldi r17, 0
    cpi r16, 0x03               ;ATT2 code 0x03 = 0 dB
    breq ca2_done

    mov r17, r16                ;ATT2 code 0x01 = 1 dB, ATT2 code 0x02 = 2 dB
    rjmp ca2_done

ca2_invalid:
    ldi r17, 0xff               ;0xFF = undefined

ca2_done:
    mov r16, r17                ;Return dB value in R16
    ret


cmd_calc_att_sum_db:
;Calculate the total attenuation of ATT1 and ATT2 in dB.
;If either is undefined (0xFF), the sum is undefined (0xFF).
;
;Reads 5-bit ATT1 code from R16
;Reads 2-bit ATT2 code from R17
;Returns total attenuation in R16.  R17 unchanged.
;
    cpi r16, 0xff               ;Is ATT1 undefined?
    breq cas_invalid            ;  Yes: sum will also be undefined

    cpi r17, 0xff               ;Is ATT2 undefined?
    breq cas_invalid            ;  Yes: sum will also be undefined

    add r16, r17                ;ATT1 and ATT2 are valid, so add them
    rjmp cas_done

cas_invalid:
    ldi r16, 0xff               ;0xFF = undefined

cas_done:
    ret                         ;Return dB value in R16
