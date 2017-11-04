;MB89623R
;  628
;9910 Z18

    .F2MC8L
    .area CODE1 (ABS)
    .org 0xe000

;1  disp_data_out    P46/SO2    (FIS 3LB data out)
;2  disp_ena_in      P47/SI2    (FIS 3LB enable in)
;62 disp_ena_out     P43        (FIS 3LB enable out)
;64 disp_clk_out     P45/SCK2   (FIS 3LB clock out)

    pdr0 = 0x00             ;port 0 data register
    ddr0 = 0x01             ;port 0 data direction register
    pdr1 = 0x02             ;port 1 data register
    ddr1 = 0x03             ;port 1 data direction register
    pdr2 = 0x04             ;port 2 data register
    wdtc = 0x09             ;watchdog timer control register
    tbtc = 0x0a             ;timebase timer control register
    pdr3 = 0x0c             ;port 3 data register
    ddr3 = 0x0d             ;port 3 data direction register
    pdr4 = 0x0e             ;port 4 data register
    bzcr = 0x0f             ;buzzer register
    pdr5 = 0x10             ;port 5 data register
    pdr6 = 0x11             ;port 6 data register
    cntr = 0x12             ;pwm control register
    comr = 0x13             ;pwm compare register
    pcr1 = 0x14             ;pwc pulse width control register 1
    pcr2 = 0x15             ;pwc pulse width control register 2
    rlbr = 0x16             ;pwc reload buffer register
    tmcr = 0x18             ;16-bit timer control register
    tchr = 0x19             ;16-bit timer count register (high)
    tclr = 0x1a             ;16-bit timer count register (low)
    smr1 = 0x1c             ;serial i/o 1 mode register
    sdr1 = 0x1d             ;serial i/o 1 data register
    smr2 = 0x1e             ;serial i/o 2 mode register
    sdr2 = 0x1f             ;serial i/o 2 data register
    adc1 = 0x20             ;a/d converter control register 1
    adc2 = 0x21             ;a/d converter control register 2
    adcd = 0x22             ;a/d converter data register
    eic1 = 0x24             ;external interrupt 1 control register 1
    eic2 = 0x25             ;external interrupt 1 control register 2
    ilr1 = 0x7c             ;interrupt level setting register 1
    ilr2 = 0x7d             ;interrupt level setting register 2
    ilr3 = 0x7e             ;interrupt level setting register 3

table_e000:
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    .byte 0x98, 0x11, 0x17, 0x02, 0x02, 0x45, 0x08, 0x02
    .byte 0x12, 0x09

reset_e012:
    mov pdr0, #0xf3
    mov ddr0, #0x07
    mov pdr1, #0xbf
    mov ddr1, #0x40
    mov pdr2, #0x01
    mov pdr3, #0x3f
    mov ddr3, #0xf4
    mov pdr4, #0xff
    mov pdr5, #0xff
    mov pdr6, #0xff

    movw ix, #0x0080
ram_test_loop:
    mov a, #0x00
    mov @ix+0x00, a
    incw ix
    movw a, ix
    movw a, #0x027f
    cmpw a
    bne ram_test_loop

    movw a, #0x027f
    movw sp, a
    movw a, #0x0030
    movw ps, a
    mov a, #0x0a
    .byte 0x61, 0x00, 0xd1  ;mov 0x00d1, a
    mov a, #0x20
    .byte 0x61, 0x00, 0x8a  ;mov 0x008a, a
    mov 0xaa, #0x09
    call sub_e0b8
    call sub_e1c0
    mov 0x98, #0x05
    mov a, #0x05
    mov 0x013a, a
    mov a, #0x14
    mov 0x0145, a
    mov a, #0x14
    .byte 0x61, 0x00, 0xc9  ;mov 0x00c9, a

main_loop:
    bbc 0x00a9:7, lab_e075
    bbs 0x00a9:6, lab_e075
    call upd_init_and_clear ;Initialize uPD16432B and clear display

lab_e075:
    call sub_fa59
    call sub_e40c
    bbc 0x0088:0, lab_e086  ;Branch if "key data ready" flag is clear
    clrb 0x88:0             ;Clear "key data ready" flag for next time
    call parse_upd_key_data ;Parse 4 bytes of key data from uPD16432B
    jmp lab_e089

lab_e086:
    call try_parse_mfsw     ;Try to get a key code from MFSW

lab_e089:
    bbc 0x00a9:6, lab_e08f
    call upd_init_and_write ;Initialize uPD16432B and write all data

lab_e08f:
    call sub_f3c7
    call sub_e20a
    call m2s_cmd_process    ;Process a Main-to-Sub command packet if one is ready
    call m2s_update_display ;Process Main-to-Sub display update command if one was received
    call sub_f1ac           ;TODO seems FIS related
    call sub_f6df           ;TODO seems ADC related
    call sub_f541
    call upd_lcd_on_off     ;Turn upD16432B LCD on or off based on flags
    jmp main_loop


upd_lcd_on_off:
;Turn uUP16432B LCD enable on or off based on flags
    mov a, 0x013a           ;TODO what is 0x013a?
    bnz lab_e0b2
    bbc 0x009c:1, lab_e0b5  ;Branch if "play dead" flag is clear
lab_e0b2:
    ;Playing dead
    clrb pdr0:3             ;UPD_OE = low (turn off uPD16432B LCD display)
    ret
lab_e0b5:
    ;Not playing dead
    setb pdr0:3             ;UPD_OE = high (turn on uPD16432B LCD display)
    ret


sub_e0b8:
    movw a, ps              ;Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;  R0=0x100, R1=0x101...
    andw a
    movw ps, a

    call sub_f59f
    call sub_f5c3
    call sub_f5ec
    call sub_f617
    ret

irq7_e0cb:
;irq7 (8-bit serial I/O #1)
;Fires when a new byte has been received on Main-to-Sub SPI bus
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb smr1:7
    call sub_e2ff
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

irq6_e0dd:
;irq6 (16-bit timer/counter)
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb tmcr:2
    call sub_e437
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

irq5_e0ef:
;irq5 (pulse width count timer)
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb pcr1:2
    movw a, #0x0000
    mov a, 0xaa
    bz lab_e107
    decw a
    mov 0xaa, a
    bnz lab_e107
    setb pdr1:6             ;TODO what is pdr1:6?
    setb 0xa9:7

lab_e107:
    mov a, #0x80
    xor a, 0xd2
    mov 0xd2, a
    call sub_e2b2
    bbc 0x00d2:7, lab_e14a
    call sub_fa10
    bbs pdr3:0, lab_e151    ;Branch if /M2S_ENA_IN = high
    bbs 0x009b:1, lab_e12d
    setb 0x9b:1
    mov a, #0x05
    mov 0xcb, a

    mov a, #0x00            ;Reset count of bytes received from Main-MCU
    mov 0x0122, a

    clrb smr1:0
    nop
    nop
    setb smr1:0

lab_e12d:
    mov a, 0xc4
    beq lab_e134
    decw a
    mov 0xc4, a

lab_e134:
    mov a, 0xca
    beq lab_e13b
    decw a
    mov 0xca, a

lab_e13b:
    mov a, 0xc8
    beq lab_e142
    decw a
    mov 0xc8, a

lab_e142:
    bbc pdr4:7, lab_e156    ;Branch if DISP_ENA_IN = low
    mov a, 0xc5
    incw a
    mov 0xc5, a

lab_e14a:
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

lab_e151:
    clrb 0x9b:1
    jmp lab_e12d

lab_e156:
;DISP_ENA_IN is low
    mov a, 0xc5
    beq lab_e14a
    mov 0xc6, a
    mov a, #0x00
    mov 0xc5, a
    jmp lab_e14a

irq4_e163:
;irq4 (8-bit pwm timer)
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb cntr:2
    call sub_f6c1
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

irq3_e175:
;irq3 (external interrupt #3)
;diag ill input
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb eic2:7
    call sub_f44b
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

irq2_e187:
;irq2 (external interrupt #2)
;clipping input
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb eic2:3
    call sub_f693
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

irq0_e199:
;irq0 (external interrupt #0)
;mfsw input
    pushw a
    xchw a, t
    pushw a
    pushw ix
    movw a, ep
    pushw a
    clrb eic1:3
    call sub_e34e
    popw a
    movw ep, a
    popw ix
    popw a
    xchw a, t
    popw a
    reti

    .byte 0x60              ;e1ab  60          DATA '`'
    .byte 0x01              ;e1ac  01          DATA '\x01'
    .byte 0x4D              ;e1ad  4d          DATA 'M'
    .byte 0xFC              ;e1ae  fc          DATA '\xfc'
    .byte 0x08              ;e1af  08          DATA '\x08'
    .byte 0xAA              ;e1b0  aa          DATA '\xaa'
    .byte 0x0C              ;e1b1  0c          DATA '\x0c'
    .byte 0x04              ;e1b2  04          DATA '\x04'
    .byte 0xFF              ;e1b3  ff          DATA '\xff'
    .byte 0x61              ;e1b4  61          DATA 'a'
    .byte 0x01              ;e1b5  01          DATA '\x01'
    .byte 0x4D              ;e1b6  4d          DATA 'M'
    .byte 0x20              ;e1b7  20          DATA ' '
    .byte 0xA2              ;e1b8  a2          DATA '\xa2'
    .byte 0x0C              ;e1b9  0c          DATA '\x0c'
    .byte 0x04              ;e1ba  04          DATA '\x04'
    .byte 0x00              ;e1bb  00          DATA '\x00'
    .byte 0x61              ;e1bc  61          DATA 'a'
    .byte 0x01              ;e1bd  01          DATA '\x01'
    .byte 0x4D              ;e1be  4d          DATA 'M'
    .byte 0x20              ;e1bf  20          DATA ' '


sub_e1c0:
    mov tbtc, #0x00
    mov wdtc, #0x00
    mov cntr, #0x00
    mov comr, #0x00
    mov rlbr, #0x1f
    mov pcr2, #0x08
    mov pcr1, #0xa0
    mov tchr, #0x00
    mov tclr, #0x00
    mov tmcr, #0x03
    mov sdr1, #0x00
    mov smr1, #0x4f
    mov sdr2, #0x00
    mov smr2, #0x3a
    mov bzcr, #0x00
    mov eic1, #0x01
    bbs pdr6:1, lab_e1f6        ;CLIPPING
    mov eic1, #0x21

lab_e1f6:
    mov eic2, #0x10
    mov adc1, #0x00
    mov adc2, #0x01
    mov ilr1, #0xa9
    mov ilr2, #0x9a
    mov ilr3, #0xfe
    seti
    ret

sub_e20a:
    call sub_e24e
    bbs 0x009a:0, lab_e24d
    bbs 0x009b:6, lab_e24d
    bbc 0x009a:4, lab_e24d
    clrb 0x9a:4

    mov a, 0x8a
    mov 0x0109, a

    mov a, 0x9e
    mov 0x010a, a

    mov a, 0x013b
    mov 0x010b, a

    mov a, 0x0146
    mov 0x010c, a

    movw a, 0x0109
    movw 0x010e, a
    movw a, 0x010b
    movw 0x0110, a

    mov a, #0x20
    mov 0x0114, a
    mov a, #0x0a
    mov 0x9f, a
    setb 0x9b:6
    clrb 0x9b:7
    clrb 0x9c:2
    setb 0x9a:0
    setb 0x9c:0

lab_e24d:
    ret

sub_e24e:
    bbc 0x0088:1, lab_e261
    bbs 0x009a:0, lab_e260
    clrb 0x88:1
    setb 0x9a:4
    clrb 0x9b:3
    setb 0x9b:2
    mov a, #0x0a
    mov 0x9d, a

lab_e260:
    ret

lab_e261:
    bbc 0x009b:0, lab_e260
    bbs 0x009a:0, lab_e260
    clrb 0x9b:0
    setb 0x9a:4
    jmp lab_e260


m2s_cmd_process:
;Process a Main-to-Sub command packet if one is ready
;
    bbc 0x009a:3, m2s_cmd_done  ;Branch if "Main-MCU packet ready" flag is clear
    ;A command packet is ready
    clrb 0x9a:3             ;Clear "Main-MCU packet ready" flag for next time
    mov a, 0x0115           ;A = first byte of Main-MCU packet (command byte)
    and a, #0xf0            ;Mask to leave only high nibble
    cmp a, #0x80            ;High nibble = 0x80?
    beq m2s_cmd_dispatch    ;Yes: probably valid command, try to dispatch it
                            ;No: not a valid command, do nothing
m2s_cmd_done:
    ret

m2s_cmd_dispatch:
;Try to dispatch a Main-to-Sub command from the current packet
;
    mov a, 0x0115           ;A = command byte from packet

    cmp a, #0x81            ;0x81 = Write to both LCD and FIS
    beq m2s_cmd_81

    cmp a, #0x82            ;0x82 = Write only to FIS (used during KW1281 output tests)
    beq m2s_cmd_82

    cmp a, #0x83            ;0x83 = Power off? TODO?
    beq m2s_cmd_83

    jmp m2s_cmd_done        ;Other = invalid comment, do nothing

m2s_cmd_81:
;Handle Main-to-Sub command 0x81 (Write to both LCD and FIS)
;A = 0x81
    clrb 0xab:4             ;Clear "write to FIS only flag"

lab_e291:
    ;Copy 0x0116-0x011a to 0x011c-0x0120
    movw a, 0x0116
    movw 0x011c, a          ;Copy 0x0116-0x0117 to 0x011c-0x011d
    movw a, 0x0118
    movw 0x011e, a          ;Copy 0x0118-0x0119 to 0x011e-0x011f
    mov a, 0x011a
    mov 0x0120, a           ;Copy 0x011a to 0x0120

    setb 0x9a:7             ;Set "display command ready" flag
    jmp m2s_cmd_done

m2s_cmd_82:
;Handle Main-to-Sub command 0x82 = Write only to FIS (used during KW1281 output tests)
;A = 0x82
    setb 0xab:4             ;Set "write to FIS only" flag
    jmp lab_e291

m2s_cmd_83:
;Handle Main-to-Sub command 0x83 = Play dead (act like powered off)
;A = 0x83
    setb 0x9c:1             ;Set "play dead" flag
    jmp m2s_cmd_done


sub_e2b2:
;called from irq5_e0ef: irq5 (pulse width count timer)
    bbc 0x009a:0, lab_e2db
    bbc 0x009c:2, lab_e2f8
    bbc 0x009c:0, lab_e2e1
    clrb 0x9c:0
    clrb pdr3:4             ;/S2M_CLK_OUT = low
    clrc

    movw ix, #0x010e
    mov a, @ix+0x03         ;0x0111
    rolc a

    mov @ix+0x03, a
    mov a, @ix+0x02         ;0x0110
    rolc a

    mov @ix+0x02, a
    mov a, @ix+0x01         ;0x010f
    rolc a

    mov @ix+0x01, a
    mov a, @ix+0x00         ;0x010e
    rolc a

    mov @ix+0x00, a
    bnc lab_e2dc
    setb pdr3:5             ;S2M_DATA_OUT = high
lab_e2db:
    ret
lab_e2dc:
    clrb pdr3:5             ;S2M_DATA_OUT = low
    jmp lab_e2db

lab_e2e1:
    setb 0x9c:0
    movw a, #0x0000
    mov a, 0x0114
    decw a
    mov 0x0114, a
    bne lab_e2f3
    clrb 0x9a:0
    setb pdr2:0             ;/S2M_ENA_OUT = high

lab_e2f3:
    setb pdr3:4             ;/S2M_CLK_OUT = high
    jmp lab_e2db

lab_e2f8:
    clrb pdr2:0             ;/S2M_ENA_OUT = low
    setb 0x9c:2
    jmp lab_e2db


sub_e2ff:
;called from irq7 (8-bit serial I/O #1)
;Fires when a new byte has been received on Main-to-Sub SPI bus
    bbc 0x009a:2, lab_e307

    mov a, #0x00            ;Reset count of bytes received from Main-MCU
    mov 0x0122, a

lab_e307:
    mov a, #0x04
    mov 0x0121, a
    setb 0x9a:1
    clrb 0x9a:2

    movw ix, #0x0115

    movw a, @ix+0x01        ;Shift existing buffer bytes to the left
    movw @ix+0x00, a
    movw a, @ix+0x03
    movw @ix+0x02, a
    mov a, @ix+0x05
    mov @ix+0x04, a

    mov a, sdr1             ;A = byte from M2S_DATA_IN
    mov @ix+0x05, a         ;Store as 6th byte in the buffer

    setb smr1:0

    mov a, 0x0122           ;Increment count of bytes received from Main-MCU
    incw a
    mov 0x0122, a

    mov a, #0x06
    cmp a                   ;6 bytes received from Main-MCU?
    bne lab_e339            ;No: branch to lab_e339
    setb 0x9a:3             ;Yes: set "Main-MCU packet ready" flag

lab_e333:
    mov a, #0x00            ;Reset count of bytes received from Main-MCU
    mov 0x0122, a

lab_e338:
    ret

lab_e339:
    mov a, 0x0122
    cmp a, #0x01            ;1 byte received from Main-MCU?
    bne lab_e338            ;No: branch to return

    ;1 byte received from Main-MCU
    movw ix, #0x0115
    mov a, @ix+0x05         ;A = byte from Main-MCU

    and a, #0xf0
    cmp a, #0x80
    beq lab_e338
    jmp lab_e333

sub_e34e:
;called from irq0_e199: irq0 (external interrupt #0)
;mfsw input changed
    mov a, 0x0126
    bne lab_e35e
    movw a, tchr
    movw 0x0124, a
    mov a, #0x01
    mov 0x0126, a

lab_e35d:
    ret

lab_e35e:
    call sub_e364
    jmp lab_e35d

sub_e364:
;mfsw got bit
    mov a, 0x0126
    incw a
    mov 0x0126, a
    movw a, tchr
    movw a, 0x0124
    clrc
    subcw a
    movw 0x012d, a
    movw a, tchr
    movw 0x0124, a

    movw a, 0x012d
    movw a, #0x9c40
    cmpw a
    blo lab_e389

    mov a, #0x01
    mov 0x0126, a

lab_e388:
    ret

lab_e389:
;0x012d < #0x9c40
    movw a, 0x012d
    movw a, #0x60ae
    cmpw a
    blo lab_e395
    jmp lab_e388            ;return

lab_e395:
;0x012d < #0x60ae
    movw a, 0x012d
    movw a, #0x34b2
    cmpw a
    blo lab_e3ab

;0x012d >= #0x34b2
    bbc 0x00a0:3, lab_e3a3
    setb 0xa0:7

lab_e3a3:
    mov a, #0x00
    mov 0x0126, a
    jmp lab_e388            ;return

lab_e3ab:
;0x012d < #0x34b2
    movw a, 0x012d
    movw a, #0x0d20
    cmpw a
    blo lab_e3bb
    setc

lab_e3b5:
    call sub_e3bf
    jmp lab_e388            ;return

lab_e3bb:
    clrc
    jmp lab_e3b5

sub_e3bf:
;New MFSW bit received; it's in the carry flag
;
;MFSW buffer is 0x0129 - 0x012C
;
;                0x012c  0x012b  0x012a  0x0129
;                ------  ------  ------  ------
;Volume Down      0x41    0xE8    0x00    0xFF      Thought it was these values
;Volume Up        0x41    0xE8    0x80    0x7F
;Down             0x41    0xE8    0x50    0xAF
;Up               0x41    0xE8    0xD0    0x2F
;
;Volume Down      0x82    0x17    0x00    0xFF      Code seems to want this
;Volume Up        0x82    0x17    0x01    0xFE
;Down             0x82    0x17    0x0a    0xF5
;Up               0x82    0x17    0x0b    0xF4
;
    mov a, 0x0129           ;rotate
    rorc a
    mov 0x0129, a

    mov a, 0x012a           ;rotate
    rorc a
    mov 0x012a, a

    mov a, 0x012b           ;rotate
    rorc a
    mov 0x012b, a

    mov a, 0x012c           ;rotate
    rorc a
    mov 0x012c, a

    mov a, 0x0126           ;compare count of bits received?
    cmp a, #0x22
    bne lab_e406            ;branch if != 34 bits

    movw a, 0x012b          ;compare first two bytes in packet
    movw a, #0x1782
    cmpw a
    bne lab_e407            ;branch if != 0x1782

    setb 0xa0:3

    mov a, 0x0129
    mov a, 0x012a
    xor a
    incw a
    cmp a, #0x00
    bne lab_e401            ;checksum failed?

    ;Checksum passed
    mov a, 0x012a           ;A = byte at 0x012a (MFSW key code)
    mov 0x0128, a           ;Save MFSW key code in 0x128
    setb 0xa0:0

lab_e401:
    mov a, #0x00
    mov 0x0126, a

lab_e406:
    ret

lab_e407:
;checksum didn't match?
    clrb 0xa0:3
    jmp lab_e401

sub_e40c:
    bbc 0x00a0:0, lab_e41d
    clrb 0xa0:0

    mov a, 0x0128           ;Copy 0x128 to 0x127
    mov 0x0127, a

lab_e417:
    mov a, #0x0f
    mov 0x0123, a

lab_e41c:
    ret

lab_e41d:
    bbc 0x00a0:7, lab_e42f
    clrb 0xa0:7
    mov a, 0x0123
    bne lab_e417

lab_e427:
    mov a, #0xff
    mov 0x0127, a
    jmp lab_e41c            ;jmp to ret

lab_e42f:
    mov a, 0x0123
    beq lab_e427
    jmp lab_e41c

sub_e437:
;called from irq6_e0dd: irq6 (16-bit timer/counter)
    mov a, 0x014a
    incw a
    mov 0x014a, a
    ret


make_upd_text:
;Convert 11 byte buffer at 0x012f-0x139 from ASCII to uPD16432B chars
;
    movw ep, #0x012f+0
    call ascii_to_upd       ;Replace ASCII char at 0x012f with uPD16432B char
    movw ep, #0x012f+1
    call ascii_to_upd       ;Replace ASCII char at 0x0130 with uPD16432B char
    movw ep, #0x012f+2
    bbs 0x00a9:1, lab_e457  ;Branch if "mode or preset digits" flag is set
    call ascii_to_upd       ;Replace ASCII char at 0x0131 with uPD16432B char
    jmp lab_e45a
lab_e457:
    call ascii_to_upd_fm12  ;Replace ASCII char at @ep for uPD16432B char for FM1/2
lab_e45a:
    movw ep, #0x012f+3
    bbs 0x00a9:1, lab_e466  ;Branch if "mode or preset digits" flag is set
    call ascii_to_upd       ;Replace ASCII char at 0x0132 with uPD16432B char
    jmp lab_e469            ;Jump to convert buffer at 0x0133-0x139 from ASCII to uPD16432B
lab_e466:
    call ascii_to_upd_preset ;Replace ASCII char at @ep with uPD16432B char for station presets
lab_e469:
    movw ep, #0x012f+4
    call ascii_to_upd       ;Replace ASCII char at 0x0133 with uPD16432B char
    movw ep, #0x012f+5
    call ascii_to_upd       ;Replace ASCII char at 0x0134 with uPD16432B char
    movw ep, #0x012f+6
    call ascii_to_upd       ;Replace ASCII char at 0x0135 with uPD16432B char
    movw ep, #0x012f+7
    call ascii_to_upd       ;Replace ASCII char at 0x0136 with uPD16432B char
    movw ep, #0x012f+8
    call ascii_to_upd       ;Replace ASCII char at 0x0137 with uPD16432B char
    movw ep, #0x012f+9
    call ascii_to_upd       ;Replace ASCII char at 0x0138 with uPD16432B char
    movw ep, #0x012f+10
    call ascii_to_upd       ;Replace ASCII char at 0x0139 with uPD16432B char

    bbs 0x00ab:4, lab_e49a  ;Branch if "write to FIS only" flag is set
    setb 0x87:2
    setb 0xab:5
lab_e49a:
    ret


ascii_to_upd:
;Replace the ASCII char at @ep with its equivalent upd16432B char.
;
    mov a, @ep
    mov a, #0x20
    cmp a
    blo lab_e4b7
    mov a, @ep
    mov a, #0x7b
    cmp a
    bhs lab_e4b7
    movw a, #0x0000
    mov a, @ep
    mov a, #0x20
    clrc
    subc a
    movw a, #ascii_to_upd_table
    clrc
    addcw a
    mov a, @a
    mov @ep, a
    ret

lab_e4b7:
    mov @ep, #0x20
    ret

ascii_to_upd_table:
    ;e4ba '........'
    .byte 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
    ;e4c2 '........'
    .byte 0x20, 0x20, 0x20, 0x2b, 0x20, 0x2d, 0x20, 0x20
    ;e4ca '.......7'
    .byte 0xe4, 0xe5, 0xf3, 0xe6, 0xe7, 0xe8, 0xe9, 0x37
    ;e4d2 '8.......'
    .byte 0x38, 0xea, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
    ;e4da '...CDEFG'
    .byte 0x20, 0xe0, 0xe1, 0x43, 0x44, 0x45, 0x46, 0x47
    ;e4e2 'HIJKLM.O'
    .byte 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0xe2, 0x4f
    ;e4ea 'PQRSTU.W'
    .byte 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0xe3, 0x57
    ;e4f2 'XYZ.....'
    .byte 0x58, 0x59, 0x5a, 0x20, 0x20, 0x20, 0x20, 0x20
    ;e4fa '.abcdefg'
    .byte 0x20, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67
    ;e502 'hijklmno'
    .byte 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f
    ;e50a 'pqrstuvw'
    .byte 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77
    ;e602 'xyz'
    .byte 0x78, 0x79, 0x7a

ascii_to_upd_fm12:
;Replace ASCII char at @ep with uPD16432B char for FM1/2
;  ASCII "1" becomes uPD16432B "1" for FM1
;  ASCII "2" becomes uPD16432B "2" for FM2
;  Anything else becomes a space
;
    mov a, @ep
    mov a, #'1
    cmp a
    blo lab_e531            ;Branch if ASCII char at @ep < '1'

    mov a, @ep
    mov a, #'3
    cmp a
    bhs lab_e531            ;Branch if ASCII char at @ep >= '3'

    movw a, #0x0000         ;Convert ASCII '1'-'2' to binary 0-1
    mov a, @ep
    mov a, #'1
    clrc
    subc a

    movw a, #upd_fm12       ;Look up uPD16432B char "1" for FM1 or "2" for FM2
    clrc
    addcw a
    mov a, @a
    mov @ep, a              ;Store char at pointer
    ret
lab_e531:
    mov @ep, #0x20          ;Store space at pointer (out of range)
    ret
upd_fm12:
    .byte 0xEB              ;uPD16432B char "1" for FM1
    .byte 0xEC              ;uPD16432B char "2" for FM2


ascii_to_upd_preset:
;Replace ASCII char at @ep with uPD16432B char for station presets
;  ASCII "1" to "6" becomes uPD16432B "1" to "6"
;  Anything else becomes a space
;
    mov a, @ep
    mov a, #'1
    cmp a
    blo lab_e552            ;Branch if ASCII char at @ep < '1'

    mov a, @ep
    mov a, #'7
    cmp a
    bhs lab_e552            ;Branch if ASCII char at @ep >= '7'

    movw a, #0x0000         ;Convert ASCII '1'-'6' to binary 0-5
    mov a, @ep
    mov a, #'1
    clrc
    subc a

    movw a, #upd_presets    ;Look up uPD16432B char for preset
    clrc
    addcw a
    mov a, @a
    mov @ep, a              ;Store char at pointer
    ret
lab_e552:
    mov @ep, #0x20          ;Store space at pointer (out of range)
    ret
upd_presets:
    .byte 0xE5              ;uPD16432B char "1" for preset 1
    .byte 0xED              ;uPD16432B char "2" for preset 2
    .byte 0xEE              ;uPD16432B char "3" for preset 3
    .byte 0xEF              ;uPD16432B char "4" for preset 4
    .byte 0xF0              ;uPD16432B char "5" for preset 5
    .byte 0xF2              ;uPD16432B char "6" for preset 6


m2s_update_display:
;Process Main-to-Sub display update command (0x81 or 0x82) if one was received.
;The command byte is not saved.  The 5 bytes after the command are in 0x011c-0x0120.
;
; none  Byte 0: Command byte was 0x81 or 0x82
;0x011c Byte 1: Pictographs byte
;0x011d Byte 2: Display Number
;0x011e Byte 3: Display Param 0
;0x011f Byte 4: Display Param 1
;0x0120 Byte 5: Display Param 2
;
;Writes 16 bytes of FIS display data to 0x00d7-0x00e6.
;Writes 11 bytes of uPD16432B display data to 0x012f-0x139.
;Writes 8 bytes of uPD16432B pictograph data to 0x00a1-0x00a8.
;
    movw a, ps              ;Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;  R0=0x100, R1=0x101...
    andw a
    movw ps, a

    bbc 0x009a:7, lab_e57f  ;Branch if "display command ready" flag is clear
    clrb 0x9a:7             ;Clear "display command ready" for next time
    setb 0x9c:3
    clrb 0xa9:0             ;Clear "show period" flag
    clrb 0xa9:1             ;Clear "mode or preset digits" flag

    movw ep, #0x011d        ;EP = pointer to Display Number in command packet
    mov a, @ep              ;A = display number

    bz lab_e5d0             ;Branch if A = 0 (vw-car message)

    cmp a, #0x10
    bhs lab_e580
    call msgs_01_0f         ;Call if A >= 0x01 and A <= 0x0F (cd messages)

lab_e579:
    call make_upd_picts     ;Parse pictograph byte; set uPD16432B bytes at 0x00a1-0x00a8.
    call make_upd_text      ;Convert buffer at 0x012f-0x139 from ASCII to uPD16432B chars

lab_e57f:
    ret

lab_e580:
;A >= 0x10
    cmp a, #0x20
    bhs lab_e58a
    call msgs_10_1f         ;Call if A >= 0x10 and A <= 0x1F ("set" messages)
    jmp lab_e579

lab_e58a:
;A >= 0x20
    cmp a, #0x40
    bhs lab_e594
    call msgs_20_3f         ;Call if A >= 0x20 and A <= 0x3F (test mode messages)
    jmp lab_e579

lab_e594:
;A >= 0x40
    cmp a, #0x50
    bhs lab_e59e
    call msgs_40_4f         ;Call if A >= 0x40 and A <= 0x4F (tuner messages)
    jmp lab_e579

lab_e59e:
;A >= 0x50
    cmp a, #0x60
    bhs lab_e5a8
    call msgs_50_5f         ;Call if A >= 0x50 and A <= 0x5F (tape messages)
    jmp lab_e579

lab_e5a8:
;A >= 0x60
    cmp a, #0x80
    bhs lab_e5b2
    call msgs_60_7f         ;Call if A >= 0x60 and A <= 0x7F (sound messages)
    jmp lab_e579

lab_e5b2:
;A >= 0x80
    cmp a, #0xb0
    bhs lab_e5bc
    call msgs_80_af         ;Call if A >= 0x80 and A <= 0xAF (code messages)
    jmp lab_e579

lab_e5bc:
;A >= 0xb0
    cmp a, #0xc0
    bhs lab_e5c6
    call msgs_b0_bf         ;Call if A >= 0xB0 and A < 0xBF (diag messages)
    jmp lab_e579

lab_e5c6:
;A >= 0xC0
    cmp a, #0xd0
    bhs lab_e5d0
    call msgs_c0_cf         ;Call if A >= 0xC0 and A < 0xCF (bose messages)
    jmp lab_e579

lab_e5d0:
;A = 0 or A >= 0xD0
    call msgs_00_or_gte_d0  ;Call if A = 0 or A >= 0xD0 (vw-car message)
    jmp lab_e579


make_upd_picts:
;Parse pictographs byte in command packet into 8 uPD16432B
;pictograph bytes at 0x00a1-0x00a8
;
    ;Clear 8 uPD16432B pictograph bytes 0x00a1-0x00a8
    movw ix, #0x00a1        ;IX = pointer to uPD16432B pictograph data
    movw a, #0x0000         ;A = 0x0000
    movw @ix+0x00, a        ;Clear 8 pictograph bytes
    movw @ix+0x02, a
    movw @ix+0x04, a
    movw @ix+0x06, a

    movw ep, #0x011c        ;EP = pointer to pictographs byte in command packet
    mov a, @ep              ;A = pictographs byte

    ;Pictograph byte bit 0 = METAL
    rorc a                  ;Pictograph byte bit 0
    bnc lab_e5ed            ;Branch if not set
    setb 0xa1+7:3           ;Set METAL bit in uPD16432B pictograph bytes

lab_e5ed:
    ;Pictograph byte bit 1 = MIX
    rorc a                  ;Pictograph byte bit 1
    bnc lab_e5f2            ;Branch if not set
    setb 0xa1+6:0           ;Set MIX bit in uPD16432B pictograph bytes

lab_e5f2:
    ;Pictograph byte bit 2 = DOLBY
    rorc a                  ;Pictograph byte bit 2
    bnc lab_e5f7            ;Branch if not set
    setb 0xa1+6:5           ;Set DOLBY bit in uPD16432B pictograph bytes

lab_e5f7:
    ;Pictograph byte bit 3 = HIDDEN MODE AM/FM
    rorc a                  ;Pictograph byte bit 3
    bnc lab_e5fc            ;Branch if not set
    setb 0xa1+2:3           ;Set HIDDEN MODE AM/FM bit in uPD16432B pictograph bytes

lab_e5fc:
    ;Pictograph byte bit 4 = HIDDEN MODE CD
    rorc a                  ;Pictograph byte bit 4
    bnc lab_e601            ;Branch if not set
    setb 0xa1+1:0           ;Set HIDDEN MODE CD bit in uPD16432B pictograph bytes

lab_e601:
    ;Pictograph byte bit 5 = HIDDEN MODE TAPE
    rorc a                  ;Pictograph byte bit 5
    bnc lab_e606            ;Branch if not set
    setb 0xa1+1:5           ;Set HIDDEN MODE TAPE bit in uPD16432B pictograph bytes

lab_e606:
    ;Pictograph byte bit 6 = PERIOD
    ;Set if the byte in the pictograph is set or always set
    ;if the "show period" flag is set
    rorc a                  ;Pictograph byte bit 6
    bc lab_e60c             ;Branch to if set
    bbc 0x00a9:0, lab_e60e  ;Branch over if "show period" flag is clear
lab_e60c:
    setb 0xa1+3:6           ;Set PERIOD bit in uPD16432B pictograph bytes

lab_e60e:
    ret

msgs_01_0f:
;Called if A >= 0x01 and A <= 0x0F (cd messages)
;Called with EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep              ;A = Display Number
    mov a, #0x01
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_01_0f_text ;A = pointer to cd messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x0f
    bhs msgs_01_0f_done
    clrc
    rolc a
    movw a, #msgs_01_0f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_01_0f_jmp:
    .word msg_01_cd_tr       ;VECTOR   0x01  'CD...TR....'
    .word msg_02_cue         ;VECTOR   0x02  'CUE........'
    .word msg_03_rev         ;VECTOR   0x03  'REV........'
    .word msg_04_scancd_tr   ;VECTOR   0x04  'SCANCD.TR..'
    .word msg_05_no_changer  ;VECTOR   0x05  'NO..CHANGER'
    .word msg_06_no_magazin  ;VECTOR   0x06  'NO  MAGAZIN'
    .word msg_07_no_disc     ;VECTOR   0x07  '....NO.DISC'
    .word msg_08_cd_error    ;VECTOR   0x08  'CD...ERROR.'
    .word msg_09_cd_         ;VECTOR   0x09  'CD.........'
    .word msg_0a_cd_max      ;VECTOR   0x0A  'CD....MAX..'
    .word msg_0b_cd_min      ;VECTOR   0x0B  'CD....MIN..'
    .word msg_0c_chk_magazin ;VECTOR   0x0C  'CHK.MAGAZIN'
    .word msg_0d_cd_cd_err   ;VECTOR   0x0D  'CD..CD.ERR.'
    .word msg_0e_cd_error    ;VECTOR   0x0E  'CD...ERROR.'
    .word msg_0f_cd_no_cd    ;VECTOR   0x0F  'CD...NO.CD.'

msgs_01_0f_done:
    call make_fis_text
    ret

msg_01_cd_tr:
;Buffer:  'CD...TR....'
;Example: 'CD 1 TR 03 '
;
;Param 0 High Nibble = Unused
;Param 1 Low Nibble  = CD number
;Param 1 Byte        = Track number
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = CD as hex digit
    mov @ix+0x03, a         ;Store in buffer

    incw ep                 ;EP = pointer to Display Param 1
    mov a, @ep              ;A = Display Param 1 (Track)
    call hex_nib_high
    mov @ix+0x08, a

    mov a, @ep
    call hex_nib_low
    mov @ix+0x09, a
    jmp msgs_01_0f_done

msg_02_cue:
;Buffer:  'CUE........'
;Example: 'CUE   123  '
;Example: 'CUE  -123  '
;Example: 'CUE  1234  '
;
;Param 0 Byte        = Unused
;Param 1 High Nibble = Minutes tens place BCD; 0 shows " ", 0xA shows "-"
;Param 1 Low Nibble  = Minutes ones place BCD
;Param 2 Byte        = Seconds BCD
    incw ep                 ;EP = pointer to Display Param 1
    mov a, @ep              ;A = Display Param 1 (minutes)

    and a, #0xf0            ;Mask to leave only high nibble
    bz lab_e688             ;Branch if it is zero

    call hex_nib_high       ;A = ASCII digit for high nibble
    cmp a, #'A              ;Is it ASCII "A"?
    bne lab_e686            ;  No: Branch to skip changing to "-"

    mov a, #'-              ;A = ASCII "-"
lab_e686:
    mov @ix+0x05, a         ;Write minutes tens place or "-" into buffer

lab_e688:
    mov a, @ep              ;A = Display Param 1 (minutes)
    call hex_nib_low        ;A = ASCII digit for minutes ones place
    mov @ix+0x06, a         ;Write minutes tens place into buffer

    incw ep                 ;EP = pointer to Display Param 2 (seconds)
    mov a, @ep              ;A = Display Param 2 (seconds)
    call hex_nib_high       ;A = ASCII digit for seconds tens place
    mov @ix+0x07, a         ;Write seconds ones place into buffer

    mov a, @ep              ;A = Display Param 2 (seconds)
    call hex_nib_low        ;A = ASCII digit for seconds ones place
    mov @ix+0x08, a         ;Write seconds ones place into buffer
    jmp msgs_01_0f_done

msg_03_rev:
;Buffer:  'REV........'
;Example: 'REV   123  '
;Example: 'REV  -123  '
;Example: 'REV  1234  '
;
;Param 0 Byte        = Unused
;Param 1 High Nibble = Minutes tens place BCD; 0 shows " ", 0xA shows "-"
;Param 1 Low Nibble  = Minutes ones place BCD
;Param 2 Byte        = Seconds BCD
    jmp msg_02_cue

msg_04_scancd_tr:
;Buffer:  'SCANCD.TR..'
;Example: 'SCANCD1TR04'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Track number
;Param 2 Byte        = Unused
    mov a, @ep              ; A = Param 0 (CD)
    call hex_nib_low        ; A = ASCII digit for CD number
    mov @ix+0x06, a         ; Write CD number into the buffer

    incw ep                 ; EP = pointer to Param 1
    mov a, @ep              ; A = Param 1 (track)
    call hex_nib_high       ; A = ASCII digit for track number
    mov @ix+0x09, a         ; Write track number tens place into the buffer

    mov a, @ep              ; A = Param 1 (track)
    call hex_nib_low        ; A = ASCII digit for track number
    mov @ix+0x0a, a         ; Write track number ones place into the buffer
    jmp msgs_01_0f_done

msg_05_no_changer:
;Buffer:  'NO..CHANGER'
;Example: 'NO  CHANGER'
;
;No params
    jmp msgs_01_0f_done

msg_06_no_magazin:
;Buffer:  'NO..MAGAZIN'
;Example: 'NO  MAGAZIN'
;
;No params
    jmp msgs_01_0f_done

msg_07_no_disc:
;Buffer:  '....NO.DISC'
;Example: '    NO DISC'
;
;No params
    jmp msgs_01_0f_done

msg_08_cd_error:
;Buffer:  'CD...ERROR.'
;Example: 'CD 6 ERROR '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = ASCII digit for CD number
    mov @ix+0x03, a         ;Write digit into the buffer
    jmp msgs_01_0f_done

msg_09_cd_:
;Buffer:  'CD.........'
;Example: 'CD 6  123  '
;Example: 'CD 6 -123  '
;Example: 'CD 6 1234  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 High Nibble = Minutes tens place BCD; 0 shows " ", 0xA shows "-"
;Param 1 Low Nibble  = Minutes ones place BCD
;Param 2 Byte        = Seconds BCD
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = ASCII digit for CD number
    mov @ix+0x03, a         ;Write digit into the buffer
    jmp msg_02_cue

msg_0a_cd_max:
;Buffer:  'CD....MAX..'
;Example: 'CD 5  MAX  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = ASCII digit for CD number
    mov @ix+0x03, a         ;Write digit into the buffer
    jmp msgs_01_0f_done

msg_0b_cd_min:
;Buffer:  'CD....MIN..'
;Example: 'CD 5  MIN  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_0a_cd_max

msg_0c_chk_magazin:
;Buffer:  'CHK.MAGAZIN'
;Example: 'CHK MAGAZIN'
;
;No params
    jmp msgs_01_0f_done

msg_0d_cd_cd_err:
;Buffer:  'CD..CD.ERR.'
;Example: 'CD6 CD ERR '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = ASCII digit for CD number
    mov @ix+0x02, a         ;Write digit into the buffer
    jmp msgs_01_0f_done

msg_0e_cd_error:
;Buffer:  'CD...ERROR.'
;Example: 'CD   ERROR '
;
;No params
    jmp msgs_01_0f_done

msg_0f_cd_no_cd:
;Buffer:  'CD...NO.CD.'
;Example: 'CD 6 NO CD '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (CD)
    call hex_nib_low        ;A = ASCII digit for CD number
    mov @ix+0x03, a         ;Write digit into the buffer
    jmp msgs_01_0f_done

msgs_10_1f:
;Called if A >= 0x10 and A <= 0x1F ("set" messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x10
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_10_1f_text ;A = pointer to "set" messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep    ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x07
    bhs msgs_10_1f_done
    clrc
    rolc a
    movw a, #msgs_10_1f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_10_1f_jmp:
    .word msg_10_set_onvol_y ;VECTOR   0x10  'SET.ONVOL.Y'
    .word msg_11_set_onvol_n ;VECTOR   0x11  'SET.ONVOL.N'
    .word msg_12_set_onvol_  ;VECTOR   0x12  'SET.ONVOL..'
    .word msg_13_set_cdmix1  ;VECTOR   0x13  'SET.CD.MIX1'
    .word msg_14_set_cd_mix6 ;VECTOR   0x14  'SET.CD.MIX6'
    .word msg_15_tape_skip_y ;VECTOR   0x15  'TAPE.SKIP.Y'
    .word msg_16_tape_skip_n ;VECTOR   0x16  'TAPE.SKIP.N'

msgs_10_1f_done:
    call make_fis_text
    ret

msg_10_set_onvol_y:
;Buffer:  'SET.ONVOL.Y'
;Example: 'SET ONVOL Y'
;
;No params
    jmp msgs_10_1f_done

msg_11_set_onvol_n:
;Buffer:  'SET.ONVOL.N'
;Example: 'SET ONVOL N'
;
;No params
    jmp msgs_10_1f_done

msg_12_set_onvol_:
;Buffer:  'SET.ONVOL..'
;Example: 'SET ONVOL 5'
;Example: 'SET ONVOL63'
;
;Param 0 Byte = Level in binary
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep              ;A = Display Param 0 (Level)
    call bin_to_bcd         ;R7 = Level in BCD

    mov a, r7               ;A = Level in BCD
    and a, #0xf0            ;Mask to leave only tens place
    beq lab_e74c            ;Skip write if tens place is 0
    call hex_nib_high       ;A = ASCII digit for tens place
    mov @ix+0x09, a         ;Write ones place into buffer
lab_e74c:
    mov a, r7               ;A = Level in BCD
    call hex_nib_low        ;A = ASCII digit for ones place
    mov @ix+0x0a, a         ;Wriit ones place into buffer
    jmp msgs_10_1f_done

msg_13_set_cdmix1:
;Buffer:  'SET.CD.MIX1'
;Example: 'SET CD MIX1'
;
;No params
    jmp msgs_10_1f_done

msg_14_set_cd_mix6:
;Buffer:  'SET.CD.MIX6'
;Example: 'SET CD MIX6'
;
;No params
    jmp msgs_10_1f_done

msg_15_tape_skip_y:
;Buffer:  'TAPE.SKIP.Y'
;Example: 'TAPE SKIP Y'
;
;No params
    jmp msgs_10_1f_done

msg_16_tape_skip_n:
;Buffer:  'TAPE.SKIP.N'
;Example: 'TAPE SKIP N'
;
;No params
    jmp msgs_10_1f_done

msgs_20_3f:
;Called if A >= 0x20 and A <= 0x3F (test mode messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x20
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_20_3f_text ;A = pointer to test mode messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x18
    bhs msgs_20_3f_done
    clrc
    rolc a
    movw a, #msgs_20_3f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_20_3f_jmp:
    .word msg_20_rad_3cp_t7  ;VECTOR   0x20  'RAD.3CP.T7.'
    .word msg_21_ver         ;VECTOR   0x21  'VER........'
    .word msg_22_            ;VECTOR   0x22  '...........'
    .word msg_23_hc          ;VECTOR   0x23  'HC.........'
    .word msg_24_v           ;VECTOR   0x24  'V..........'
    .word msg_25_seekset_m   ;VECTOR   0x25  'SEEKSET.M..'
    .word msg_26_seekset_n   ;VECTOR   0x26  'SEEKSET.N..'
    .word msg_27_seekset_m1  ;VECTOR   0x27  'SEEKSET.M1.'
    .word msg_28_seekset_m2  ;VECTOR   0x28  'SEEKSET.M2.'
    .word msg_29_seekset_m3  ;VECTOR   0x29  'SEEKSET.M3.'
    .word msg_2a_seekset_n1  ;VECTOR   0x2A  'SEEKSET.N1.'
    .word msg_2b_seekset_n2  ;VECTOR   0x2B  'SEEKSET.N2.'
    .word msg_2c_seekset_n3  ;VECTOR   0x2C  'SEEKSET.N3.'
    .word msg_2d_seekset_x   ;VECTOR   0x2D  'SEEKSET.X..'
    .word msg_2e_seekset_y   ;VECTOR   0x2E  'SEEKSET.Y..'
    .word msg_2f_seekset_z   ;VECTOR   0x2F  'SEEKSET.Z..'
    .word msg_30_fern_on     ;VECTOR   0x30  'FERN...ON..'
    .word msg_31_fern_off    ;VECTOR   0x31  'FERN...OFF.'
    .word msg_32_testtun_on  ;VECTOR   0x32  'TESTTUN.ON.'
    .word msg_33_test_q      ;VECTOR   0x33  'TEST..Q....'
    .word msg_34_testbass    ;VECTOR   0x34  'TESTBASS...'
    .word msg_35_testtreb    ;VECTOR   0x35  'TESTTREB...'
    .word msg_36_testtun_off ;VECTOR   0x36  'TESTTUN.OFF'
    .word msg_37_on_tuning   ;VECTOR   0x37  '.ON.TUNING.'

msgs_20_3f_done:
    call make_fis_text
    ret

msg_20_rad_3cp_t7:
;Buffer:  'RAD.3CP.T7.'
;Example: 'RAD 3CP T7 '
;
;No params
    jmp msgs_20_3f_done

msg_21_ver:
;Buffer:  'VER........'
;Example: 'VER  4302  '
;
;Param 0 High Nibble = Unknown; "4" in example above
;Param 0 Low Nibble  = Unknown; "3" in example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    setb 0xa9:0             ;Set "show period" flag

    incw ep                 ;EP = pointer to Display Param 1
    mov a, @ep              ;A = Display Param 1
    call hex_nib_high       ;A = ASCII digit for its high nibble
    mov @ix+0x05, a         ;Write digit into buffer

    mov a, @ep              ;A = Display Param 1
    call hex_nib_low        ;A = ASCII digit for its low nibble
    mov @ix+0x06, a         ;Write digit into buffer

    movw ep, #table_e000+0x0b ;EP = pointer to a byte in this ROM
    mov a, @ep              ;A = Byte from this ROM
    call hex_nib_high       ;A = ASCII digit for its high nibble
    mov @ix+0x07, a         ;Write digit into buffer

    mov a, @ep              ;A = Byte from this ROM
    call hex_nib_low        ;A = ASCII digit for its low nibble
    mov @ix+0x08, a         ;Write digit into buffer
    jmp msgs_20_3f_done

msg_22_:
;Buffer:  '...........'
;Example: '1079A B C D'
;
;Param 0 Byte = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
;Param 1 Byte = High byte for spaced hex display (0xAB in example above)
;Param 2 Byte = Low byte for spaced hex display (0xCD in example above)
    mov a, @ep              ;A = FM frequency index
    call num_to_mhz         ;A = BCD freq (word)
    mov r1, a               ;R1 = BCD freq low byte
    swap
    mov r2, a               ;R2 = BCD freq high byte

    and a, #0xf0            ;Mask to leave only high nibble
    bz lab_e7f9             ;Skip digit if it is 0
    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x00, a         ;Write digit into buffer

lab_e7f9:
    mov a, r2               ;A = BCD freq high byte
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x01, a         ;Write digit into buffer

    mov a, r1               ;A = BCD freq low byte
    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x02, a         ;Write digit into buffer

    mov a, r1               ;A = BCD freq low byte
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x03, a         ;Write digit into buffer

msg_spaced_digits:
    incw ep                 ;EP = pointer to Display Param 1

    mov a, @ep              ;A = param 1
    call hex_nib_high       ;A = ASCII digit for param 1 high nibble
    mov @ix+0x04, a         ;Write digit into buffer

    mov a, @ep              ;A = param 1
    call hex_nib_low        ;A = ASCII digit for param 1 low nibble
    mov @ix+0x06, a         ;Write digit into buffer

    incw ep                 ;EP = pointer to Display Param 2

    mov a, @ep              ;A = param 2
    call hex_nib_high       ;A = ASCII digit for param 2 high nibble
    mov @ix+0x08, a         ;Write digit into buffer

    mov a, @ep              ;A = param 2
    call hex_nib_low        ;A = ASCII digit for param 2 low nibble
    mov @ix+0x0a, a         ;Write digit into buffer
    jmp msgs_20_3f_done

msg_23_hc:
;Buffer:  'HC.........'
;Example: 'HC 4A B C D'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown ("4" in example above)
;Param 1 Byte        = High byte for spaced hex display (0xAB in example above)
;Param 2 Byte        = Low byte for spaced hex display (0xCD in example above)
    mov a, @ep              ;A = Display Param 0 (number)
    call hex_nib_low        ;A = Number as a hex digit
    mov @ix+0x03, a
    jmp msg_spaced_digits

msg_24_v:
;Buffer:  'V..........'
;
;Param 0 Byte = Used; Unknown purpose
;Param 1 Byte = Used; Unknown purpose
;Param 2 Byte = Used; Unknown purpose
;TODO finish me
    mov a, @ep             ;A = display param 0
    and a, #0xf0
    beq lab_e878
    mov a, #'-
    mov @ix+0x01, a
    mov a, @ep
    xor a, #0xff
    incw a
lab_e83e:
    call hex_nib_low
    mov @ix+0x02, a

    incw ep                ;EP = pointer to display param 1
    mov a, @ep             ;A = display param 1
    call bin_to_bcd
    mov a, r6
    beq lab_e850
    call hex_nib_low
    mov @ix+0x04, a
lab_e850:
    mov a, r7
    call hex_nib_high
    mov @ix+0x05, a
    mov a, r7
    call hex_nib_low
    mov @ix+0x06, a

    incw ep                ;EP = pointer to display param 2
    mov a, @ep             ;A = display param 2
    call bin_to_bcd
    mov a, r6
    beq lab_e869
    call hex_nib_low
    mov @ix+0x08, a
lab_e869:
    mov a, r7
    call hex_nib_high
    mov @ix+0x09, a
    mov a, r7
    call hex_nib_low
    mov @ix+0x0a, a
    jmp msgs_20_3f_done
lab_e878:
    mov a, #'+
    mov @ix+0x01, a
    mov a, @ep
    jmp lab_e83e

msg_25_seekset_m:
;Buffer:  'SEEKSET.M..'
;Example: 'SEEKSET M5 '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (number)
    call hex_nib_low        ;A = number as hex digit
    mov @ix+0x09, a         ;Write digit into buffer
    jmp msgs_20_3f_done

msg_26_seekset_n:
;Buffer:  'SEEKSET.N..'
;Example: 'SEEKSET N5 ' (Param 0 = number)
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_25_seekset_m

msg_27_seekset_m1:
;Buffer:  'SEEKSET.M1.'
;Example: 'SEEKSET M15'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (number)
    call hex_nib_low        ;A = number as hex digit
    mov @ix+0x0a, a         ;Write digit into buffer
    jmp msgs_20_3f_done

msg_28_seekset_m2:
;Buffer:  'SEEKSET.M2.'
;Example: 'SEEKSET M25'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_27_seekset_m1

msg_29_seekset_m3:
;Buffer:  'SEEKSET.M3.'
;Example: 'SEEKSET M35' (Param 0 = number)
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_27_seekset_m1

msg_2a_seekset_n1:
;Buffer:  'SEEKSET.N1.'
;Example: 'SEEKSET N15'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_27_seekset_m1

msg_2b_seekset_n2:
;Buffer:  'SEEKSET.N2.'
;Example: 'SEEKSET N25'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_27_seekset_m1

msg_2c_seekset_n3:
;Buffer:  'SEEKSET.N3.'
;Example: 'SEEKSET N35'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Unknown; "5" in the example above
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_27_seekset_m1

msg_2d_seekset_x:
;Buffer:  'SEEKSET.X..'
;Example: 'SEEKSET X42'
;
;Param 0 Byte        = Unknown binary value ("42" in example above)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0
    and a, #0xf0            ;Mask to leave only high nibble
    beq lab_e8ae            ;Skip write if high byte is 0
    call hex_nib_high       ;A = ASCII digit for high byte
    mov @ix+0x09, a         ;Write digit into buffer
lab_e8ae:
    mov a, @ep              ;A = Display Param 0
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x0a, a         ;Write digit into buffer
    jmp msgs_20_3f_done

msg_2e_seekset_y:
;Buffer:  'SEEKSET.Y..'
;Example: 'SEEKSET Y42'
;
;Param 0 Byte        = Unknown binary value ("42" in example above)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_2d_seekset_x

msg_2f_seekset_z:
;Buffer:  'SEEKSET.Z..'
;Example: 'SEEKSET Z42' (Param 0 = number)
;
;Param 0 Byte        = Unknown binary value ("42" in example above)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_2d_seekset_x

msg_30_fern_on:
;Buffer:  'FERN...ON..'
;Example: 'FERN   ON  '
;
;No params
    jmp msgs_20_3f_done

msg_31_fern_off:
;Buffer:  'FERN...OFF.'
;Example: 'FERN   OFF '
;
;No params
    jmp msgs_20_3f_done

msg_32_testtun_on:
;Buffer:  'TESTTUN.ON.'
;Example: 'TESTTUN ON '
;
;No params
    jmp msgs_20_3f_done

msg_33_test_q:
;Buffer:  'TEST..Q....'
;Example: 'TEST42Q....'
;
;Param 0 Byte = Used; Unknown binary value ("42" in example above)
;Param 1 Byte = Used; Unknown purpose
;Param 2 Byte = Used; Unknown purpose
;TODO finish me
    mov a, @ep              ;A = Display Param 0
    and a, #0xf0            ;Mask to leave only high nibble
    beq lab_e8d0            ;Skip write if high nibble is 0
    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x04, a         ;Write digit into buffer
lab_e8d0:
    mov a, @ep              ;A = Display Param 0
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x05, a         ;Write digit into buffer

    incw ep                 ;EP = pointer to Display Param 1
    mov a, @ep              ;A = Display Param 1
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x07, a         ;Write digit into buffer

    incw ep                 ;EP = pointer to Display Param 2
    mov a, @ep              ;A = Display Param 2
    and a, #0xf0
    beq lab_e902
    mov a, #'-
    mov @ix+0x08, a
    mov a, @ep
    xor a, #0xff
    incw a
lab_e8eb:
    clrc
    addc a, #0x00
    daa
    mov r0, a
    call hex_nib_high
    cmp a, #'0
    beq lab_e8f9
    mov @ix+0x09, a
lab_e8f9:
    mov a, r0
    call hex_nib_low
    mov @ix+0x0a, a
    jmp msgs_20_3f_done
lab_e902:
    mov a, #'+
    mov @ix+0x08, a
    mov a, @ep
    jmp lab_e8eb

msg_34_testbass:
;Buffer:  'TESTBASS...'
;Example: 'TESTBASS  0'
;Example: 'TESTBASS +9'
;Example: 'TESTBASS -9'
;
;Param 0 Byte = Level as a signed binary number
;Param 1 Byte = Unused
;Param 2 Byte = Unused
;TODO finish me
    mov a, @ep              ;A = Display Param 0
    mov r0, a
    bz lab_e913
    rolc a
    bc lab_e91e
    mov a, #'+
lab_e913:
    mov @ix+0x09, a
    mov a, r0
    call hex_nib_low
    mov @ix+0x0a, a
    jmp msgs_20_3f_done
lab_e91e:
    mov a, r0
    xor a, #0xff
    incw a
    mov r0, a
    mov a, #'-
    jmp lab_e913

msg_35_testtreb:
;Buffer:  'TESTTREB...'
;Example: 'TESTTREB  0'
;Example: 'TESTTREB +9'
;Example: 'TESTTREB -9'
;
;Param 0 Byte = Level as a signed binary number
;Param 1 Byte = Unused
;Param 2 Byte = Unused
;TODO finish me
    jmp msg_34_testbass

msg_36_testtun_off:
;Buffer:  'TESTTUN.OFF'
;Example: 'TESTTUN OFF'
    jmp msgs_20_3f_done

msg_37_on_tuning:
;Buffer:  '.ON.TUNING.'
;Example: ' ON TUNING '
    jmp msgs_20_3f_done

msgs_40_4f:
;Called if A >= 0x40 and A <= 0x4F (tuner messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x40
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_40_4f_text ;A = pointer to tuner messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x08
    bhs msgs_40_4f_done
    clrc
    rolc a
    movw a, #msgs_40_4f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_40_4f_jmp:
    .word msg_40_fm_mhz     ;VECTOR   0x40  'FM......MHZ'
    .word msg_41_am_khz     ;VECTOR   0x41  'AM......KHZ'
    .word msg_42_scan_mhz   ;VECTOR   0x42  'SCAN....MHZ'
    .word msg_43_scan_khz   ;VECTOR   0x43  'SCAN....KHZ'
    .word msg_44_fm_max     ;VECTOR   0x44  'FM....MAX..'
    .word msg_45_fm_min     ;VECTOR   0x45  'FM....MIN..'
    .word msg_46_am_max     ;VECTOR   0x46  'AM....MAX..'
    .word msg_47_am_min     ;VECTOR   0x47  'AM....MIN..'

msgs_40_4f_done:
    call make_fis_text
    ret

msg_40_fm_mhz:
;Buffer:  'FM......MHZ'
;Example: 'FM261389MHZ'
;
;Param 0 High Nibble = FM mode number (1, 2 for FM1, FM2)
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
;Param 2 Byte        = Unused
    setb 0xa9:0             ;Set "show period" flag
    setb 0xa9:1             ;Set "mode or preset digits" flag

    mov a, @ep              ;A = display param 0 (high nib = FM1/2, low = preset)
    call hex_nib_high       ;A = ASCII digit for high nibble (FM "1" or "2")
    mov @ix+0x02, a         ;Write 1/2 for FM1/2 into buffer

    mov a, @ep              ;A = display param 0 (high nib = FM1/2, low = preset)
    call hex_nib_low        ;A = ASCII digit for preset ("1" to "6", "0" if none)
    cmp a, #'0              ;Preset = 0 (no preset)?
    beq lab_e989            ;  Yes: branch to leave preset blank
    mov @ix+0x03, a         ;Write preset digit into buffer

lab_e989:
    incw ep                 ;EP = pointer to display param 1 (FM frequency index)
    mov a, @ep              ;A = FM frequency index
    call num_to_mhz         ;A = BCD freq (word)

lab_e98e:
    mov r1, a               ;R1 = BCD freq low byte
    swap
    mov r2, a               ;R2 = BCD freq high byte

    and a, #0xf0            ;Mask to leave only high nibble
    bz lab_e99a             ;Skip digit if it is 0

    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x04, a         ;Write digit into buffer

lab_e99a:
    mov a, r2               ;A = BCD freq high byte
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x05, a         ;Write digit into buffer

    mov a, r1               ;A = BCD freq low byte
    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x06, a         ;Write digit into buffer

    mov a, r1               ;A = BCD freq low byte
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x07, a         ;Write digit into buffer
    jmp msgs_40_4f_done

msg_41_am_khz:
;Buffer:  'AM......KHZ'
;Example: 'AM 2 540KHZ'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = AM Frequency Index (0=540 kHz, 3080 kHz)
;Param 2 Byte        = Unused
    mov a, @ep              ;A = display param 0 (preset number)
    call hex_nib_low        ;A = ASCII digit for preset
    cmp a, #'0              ;Preset = 0 (no preset)?
    beq lab_e9b9            ;  Yes: branch to leave preset blank
    mov @ix+0x03, a         ;Write preset digit into buffer
lab_e9b9:
    incw ep                 ;EP = pointer to display param 1 (AM frequency index)
    mov a, @ep              ;A = AM frequency index
    call num_to_khz         ;A = BCD freq (word)
    jmp lab_e98e

msg_42_scan_mhz:
;Buffer:  'SCAN....MHZ'
;Example: 'SCAN1079MHZ'
;
;Param 0 Byte        = Unused
;Param 1 Byte        = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
;Param 2 Byte        = Unused
    setb 0xa9:0             ;Set "show period" flag
    jmp lab_e989

msg_43_scan_khz:
;Buffer:  'SCAN....KHZ'
;Example: 'SCAN1079KHZ'
;
;Param 0 Byte       = Unused
;Param 1 Byte       = AM Frequency Index (0=540 kHz, 3080 kHz)
;Param 2 Byte       = Unused
    jmp lab_e9b9

msg_44_fm_max:
;Buffer:  'FM....MAX..'
;Example: 'FM26  MAX  '
;
;Param 0 High Nibble = FM mode number (1, 2 for FM1, FM2)
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    setb 0xa9:1             ;Set "mode or preset digits" flag

    mov a, @ep              ;A = display param 0
    call hex_nib_high       ;A = ASCII digit for high nibble (FM mode number)
    mov @ix+0x02, a         ;Write digit into buffer

    mov a, @ep              ;A = display param 0
    call hex_nib_low        ;A = ASCII digit for low nibble (preset number)
    cmp a, #'0              ;Preset 0 (no preset)?
    beq lab_e9db            ;  Yes: branch to skip writing 0
    mov @ix+0x03, a         ;Write digit into buffer
lab_e9db:
    jmp msgs_40_4f_done

msg_45_fm_min:
;Buffer:  'FM....MIN..'
;Example: 'FM26  MIN  '
;
;Param 0 High Nibble = FM mode number (1, 2 for FM1, FM2)
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_44_fm_max

msg_46_am_max:
;Buffer:  'AM....MAX..'
;Example: 'AM 6  MAX  '
;
;Param 0 High Nibble = Unused
;Param 1 Byte        = Preset number (0=none, 1-6)
;Param 2 Byte        = Unused
    mov a, @ep              ;A = display param 0 (preset)
    call hex_nib_low        ;A = ASCII digit for preset
    cmp a, #'0              ;Preset = 0 (no preset)?
    beq lab_e9eb            ;  Yes: branch to leave preset blank
    mov @ix+0x03, a         ;Write digit into buffer
lab_e9eb:
    jmp msgs_40_4f_done

msg_47_am_min:
;Buffer:  'AM....MIN..'
;Example: 'AM 6  MIN  '
;
;Param 0 High Nibble = Unused
;Param 1 Byte        = Preset number (0=none, 1-6)
;Param 2 Byte        = Unused
    jmp msg_46_am_max

msgs_50_5f:
;Called if A >= 50 and A <= 0x5F (tape messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x50
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_50_5f_text ;A = pointer to tape messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x0e
    bhs msgs_50_5f_done
    clrc
    rolc a
    movw a, #msgs_50_5f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_50_5f_jmp:
    .word msg_50_tape_play_a  ;VECTOR   0x50  'TAPE.PLAY.A'
    .word msg_51_tape_play_b  ;VECTOR   0x51  'TAPE.PLAY.B'
    .word msg_52_tape_ff      ;VECTOR   0x52  'TAPE..FF...'
    .word msg_53_tape_rew     ;VECTOR   0x53  'TAPE..REW..'
    .word msg_54_tape_mss_ff  ;VECTOR   0x54  'TAPEMSS.FF.'
    .word msg_55_tape_mss_rew ;VECTOR   0x55  'TAPEMSS.REW'
    .word msg_56_tape_scan_a  ;VECTOR   0x56  'TAPE.SCAN.A'
    .word msg_57_tape_scan_b  ;VECTOR   0x57  'TAPE.SCAN.B'
    .word msg_58_tape_metal   ;VECTOR   0x58  'TAPE.METAL.'
    .word msg_59_tape_bls     ;VECTOR   0x59  'TAPE..BLS..'
    .word msg_5a_no_tape      ;VECTOR   0x5A  '....NO.TAPE'
    .word msg_5b_tape_error   ;VECTOR   0x5B  'TAPE.ERROR.'
    .word msg_5c_tape_max     ;VECTOR   0x5C  'TAPE..MAX..'
    .word msg_5d_tape_min     ;VECTOR   0x5D  'TAPE..MIN..'

msgs_50_5f_done:
    call make_fis_text
    ret

msg_50_tape_play_a:
;Buffer:  'TAPE.PLAY.A'
;Example: 'TAPE PLAY A'
;
;No params
    jmp msgs_50_5f_done

msg_51_tape_play_b:
;Buffer:  'TAPE.PLAY.B'
;Example: 'TAPE PLAY B'
;
;No params
    jmp msgs_50_5f_done

msg_52_tape_ff:
;Buffer:  'TAPE..FF...'
;Example: 'TAPE  FF   '
;
;No params
    jmp msgs_50_5f_done

msg_53_tape_rew:
;Buffer:  'TAPE..REW..'
;Example: 'TAPE  REW  '
;
;No params
    jmp msgs_50_5f_done

msg_54_tape_mss_ff:
;Buffer:  'TAPEMSS.FF.'
;Example: 'TAPEMSS FF '
;
;No params
    jmp msgs_50_5f_done

msg_55_tape_mss_rew:
;Buffer:  'TAPEMSS.REW'
;Example: 'TAPEMSS REW'
;
;No params
    jmp msgs_50_5f_done

msg_56_tape_scan_a:
;Buffer:  'TAPE.SCAN.A'
;Example: 'TAPE SCAN A'
;
;No params
    jmp msgs_50_5f_done

msg_57_tape_scan_b:
;Buffer:  'TAPE.SCAN.B'
;Example: 'TAPE SCAN B'
;
;No params
    jmp msgs_50_5f_done

msg_58_tape_metal:
;Buffer:  'TAPE.METAL.'
;Example: 'TAPE METAL '
;
;No params
    jmp msgs_50_5f_done

msg_59_tape_bls:
;Buffer:  'TAPE..BLS..'
;Example: 'TAPE  BLS  '
;
;No params
    jmp msgs_50_5f_done

msg_5a_no_tape:
;Buffer:  '....NO.TAPE'
;Example: '    NO TAPE'
;
;No params
    jmp msgs_50_5f_done

msg_5b_tape_error:
;Buffer:  'TAPE.ERROR.'
;Example: 'TAPE ERROR '
;
;No params
    jmp msgs_50_5f_done

msg_5c_tape_max:
;Buffer:  'TAPE..MAX..'
;Example: 'TAPE  MAX  '
;
;No params
    jmp msgs_50_5f_done

msg_5d_tape_min:
;Buffer:  'TAPE..MIN..'
;Example: 'TAPE  MIN  '
;
;No params
    jmp msgs_50_5f_done

msgs_60_7f:
;Called if A >= 0x60 and A <= 0x7F (sound messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x60
    clrc
    subc a
    mov r0, a
    cmp a, #0x02
    blo lab_ea88
    movw a, #0x000b
    mulu a
    movw a, #msgs_60_7f_text ;A = pointer to sound messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
lab_ea88:
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x0a
    bhs msgs_60_7f_done
    clrc
    rolc a
    movw a, #msgs_60_7f_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_60_7f_jmp:
    .word msg_60_max        ;VECTOR   0x60  '.....MAX...'
    .word msg_61_min        ;VECTOR   0x61  '.....MIN...'
    .word msg_62_bass       ;VECTOR   0x62  'BASS.......'
    .word msg_63_treb       ;VECTOR   0x63  'TREB.......'
    .word msg_64_bal_left   ;VECTOR   0x64  'BAL.LEFT...'
    .word msg_65_bal_right  ;VECTOR   0x65  'BAL.RIGHT..'
    .word msg_66_bal_center ;VECTOR   0x66  'BAL.CENTER.'
    .word msg_67_fadefront  ;VECTOR   0x67  'FADEFRONT..'
    .word msg_68_faderear   ;VECTOR   0x68  'FADEREAR...'
    .word msg_69_fadecenter ;VECTOR   0x69  'FADECENTER.'

msgs_60_7f_done:
    call make_fis_text
    ret

msg_60_max:
;Buffer:  '.....MAX...'
;Example: '     MAX   '
;
;No params
    mov a, #0x00
    mov @ix+0x04, a
    mov @ix+0x05, a
    mov a, #'M
    mov @ix+0x06, a
    mov a, #'A
    mov @ix+0x07, a
    mov a, #'X
    mov @ix+0x08, a
    mov a, #0x00
    mov @ix+0x09, a
    mov @ix+0x0a, a
    jmp msgs_60_7f_done

msg_61_min:
;Buffer:  '.....MIN...'
;Example: '     MIN  '
;
;No params
    mov a, #0x00
    mov @ix+0x04, a
    mov @ix+0x05, a
    mov a, #'M
    mov @ix+0x06, a
    mov a, #'I
    mov @ix+0x07, a
    mov a, #'N
    mov @ix+0x08, a
    mov a, #0x00
    mov @ix+0x09, a
    mov @ix+0x0a, a
    jmp msgs_60_7f_done

msg_62_bass:
;Buffer:  'BASS.......'
;Example: 'BASS  0    '
;Example: 'BASS  +9   '
;Example: 'BASS  -9   '
;
;Param 0 Byte = Signed binary number
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep              ;A = Display Param 0
    mov r0, a               ;R0 = Display Param 0
    bz lab_eaf6             ;Branch if zero

    rolc a                  ;Rotate bit 7 into carry
    bc lab_eb01             ;Branch if carry set (negative number)
    mov a, #'+              ;A = ASCII "+" sign

lab_eaf6:
    mov @ix+0x06, a         ;Write sign into buffer

    mov a, r0               ;A = Display Param 0
    call hex_nib_low        ;A = ASCII digit for display param 0
    mov @ix+0x08, a         ;Write ASCII digit into the buffer
    jmp msgs_60_7f_done

lab_eb01:
    mov a, r0               ;A = Display Param 0
    xor a, #0xff            ;Flip all bits over,
    incw a                  ;  then add one (two's complement)
    mov r0, a               ;R0 = number converted to positive
    mov a, #'-              ;A = ASCII digit for "-" sign
    jmp lab_eaf6

msg_63_treb:
;Buffer:  'TREB.......'
;Example: 'TREB  0    '
;Example: 'TREB  +9   '
;Example: 'TREB  -9   '
;
;Param 0 Byte = Signed binary number
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    jmp msg_62_bass

msg_64_bal_left:
;Buffer:  'BAL.LEFT...'
;Example: 'BAL LEFT  9'
;Example: 'BAL LEFT  1'
;
;Param 0 Byte = Signed binary number (always positive)
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep              ;A = Display Param 0
    and a, #0xf0            ;Mask to leave only high nibble
    cmp a, #0xf0            ;Is high nibble = 0xf?
    beq lab_eb32            ;  Yes: branch to handle negative

    mov a, @ep              ;A = Display Param 0
    cmp a, #0x09            ;Compare to 9
    blo lab_eb1f            ;Branch if it is lower than 9

    clrc
    addc a, #0x00
    daa
    mov @ep, a

lab_eb1f:
    mov a, @ep              ;A = Display Param 0
    and a, #0xf0            ;Mask to leave only high nibble
    bz lab_eb29             ; Skip writing digit if it is zero

    call hex_nib_high       ;A = ASCII digit for high nibble
    mov @ix+0x09, a         ;Write digit into buffer

lab_eb29:
    mov a, @ep              ;A = Display Param 0
    call hex_nib_low        ;A = ASCII digit for low nibble
    mov @ix+0x0a, a         ;Write digit into buffer
    jmp msgs_60_7f_done

lab_eb32:
    mov a, @ep
    xor a, #0xff
    clrc
    addc a, #0x01
    daa
    mov @ep, a
    jmp lab_eb1f

msg_65_bal_right:
;Buffer:  'BAL.RIGHT..'
;Example: 'BAL RIGHT 9'
;Example: 'BAL RIGHT 1'
;
;Param 0 Byte = Signed binary number (always negative)
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep
    and a, #0xf0
    cmp a, #0xf0
    beq lab_eb61
    mov a, @ep
    cmp a, #0x09
    blo lab_eb4e
    clrc
    addc a, #0x00
    daa
    mov @ep, a
lab_eb4e:
    mov a, @ep
    and a, #0xf0
    beq lab_eb58
    call hex_nib_high
    mov @ix+0x09, a
lab_eb58:
    mov a, @ep
    call hex_nib_low
    mov @ix+0x0a, a
    jmp msgs_60_7f_done
lab_eb61:
    mov a, @ep
    xor a, #0xff
    clrc
    addc a, #0x01
    daa
    mov @ep, a
    jmp lab_eb4e

msg_66_bal_center:
;Buffer:  'BAL.CENTER.'
;Example: 'BAL CENTER '
;
;No params
    jmp msgs_60_7f_done

msg_67_fadefront:
;Buffer:  'FADEFRONT..'
;Example: 'FADEFRONT 9'
;
;Param 0 Byte = Level (signed number, always positive)
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    jmp msg_65_bal_right

msg_68_faderear:
;Buffer:  'FADEREAR...'
;Example: 'FADEREAR   '
;
;Param 0 Byte = Level (signed number, always negative)
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    jmp msg_64_bal_left

msg_69_fadecenter:
;Buffer:  'FADECENTER.'
;Example: 'FADECENTER '
;
;No params
    jmp msgs_60_7f_done

msgs_80_af:
;Called if A >= 0x80 and A < 0xB0 (code messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0x80
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_80_af_text ;A = pointer to code messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x08
    bhs msgs_80_af_done
    clrc
    rolc a
    movw a, #msgs_80_af_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_80_af_jmp:
    .word msg_80_no_code    ;VECTOR   0x80  '....NO.CODE'
    .word msg_81_code       ;VECTOR   0x81  '.....CODE..'
    .word msg_82_code_entry ;VECTOR   0x82  '...........'
    .word msg_83_safe       ;VECTOR   0x83  '.....SAFE..'
    .word msg_84_initial    ;VECTOR   0x84  '....INITIAL'
    .word msg_85_no_code    ;VECTOR   0x85  '....NO.CODE'
    .word msg_86_safe       ;VECTOR   0x86  '.....SAFE..'
    .word msg_87_clear      ;VECTOR   0x87  '....CLEAR..'

msgs_80_af_done:
    call make_fis_text
    ret

msg_80_no_code:
;Buffer:  '....NO.CODE'
;Example: '    NO CODE'
;
;No params
    jmp msgs_80_af_done

msg_81_code:
;Buffer:  '.....CODE..'
;Example: '     CODE  '
;
;No params
    jmp msgs_80_af_done

msg_82_code_entry:
;Buffer:  '...........'
;Example: '2    1234  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Attempt number
;Param 1 Byte        = Safe code high byte (BCD)
;Param 2 Byte        = Safe code low byte (BCD)
    mov a, @ep              ;A = Display Param 0 (Attempt)
    and a, #0x0f            ;Mask to leave only low nibble
    bz lab_ebcc             ;Skip writing attempt if it is 0
    call hex_nib_low        ;A = ASCII digit for attempt
    mov @ix+0x00, a         ;Write attempt into the buffer

lab_ebcc:
    incw ep                 ;EP = pointer to display param 1 (safe code high byte)
    mov a, @ep              ;A = safe code high byte
    call hex_nib_high       ;A = ASCII digit for high nibble of safe code high byte
    mov @ix+0x05, a         ;Write digit into the buffer

    mov a, @ep              ;A = safe code high byte
    call hex_nib_low        ;A = ASCII digit for low nibble of safe code high byte
    mov @ix+0x06, a         ;Write digit into the buffer

    incw ep                 ;EP = pointer to display param 2 (safe code low byte)
    mov a, @ep              ;A = safe code low byte
    call hex_nib_high       ;A = ASCII digit for high nibble of safe code low byte
    mov @ix+0x07, a         ;Write digit into the buffer

    mov a, @ep              ;A = safe code high byte
    call hex_nib_low        ;A = ASCII digit for low nibble of safe code low byte
    mov @ix+0x08, a         ;Write digit into the buffer
    jmp msgs_80_af_done

msg_83_safe:
;Buffer:  '.....SAFE..'
;Example: '2....SAFE..'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Attempt number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;A = Display Param 0 (Attempt)
    and a, #0x0f            ;Mask to leave only low nibble
    bz lab_ebf3             ;Skip if low nibble = 0
    call hex_nib_low        ;A = ASCII digit for attempt
    mov @ix+0x00, a         ;Write digit into the buffer
lab_ebf3:
    jmp msgs_80_af_done

msg_84_initial:
;Buffer:  '....INITIAL'
;Example: '    INITIAL'
;
;No params
    jmp msgs_80_af_done

msg_85_no_code:
;Buffer:  '....NO.CODE'
;Example: '    NO CODE'
;
;No params
    jmp msgs_80_af_done

msg_86_safe:
;Buffer:  '.....SAFE..'
;Example: '42...SAFE..'
;
;Param 0 Byte = Attempt number (binary; "42" above)
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep              ;A = Display Param 0 (Attempt)
    call bin_to_bcd         ;R7 = Attempt converted to BCD

    mov a, r7               ;A = tens place and ones place
    call hex_nib_high       ;A = ASCII digit for tens place
    mov @ix+0x00, a         ;Write it in the buffer

    mov a, r7               ;A = tens place and ones place
    call hex_nib_low        ;A = ASCII digit for ones place
    mov @ix+0x01, a         ;Write digit in the buffer
    jmp msgs_80_af_done

msg_87_clear:
;Buffer:  '....CLEAR..'
;Example: '    CLEAR  '
;
;No params
    jmp msgs_80_af_done

msgs_b0_bf:
;Called if A >= 0xB0 and A < 0xC0 (diag messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0xb0
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_b0_bf_text ;A = pointer to diag messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x02
    bhs msgs_b0_bf_done
    clrc
    rolc a
    movw a, #msgs_b0_bf_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_b0_bf_jmp:
    .word msg_b0_diag        ;VECTOR   A=0x00 '.....DIAG..'
    .word msg_b1_testdisplay ;VECTOR   A=0x01 'TESTDISPLAY'

msgs_b0_bf_done:
    call make_fis_text
    ret

msg_b0_diag:
;Buffer:  '.....DIAG..'
;Example: '     DIAG  '
;
;No params
    jmp msgs_b0_bf_done

msg_b1_testdisplay:
;Buffer:  'TESTDISPLAY'
;Example: 'TESTDISPLAY'
;
;No params
    jmp msgs_b0_bf_done

msgs_c0_cf:
;Called if A >= 0xC0 and A <= 0xCF (bose messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    mov a, @ep
    mov a, #0xc0
    clrc
    subc a
    mov r0, a
    movw a, #0x000b
    mulu a
    movw a, #msgs_c0_cf_text ;A = pointer to bose messages
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    movw ix, #0x012f
    movw ep, #0x011e
    movw a, #0x0000
    mov a, r0
    cmp a, #0x02
    bhs msgs_c0_cf_done
    clrc
    rolc a
    movw a, #msgs_c0_cf_jmp
    clrc
    addcw a
    movw a, @a
    jmp @a

msgs_c0_cf_jmp:
    .word msg_c0_bose       ;VECTOR   0xC0  '.....BOSE..'
    .word msg_c1_           ;VECTOR   0xC1  '...........'

msgs_c0_cf_done:
    call make_fis_text
    ret

msg_c0_bose:
;Buffer:  '.....BOSE..'
;Example: '     BOSE  '
;
;No params
    jmp msgs_c0_cf_done

msg_c1_:
;Buffer:  '...........'
;Example: '           '
;
;No params
    jmp msgs_c0_cf_done

msgs_00_or_gte_d0:
;Called if A = 0 or A >= 0xD0 (vw-car message)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000
    movw a, #msgs_00_or_gte_d0_text ;A = pointer to vw-car message
    clrc
    addcw a
    movw ix, a
    movw ep, #0x012f
    call copy_11_ix_to_ep   ;Copy 11 bytes from @ix to @ep
    call make_fis_text
    ret

copy_11_ix_to_ep:
;Copy 11 bytes from @ix to @ep
    mov a, @ix+0x00
    mov @ep, a              ;Copy byte 0
    incw ep
    mov a, @ix+0x01
    mov @ep, a              ;Copy byte 1
    incw ep
    mov a, @ix+0x02
    mov @ep, a              ;Copy byte 2
    incw ep
    mov a, @ix+0x03
    mov @ep, a              ;Copy byte 3
    incw ep
    mov a, @ix+0x04
    mov @ep, a              ;Copy byte 4
    incw ep
    mov a, @ix+0x05
    mov @ep, a              ;Copy byte 5
    incw ep
    mov a, @ix+0x06
    mov @ep, a              ;Copy byte 6
    incw ep
    mov a, @ix+0x07
    mov @ep, a              ;Copy byte 7
    incw ep
    mov a, @ix+0x08
    mov @ep, a              ;Copy byte 8
    incw ep
    mov a, @ix+0x09
    mov @ep, a              ;Copy byte 9
    incw ep
    mov a, @ix+0x0a
    mov @ep, a              ;Copy byte 10
    incw ep
    ret


make_fis_text:
;Reads 11 bytes of ASCII display data from 0x012f-0x139.
;Writes 16 bytes of FIS display data to 0x00d7-0x00e6.
    movw ix, #0x00d7        ;IX = pointer to start of 16-byte FIS output buf
    movw ep, #0x012f        ;EP = pointer to start of 11-byte ASCII input buf

    ;Copy 4 bytes from 0x012f-0x132 to 0x00d7-0x00da and mask for 7-bit ASCII
    mov r0, #0x04
lab_ecd6:
    mov a, @ep
    and a, #0x7f
    mov @ix+0x00, a
    incw ix
    incw ep
    dec r0
    bne lab_ecd6

    ;Clear 4 bytes from 0x00db-0x00de
    movw ix, #0x00d7
    mov a, #0x00
    mov @ix+0x04, a
    mov @ix+0x05, a
    mov @ix+0x06, a
    mov @ix+0x07, a

    ;Copy 7 bytes from 0x0133-0x139 to 0x0df-0x0e5 and mask for 7-bit ASCII
    movw ix, #0x00d7+8
    movw ep, #0x0133
    mov r0, #0x07
lab_ecf5:
    mov a, @ep
    and a, #0x7f
    mov @ix+0x00, a
    incw ix
    incw ep
    dec r0
    bne lab_ecf5

    ;Clear 1 byte at 0x00e6
    movw ix, #0x00d7
    mov a, #0x00
    mov @ix+0x0f, a

    movw ix, #0x00d7

    ;Decide if a period needs to be inserted
    mov a, 0x011c           ;A = pictographs byte in M2S command packet
    and a, #0x40            ;Mask of all except "period" pictograph bit
    bnz lab_ed13            ;Branch if "period" pictograph is set
    bbc 0x00a9:0, lab_ed27  ;Branch if "show period" flag is clear

lab_ed13:
    ;A period needs to be inserted.  Shift four characters to the right to
    ;make room for the period and then write the period.

    ;Copy 0x00e5 to 0x00e6
    mov a, @ix+0x0e
    mov @ix+0x0f, a
    ;Copy 0x00e4 to 0x00e5
    mov a, @ix+0x0d
    mov @ix+0x0e, a
    ;Copy 0x00e3 to 0x00e4
    mov a, @ix+0x0c
    mov @ix+0x0d, a
    ;Copy 0x00e2 to 0x00e3
    mov a, @ix+0x0b
    mov @ix+0x0c, a
    ;Put period char at 0x00e3
    mov a, #'.
    mov @ix+0x0b, a

lab_ed27:
    bbc 0x00a9:1, lab_ed32  ;Branch if "mode or preset digits" flag is clear

    ;Copy byte from 0x00da to 0x00db
    mov a, @ix+0x03
    mov @ix+0x04, a

    ;Clear byte at 0x00da
    mov a, #0x00
    mov @ix+0x03, a

lab_ed32:
    ret


num_to_mhz:
;Return a FM frequency in BCD for the index number in A
;A=0x00 returns A=0x0879 (87.9 MHz)
;A=0xFF returns A=0x1389 (138.9 MHz)
    mov r3, a               ;R3 = Index number of frequency
    mov r1, #0x79           ;R1 = Initial BCD low byte  (the 0x79 in 0x0879)
    mov r2, #0x08           ;R2 = Initial BCD high byte (the 0x08 in 0x0879)
    mov r4, #0x02           ;R4 = Increment of BCD 0x02

lab_ed3a:
    mov a, r3
    decw a
    cmp a, #0xff
    beq lab_ed4f
    mov r3, a
    mov a, r1
    mov a, r4
    clrc
    addc a
    daa
    mov r1, a
    mov a, r2
    addc a, #0x00
    daa
    mov r2, a
    jmp lab_ed3a
lab_ed4f:
    mov a, r2
    swap
    mov a, r1
    ret

num_to_khz:
;Return a AM frequency in BCD for the index number in A
;A=0x00 returns R2=0x05, R1=0x30 (530 kHz)
;A=0xFF returns R2=0x30, R1=0x80 (3080 kHz)
    mov r3, a               ;R3 = Index number of frequency
    mov r1, #0x30           ;R1 = Initial BCD low byte  (the 0x30 in 0x0530)
    mov r2, #0x05           ;R2 = Initial BCD high byte (the 0x05 in 0x0530)
    mov r4, #0x10           ;R4 = Increment of BCD 0x010
    jmp lab_ed3a


bin_to_bcd:
    mov r5, a
    mov r6, #0x00           ;Low nibble: hundreds place, High nibble: thousands
    mov r7, #0x00           ;Low nibble: ones place,     High nibble: tens
    mov a, r5
lab_ed63:
    clrc
    subc a, #100
    bnc lab_ed79
    clrc
    addc a, #100
lab_ed6b:
    clrc
    subc a, #10
    bnc lab_ed7d
    clrc
    addc a, #10
    mov a, r7
    clrc
    addc a
    daa
    mov r7, a
    ret
lab_ed79:
    inc r6
    jmp lab_ed63
lab_ed7d:
    mov r5, a
    mov a, r7
    clrc
    addc a, #0x10
    daa
    mov r7, a
    mov a, r5
    jmp lab_ed6b


hex_nib_high:
;Convert high nibble in A to an ASCII hex digit
;Returns ASCII digit A
    movw a, #0x00f0
    andw a
    clrc
    rolc a
    rolc a
    rolc a
    rolc a
    rolc a

hex_nib_low:
;Convert low nibble in A to an ASCII hex digit
;Returns ASCII digit in A
    movw a, #0x000f
    andw a
    movw a, #alphanum
    clrc
    addcw a
    mov a, @a
    ret

alphanum:
    .ascii '0123456789ABCDEF' ;ed9d

msgs_01_0f_text:
    ;0x01 'CD...TR....'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x54, 0x52, 0x00, 0x00, 0x00, 0x00
    ;0x02 'CUE........'
    .byte 0x43, 0x55, 0x45, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x03 'REV........'
    .byte 0x52, 0x45, 0x56, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x04 'SCANCD.TR..'
    .byte 0x53, 0x43, 0x41, 0x4e, 0x43, 0x44, 0x00, 0x54, 0x52, 0x00 ,0x00
    ;0x05 'NO..CHANGER'
    .byte 0x4e, 0x4f, 0x00, 0x00, 0x43, 0x48, 0x41, 0x4e, 0x47, 0x45, 0x52
    ;0x06 'NO..MAGAZIN'
    .byte 0x4e, 0x4f, 0x00, 0x00, 0x4d, 0x41, 0x47, 0x41, 0x5a, 0x49, 0x4e
    ;0x07 '....NO.DISC'
    .byte 0x00, 0x00, 0x00, 0x00, 0x4e, 0x4f, 0x00, 0x44, 0x49, 0x53, 0x43
    ;0x08 'CD...ERROR.'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x45, 0x52, 0x52, 0x4f, 0x52, 0x00
    ;0x09 'CD.........'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x0a 'CD....MAX..'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x41, 0x58, 0x00, 0x00
    ;0x0b 'CD....MIN..'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x49, 0x4e, 0x00, 0x00
    ;0x0c 'CHK.MAGAZIN'
    .byte 0x43, 0x48, 0x4b, 0x00, 0x4d, 0x41, 0x47, 0x41, 0x5a, 0x49, 0x4e
    ;0x0d 'CD..CD.ERR.'
    .byte 0x43, 0x44, 0x00, 0x00, 0x43, 0x44, 0x00, 0x45, 0x52, 0x52, 0x00
    ;0x0e 'CD...ERROR.'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x45, 0x52, 0x52, 0x4f, 0x52, 0x00
    ;0x0f 'CD...NO.CD.'
    .byte 0x43, 0x44, 0x00, 0x00, 0x00, 0x4e, 0x4f, 0x00, 0x43, 0x44, 0x00

msgs_10_1f_text:
    ;0x10 'SET.ONVOL.Y'
    .byte 0x53, 0x45, 0x54, 0x00, 0x4f, 0x4e, 0x56, 0x4f, 0x4c, 0x00, 0x59
    ;0x11 'SET.ONVOL.N'
    .byte 0x53, 0x45, 0x54, 0x00, 0x4f, 0x4e, 0x56, 0x4f, 0x4c, 0x00, 0x4e
    ;0x12 'SET.ONVOL..'
    .byte 0x53, 0x45, 0x54, 0x00, 0x4f, 0x4e, 0x56, 0x4f, 0x4c, 0x00, 0x00
    ;0x13 'SET.CD.MIX1'
    .byte 0x53, 0x45, 0x54, 0x00, 0x43, 0x44, 0x00, 0x4d, 0x49, 0x58, 0x31
    ;0x14 'SET.CD.MIX6'
    .byte 0x53, 0x45, 0x54, 0x00, 0x43, 0x44, 0x00, 0x4d, 0x49, 0x58, 0x36
    ;0x15 'TAPE.SKIP.Y'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x53, 0x4b, 0x49, 0x50, 0x00, 0x59
    ;0x16 'TAPE.SKIP.N'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x53, 0x4b, 0x49, 0x50, 0x00, 0x4e

msgs_20_3f_text:
    ;0x20 'RAD.3CP.T7.'
    .byte 0x52, 0x41, 0x44, 0x00, 0x33, 0x43, 0x50, 0x00, 0x54, 0x37, 0x00
    ;0x21 'VER........'
    .byte 0x56, 0x45, 0x52, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x22 '...........'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x23 'HC.........'
    .byte 0x48, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x24 'V..........'
    .byte 0x56, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x25 'SEEKSET.M..'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4d, 0x00, 0x00
    ;0x26 'SEEKSET.N..'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4e, 0x00, 0x00
    ;0x27 'SEEKSET.M1.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4d, 0x31, 0x00
    ;0x28 'SEEKSET.M2.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4d, 0x32, 0x00
    ;0x29 'SEEKSET.M3.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4d, 0x33, 0x00
    ;0x2a 'SEEKSET.N1.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4e, 0x31, 0x00
    ;0x2b 'SEEKSET.N2.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4e, 0x32, 0x00
    ;0x2c 'SEEKSET.N3.'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x4e, 0x33, 0x00
    ;0x2d 'SEEKSET.X..'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x58, 0x00, 0x00
    ;0x2e 'SEEKSET.Y..'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x59, 0x00, 0x00
    ;0x2f 'SEEKSET.Z..'
    .byte 0x53, 0x45, 0x45, 0x4b, 0x53, 0x45, 0x54, 0x00, 0x5a, 0x00, 0x00
    ;0x30 'FERN...ON..'
    .byte 0x46, 0x45, 0x52, 0x4e, 0x00, 0x00, 0x00, 0x4f, 0x4e, 0x00, 0x00
    ;0x31 'FERN...OFF.'
    .byte 0x46, 0x45, 0x52, 0x4e, 0x00, 0x00, 0x00, 0x4f, 0x46, 0x46, 0x00
    ;0x32 'TESTTUN.ON.'
    .byte 0x54, 0x45, 0x53, 0x54, 0x54, 0x55, 0x4e, 0x00, 0x4f, 0x4e, 0x00
    ;0x33 'TEST..Q....'
    .byte 0x54, 0x45, 0x53, 0x54, 0x00, 0x00, 0x51, 0x00, 0x00, 0x00, 0x00
    ;0x34 'TESTBASS...'
    .byte 0x54, 0x45, 0x53, 0x54, 0x42, 0x41, 0x53, 0x53, 0x00, 0x00, 0x00
    ;0x35 'TESTTREB...'
    .byte 0x54, 0x45, 0x53, 0x54, 0x54, 0x52, 0x45, 0x42, 0x00, 0x00, 0x00
    ;0x36 'TESTTUN.OFF'
    .byte 0x54, 0x45, 0x53, 0x54, 0x54, 0x55, 0x4e, 0x00, 0x4f, 0x46, 0x46
    ;0x37 '.ON.TUNING.'
    .byte 0x00, 0x4f, 0x4e, 0x00, 0x54, 0x55, 0x4e, 0x49, 0x4e, 0x47, 0x00
    ;0x38 'TESTBASS...' XXX Duplicate, no entry in jump table
    .byte 0x54, 0x45, 0x53, 0x54, 0x42, 0x41, 0x53, 0x53, 0x00, 0x00, 0x00
    ;0x39 'TESTTREB...' XXX Duplicate, no entry in jump table
    .byte 0x54, 0x45, 0x53, 0x54, 0x54, 0x52, 0x45, 0x42, 0x00, 0x00, 0x00

msgs_40_4f_text:
    ;0x40 'FM......MHZ'
    .byte 0x46, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x48, 0x5a
    ;0x41 'AM......KHZ'
    .byte 0x41, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4b, 0x48, 0x5a
    ;0x42 'SCAN....MHZ'
    .byte 0x53, 0x43, 0x41, 0x4e, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x48, 0x5a
    ;0x43 'SCAN....KHZ'
    .byte 0x53, 0x43, 0x41, 0x4e, 0x00, 0x00, 0x00, 0x00, 0x4b, 0x48, 0x5a
    ;0x44 'FM....MAX..'
    .byte 0x46, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x41, 0x58, 0x00, 0x00
    ;0x45 'FM....MIN..'
    .byte 0x46, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x49, 0x4e, 0x00, 0x00
    ;0x46 'AM....MAX..'
    .byte 0x41, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x41, 0x58, 0x00, 0x00
    ;0x47 'AM....MIN..'
    .byte 0x41, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x49, 0x4e, 0x00, 0x00

msgs_50_5f_text:
    ;0x50 'TAPE.PLAY.A'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x50, 0x4c, 0x41, 0x59, 0x00, 0x41
    ;0x51 'TAPE.PLAY.B'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x50, 0x4c, 0x41, 0x59, 0x00, 0x42
    ;0x52 'TAPE..FF...'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x00, 0x46, 0x46, 0x00, 0x00, 0x00
    ;0x53 'TAPE..REW..'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x00, 0x52, 0x45, 0x57, 0x00, 0x00
    ;0x54 'TAPEMSS.FF.'
    .byte 0x54, 0x41, 0x50, 0x45, 0x4d, 0x53, 0x53, 0x00, 0x46, 0x46, 0x00
    ;0x55 'TAPEMSS.REW'
    .byte 0x54, 0x41, 0x50, 0x45, 0x4d, 0x53, 0x53, 0x00, 0x52, 0x45, 0x57
    ;0x56 'TAPE.SCAN.A'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x53, 0x43, 0x41, 0x4e, 0x00, 0x41
    ;0x57 'TAPE.SCAN.B'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x53, 0x43, 0x41, 0x4e, 0x00, 0x42
    ;0x58 'TAPE.METAL.'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x4d, 0x45, 0x54, 0x41, 0x4c, 0x00
    ;0x59 'TAPE..BLS..'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x00, 0x42, 0x4c, 0x53, 0x00, 0x00
    ;0x5a '....NO.TAPE'
    .byte 0x00, 0x00, 0x00, 0x00, 0x4e, 0x4f, 0x00, 0x54, 0x41, 0x50, 0x45
    ;0x5b 'TAPE.ERROR.'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x45, 0x52, 0x52, 0x4f, 0x52, 0x00
    ;0x5c 'TAPE..MAX..'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x00, 0x4d, 0x41, 0x58, 0x00, 0x00
    ;0x5d 'TAPE..MIN..'
    .byte 0x54, 0x41, 0x50, 0x45, 0x00, 0x00, 0x4d, 0x49, 0x4e, 0x00, 0x00

msgs_60_7f_text:
    ;0x60 '.....MAX...'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x41, 0x58, 0x00, 0x00, 0x00
    ;0x61 '.....MIN...'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x4d, 0x49, 0x4e, 0x00, 0x00, 0x00
    ;0x62 'BASS.......'
    .byte 0x42, 0x41, 0x53, 0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x63 'TREB.......'
    .byte 0x54, 0x52, 0x45, 0x42, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x64 'BAL.LEFT...'
    .byte 0x42, 0x41, 0x4c, 0x00, 0x4c, 0x45, 0x46, 0x54, 0x00, 0x00, 0x00
    ;0x65 'BAL.RIGHT..'
    .byte 0x42, 0x41, 0x4c, 0x00, 0x52, 0x49, 0x47, 0x48, 0x54, 0x00, 0x00
    ;0x66 'BAL.CENTER.'
    .byte 0x42, 0x41, 0x4c, 0x00, 0x43, 0x45, 0x4e, 0x54, 0x45, 0x52, 0x00
    ;0x67 'FADEFRONT..'
    .byte 0x46, 0x41, 0x44, 0x45, 0x46, 0x52, 0x4f, 0x4e, 0x54, 0x00, 0x00
    ;0x68 'FADEREAR...'
    .byte 0x46, 0x41, 0x44, 0x45, 0x52, 0x45, 0x41, 0x52, 0x00, 0x00, 0x00
    ;0x69 'FADECENTER.'
    .byte 0x46, 0x41, 0x44, 0x45, 0x43, 0x45, 0x4e, 0x54, 0x45, 0x52, 0x00

msgs_80_af_text:
    ;0x80 '....NO.CODE'
    .byte 0x00, 0x00, 0x00, 0x00, 0x4e, 0x4f, 0x00, 0x43, 0x4f, 0x44, 0x45
    ;0x81 '.....CODE..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x4f, 0x44, 0x45, 0x00, 0x00
    ;0x82 '...........'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ;0x83 '.....SAFE..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x53, 0x41, 0x46, 0x45, 0x00, 0x00
    ;0x84 '....INITIAL'
    .byte 0x00, 0x00, 0x00, 0x00, 0x49, 0x4e, 0x49, 0x54, 0x49, 0x41, 0x4c
    ;0x85 '....NO.CODE'
    .byte 0x00, 0x00, 0x00, 0x00, 0x4e, 0x4f, 0x00, 0x43, 0x4f, 0x44, 0x45
    ;0x86 '.....SAFE..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x53, 0x41, 0x46, 0x45, 0x00, 0x00
    ;0x87 '....CLEAR..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x43, 0x4c, 0x45, 0x41, 0x52, 0x00, 0x00

msgs_b0_bf_text:
    ;0xb0 '.....DIAG..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x49, 0x41, 0x47, 0x00, 0x00
    ;0xb1 'TESTDISPLAY'
    .byte 0x54, 0x45, 0x53, 0x54, 0x44, 0x49, 0x53, 0x50, 0x4c, 0x41, 0x59

msgs_c0_cf_text:
    ;0xc0 '.....BOSE..'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x42, 0x4f, 0x53, 0x45, 0x00, 0x00
    ;0xc1 '...........'
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


msgs_00_or_gte_d0_text:
    ;0x00, 0xd0+ '....VW-CAR.'
    .byte 0x00, 0x00, 0x00, 0x00, 0x56, 0x57, 0x2d, 0x43, 0x41, 0x52, 0x00


sub_f1ac:
;TODO seems FIS related
    movw a, ps              ;Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;  R0=0x100, R1=0x101...
    andw a
    movw ps, a

    call sub_f1f3
    bbc 0x00ab:5, lab_f1d4
    bbc 0x00ab:0, lab_f1d4
    clrb 0xab:5
    mov a, #0x10
    mov 0xca, a

lab_f1c1:
    mov a, #0x05
    mov 0xcb, a
    mov a, #0x14
    mov 0xc9, a

    mov a, #0x04
    mov 0xc3, a             ;Set 0x00C3 = 0x04

lab_f1cd:
    call sub_f230
    call sub_f3b2
    ret

lab_f1d4:
    bbc 0x00ab:4, lab_f1e3  ;Branch if "write to FIS only" flag is clear
    bbc 0x00ab:0, lab_f1e3
    clrb 0xab:4             ;Clear "write to FIS only" flag
    mov a, #0x10
    mov 0xca, a
    jmp lab_f1c1

lab_f1e3:
    mov a, 0xc9
    bne lab_f1ec
    setb 0xab:0
    jmp lab_f1c1

lab_f1ec:
    mov a, 0xcb
    bne lab_f1cd
    jmp lab_f1c1

sub_f1f3:
    mov a, 0xc6
    cmp a, #0x04
    bhs lab_f213
    cmp a, #0x02
    blo lab_f213

lab_f1fd:
    mov a, #0x14
    mov 0xc9, a
    mov a, #0x00
    mov 0xc6, a
    bbs 0x00ab:0, lab_f212
    setb 0xab:0
    mov a, #0x00
    mov 0xca, a

    mov a, #0x04
    mov 0xc3, a             ;Set 0x00C3 = 0x04

lab_f212:
    ret

lab_f213:
    mov a, 0xc6
    cmp a, #0x07
    bhs lab_f220
    cmp a, #0x04
    blo lab_f220
    jmp lab_f1fd

lab_f220:
    mov a, 0xc6
    cmp a, #0x0a
    bhs lab_f212
    cmp a, #0x07
    blo lab_f212
    mov 0xc6, #0x00
    jmp lab_f212

sub_f230:
    mov a, 0xc3             ;A = read byte at 0x00C3
    bne lab_f235

lab_f234:
    ret

lab_f235:
    cmp a, #0x02            ;If A = 0x02, call sub_f267 and return
    bne lab_f23f
    call sub_f267
    jmp lab_f234

lab_f23f:
    cmp a, #0x04            ;If A = 0x04, call ...
    bne lab_f249
    call sub_f281
    jmp lab_f234

lab_f249:
    cmp a, #0x06
    bne lab_f253
    call sub_f29d
    jmp lab_f234

lab_f253:
    cmp a, #0x08
    bne lab_f25d
    call sub_f2c4
    jmp lab_f234

lab_f25d:
    cmp a, #0x0a
    bne lab_f234
    call sub_f2f4
    jmp lab_f234

sub_f267:
;handle 0x00C3 = 0x02
    clrb pdr4:3             ;/DISP_ENA_OUT = low

    movw a, #0x0007         ;Busy loop
lab_f26c:
    decw a
    bne lab_f26c

    setb pdr4:3             ;/DISP_ENA_OUT = high

    movw a, #0x0020         ;Busy loop
lab_f274:
    decw a
    bne lab_f274

    mov a, #0xf3
    call sub_f2ff           ;Send 0xF3 out 3LB SPI bus

    mov a, #0x04
    mov 0xc3, a             ;Set 0x00C3 = 0x04
    ret

sub_f281:
;handle 0x00C3 = 0x04
    mov a, 0xca
    bne lab_f29c

    mov a, #0x06
    mov 0xc3, a             ;Set 0x00C3 = 0x06

    call build_fis_packet
    mov 0xc2, #0x00
    mov a, #0x03
    mov 0xc8, a
    mov a, 0xe7
    cmp a, #0x05
    beq lab_f29c
    incw a
    mov 0xe7, a

lab_f29c:
    ret

sub_f29d:
;handle 0x00C3 = 0x06
    bbs pdr4:7, lab_f2c3    ;Branch if DISP_ENA_IN = high
    mov a, 0xc8
    bne lab_f2c3
    clrb pdr4:3             ;/DISP_ENA_OUT = low

    movw a, #0x0007         ;Busy loop
lab_f2a9:
    decw a
    bne lab_f2a9

    setb pdr4:3             ;/DISP_ENA_OUT = high

    movw a, #0x0020         ;Busy loop
lab_f2b1:
    decw a
    bne lab_f2b1

    call sub_f2fc           ;Send byte at pointer in 0x00C0 out 3LB SPI

    mov a, #0x08
    mov 0xc3, a             ;Set 0xc3 = 8

    movw a, 0xc0            ;Increment pointer at 0x00C0
    incw a
    movw 0xc0, a

    mov 0xc4, #0x00         ;f2c0  85 c4 00     Set 0x00c4 = 0

lab_f2c3:
    ret                     ;f2c3  20

sub_f2c4:
;handle 0x00C = 0x08
    mov a, 0xc4
    bne lab_f2f3
    bbc pdr4:7, lab_f2f3    ;Branch if DISP_ENA_IN = low
    mov a, #0x00
    mov 0xe7, a
    movw a, #0x0000
    mov a, 0xc2
    mov a, #0xac
    clrc
    addc a
    mov a, @a
    call sub_f2fc           ;Send byte at pointer in 0x00C0 out 3LB SPI
    mov 0xc4, #0x00
    setb 0xab:1

    movw a, 0xc0            ;Increment pointer at 0x00C0
    incw a
    movw 0xc0, a

    mov a, 0xc2
    incw a
    mov 0xc2, a

    cmp a, #0x13
    bne lab_f2f3

    mov a, #0x0a
    mov 0xc3, a             ;Set 0x00C3 = 0x0A

lab_f2f3:
    ret

sub_f2f4:
;handle 0x00C3 = 0x0A
    mov a, #0x00
    mov 0xc3, a             ;Set 0x00C3 = 0
    mov 0xc6, #0x00
    ret

sub_f2fc:
;Read a byte from the pointer in 0x00C0 and send it out 3LB bus SPI
    movw a, 0xc0
    mov a, @a

sub_f2ff:
;Send byte in A out 3LB bus SPI
    mov sdr2, a             ;Write A to Serial Data Register 2
    clrb smr2:7             ;Clear SIOF to set transfer not complete
    nop
    nop
    nop
    setb smr2:0             ;Set SST to start the transfer
    nop
    nop
    nop
lab_f30b:
    bbc smr2:7, lab_f30b    ;Loop until SIOF indicates transfer complete
    ret


build_fis_packet:
;Reads 16-byte FIS display buffer in 0x00d7-0x00e6.
;Stores complete "Navi protocol" FIS packet in 0x00ac-0x00bf.
;Sets pointer at 0x00c0 to start of packet (0x00ac).
;
    ;0x00d7 -> 0x00af
    mov a, 0xd7             ;A = value from 0x00d7
    bnz lab_f315            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f315:
    mov 0xaf, a             ;Save A in 0x00af

    ;0x00d8 -> 0x00b0
    mov a, 0xd8             ;A = value from 0x00d8
    bnz lab_f31d            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f31d:
    mov 0xb0, a             ;Save A in 0x00b0

    ;0x00d9 -> 0x00b1
    mov a, 0xd9             ;A = value from 0x00d9
    bnz lab_f325            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f325:
    mov 0xb1, a             ;Save A in 0x00b1

    ;0x00da -> 0x00b2
    mov a, 0xda             ;A = value from 0x00da
    bnz lab_f32d            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f32d:
    mov 0xb2, a             ;Save A in 0x00b2

    ;0x00db -> 0x00b3
    mov a, 0xdb             ;A = value from 0x00db
    bnz lab_f335            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f335:
    mov 0xb3, a             ;Save A in 0x00b3

    ;0x00dc -> 0x00b4
    mov a, 0xdc             ;A = value at 0x00dc
    bnz lab_f33d            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f33d:
    mov 0xb4, a             ;Save A in 0x00b4

    ;0x00dd -> 0x00b5
    mov a, 0xdd             ;A = value at 0x00dd
    bnz lab_f345            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f345:
    mov 0xb5, a             ;Save A in 0x00b5

    ;0x00de -> 0x00b6
    mov a, 0xde             ;A = value at 0x00de
    bnz lab_f34d            ;Skip space change if A != 0
    mov a, #0x20            ;A = space character
lab_f34d:
    mov 0xb6, a             ;Save A in 0x00b6

    ;0x00df -> 0x00b7
    mov a, 0xdf             ;A = value at 0x00df
    bnz lab_f355            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f355:
    mov 0xb7, a             ;Save A in 0x00b7

    ;0x00e0 -> 0x00b8
    mov a, 0xe0             ;A = value at 0x00e0
    bnz lab_f35d            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f35d:
    mov 0xb8, a             ;Save A in 0x00b8

    ;0x00e1 -> 0x00b9
    mov a, 0xe1             ;A = value at 0x00e1
    bnz lab_f365            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f365:
    mov 0xb9, a             ;Save A in 0x00b9

    ;0x00e2 -> 0x00ba
    mov a, 0xe2             ;A = value at 0x00e2
    bnz lab_f36d            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f36d:
    mov 0xba, a             ;Save A in 0x00b9

    ;0x00e3 -> 0x00bb
    mov a, 0xe3             ;A = value at 0x00e3
    bnz lab_f375            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f375:
    mov 0xbb, a             ;Save A in 0x00bb

    ;0x00e4 -> 0x00bc
    mov a, 0xe4             ;A = value at 0x00e4
    bnz lab_f37d            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f37d:
    mov 0xbc, a             ;Save A in 0x00bc

    ;0x00e5 -> 0x00bd
    mov a, 0xe5             ;A = value at 0x00e5
    bnz lab_f385            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f385:
    mov 0xbd, a             ;Save A in 0x00bd

    ;0x00e6 -> 0x00be
    mov a, 0xe6             ;A = value at 0x00e6
    bnz lab_f38d            ;Skip 0x1c change if A != 0
    mov a, #0x1c            ;A = 0x1c
lab_f38d:
    mov 0xbe, a             ;Save A in 0x00be

    ;Prepend packet header

    mov a, #0x81            ;0x00AC = Navi packet byte 0 = 0x81
    mov 0xac, a

    mov a, #0x12            ;0x00AD = Navi packet byte 1 = Number of bytes (0x12)
    mov 0xad, a

    mov a, #0xf0
    mov 0xae, a             ;0x00AE = Navi packet byte 2 = 0xF0

    ;Append packet checksum

    mov r0, #0x12           ;R0 = 0x12 bytes to count down
    movw ix, #0x00ac        ;IX = pointer to start of Navi packet buffer

    mov a, @ix+0x00         ;A = read byte in Navi packet buffer
lab_f3a2:
    incw ix                 ;Increment pointer
    mov a, @ix+0x00         ;A = read next byte in buffer, T = previous byte
    xor a                   ;A = A ^ T
    dec r0
    bne lab_f3a2            ;Loop until 0x12 bytes are done

    decw a
    mov 0xac+19, a          ;Store checksum in last byte of packet buffer

    movw a, #0x00ac
    movw 0xc0, a            ;0x00C0 = pointer to start of Navi packet buffer
    ret


sub_f3b2:
    bbc 0x00ab:1, lab_f3be
    clrb 0xab:1
    setb 0xab:2
    mov a, #0x0a
    mov 0xc7, a

lab_f3bd:
    ret

lab_f3be:
    mov a, 0xc7
    bne lab_f3bd
    clrb 0xab:2
    jmp lab_f3bd

sub_f3c7:
    bbc 0x009b:3, lab_f3e4

lab_f3ca:
    clrb 0x9b:3
    setb 0x9b:2
    mov a, #0x0a
    mov 0x9d, a
    call read_bose          ;Read BOSE_SW1, BOSE_SW1 and set bits in 0x9e
    call read_0xab_bit2     ;Read 0xab:2 and set a bit in 0x9e
    call read_0xe7          ;Read 0xe7 and set a bit in 0x9e
    call read_diag          ;Read DIAG_SW1, DIAG_SW2 and set bits in 0x9e
    call read_0xcd_bit0     ;Read 0xcd:0 and set a bit in 0x9e
    setb 0x9b:0

lab_f3e3:
    ret

lab_f3e4:
    bbc 0x009b:2, lab_f3ca
    bbc 0x00cd:3, lab_f3e3
    clrb 0xcd:3
    jmp lab_f3ca


read_bose:
;Read BOSE_SW1, BOSE_SW2 and set two bits in 0x9e
;
;BOSE_SW2 = 1, BOSE_SW1 = 0 -> 0x9e = 0bXXXXXX01
;BOSE_SW2 = 0, BOSE_SW1 = 1 -> 0x9e = 0bXXXXXX10
;Anything else              -> 0x9e = 0bXXXXXX00
;
    mov a, 0x9e             ;Clear bits in 0x9e to receive BOSE switches
    and a, #0b11111100
    mov 0x9e, a

    mov a, pdr0             ;Read port with BOSE switches
    and a, #0b11000000      ;Mask to leave only BOSE_SW2 (bit 7) and BOSE_SW1 (bit 6)
    cmp a, #0b10000000      ;Compare with BOSE_SW2=1, BOSE_SW1=0
    bne read_bose_case_2

    ;BOSE_SW2 = 1, BOSE_SW1 = 0
    mov a, #0b00000001

read_bose_done:
    mov a, 0x9e             ;Set bits in 0x9e with new BOSE switch status
    orw a
    mov 0x9e, a
    ret

read_bose_case_2:
    cmp a, #0b01000000      ;Compare with BOSE_SW2=0, BOSE_SW1=1
    bne read_bose_case_else

    ;BOSE_SW2 = 0, BOSE_SW1 = 1
    mov a, #0b00000010
    jmp read_bose_done

read_bose_case_else:
    ;Any other combination of BOSE_SW2 and BOSE_SW1
    mov a, #0
    jmp read_bose_done


read_0xab_bit2:
;Read 0xab:2 and put it in 0x9e:3
;
;0xab:2 = 0 -> 0bXXXX0XXX
;0xab:2 = 1 -> 0bXXXX1XXX
;
    mov a, 0x9e
    and a, #0b11110111
    mov 0x9e, a
    bbc 0x00ab:2, read_0xab_bit2_done
    setb 0x9e:3
read_0xab_bit2_done:
    ret


read_0xe7:
;Read 0xe7 and set 0x9e:4 if 0xe7 = 5
;
;0xe5  = 5 -> 0bXXX0XXXX
;0xe5 != 5 -> 0bXXX1XXXX
;
    mov a, 0x9e
    and a, #0b11101111
    mov 0x9e, a

    mov a, 0xe7
    cmp a, #0x05
    bne read_0xe7_done

    setb 0x9e:4
read_0xe7_done:
    ret


read_diag:
;Read DIAG_SW1, DIAG_SW2 and set two bits in 0x9e
;
;DIAG_SW2 = 0, DIAG_SW1 = 0 -> 0x9e = 0b00XXXXXX
;DIAG_SW2 = 0, DIAG_SW1 = 1 -> 0x9e = 0b01XXXXXX
;DIAG_SW2 = 1, DIAG_SW1 = 0 -> 0x9e = 0b10XXXXXX
;DIAG_SW2 = 1, DIAG_SW1 = 1 -> 0x9e = 0b11XXXXXX
;
    mov a, 0x9e             ;Clear bits in 0x9e to receive DIAG switches
    and a, #0b00111111
    mov 0x9e, a

    bbc pdr0:4, lab_f439    ;Branch if DIAG_SW1 = low

    ;DIAG_SW1 = high
    setb 0x9e:6

lab_f439:
    bbc pdr0:5, read_diag_done ;f439  b5 00 02  Branch if DIAG_SW2 = low

    ;DIAG_SW2 = high
    setb 0x9e:7

read_diag_done:
    ret


read_0xcd_bit0:
;Read 0xcd:0 and put it in 0x9e:5
;TODO what is 0xcd:0?
;
    mov a, 0x9e
    and a, #0b11011111
    mov 0x9e, a

    bbc 0x00cd:0, read_0xcd_bit0_done

    setb 0x9e:5
read_0xcd_bit0_done:
    ret


sub_f44b:
;called from irq3_e175: irq3 (external interrupt #3) diag ill input
    movw a, tchr
    movw 0x013f, a
    mov a, 0x013c
    bne lab_f45b
    call sub_f46b

lab_f458:
    clrb eic2:7
    ret

lab_f45b:
    cmp a, #0x01
    bne lab_f465
    call sub_f483
    jmp lab_f458

lab_f465:
    call sub_f4a6
    jmp lab_f458

sub_f46b:
    bbc pdr6:3, lab_f47c    ;DIAG ILL
    movw a, 0x013f
    movw 0x013d, a
    mov a, #0x01
    setb eic2:5

lab_f478:
    mov 0x013c, a
    ret

lab_f47c:
    mov a, #0x00
    clrb eic2:5
    jmp lab_f478

sub_f483:
    bbs pdr6:3, lab_f49f    ;DIAG ILL
    clrc
    movw a, 0x013f
    movw a, 0x013d
    subcw a
    movw 0x0141, a
    movw a, 0x013f
    movw 0x013d, a
    mov a, #0x02
    clrb eic2:5

lab_f49b:
    mov 0x013c, a
    ret

lab_f49f:
    mov a, #0x00
    clrb eic2:5
    jmp lab_f49b

sub_f4a6:
    bbc pdr6:3, lab_f4c6    ;DIAG ILL
    clrc
    movw a, 0x013f
    movw a, 0x013d
    subcw a
    movw 0x0143, a
    movw a, 0x013f
    movw 0x013d, a
    setb 0xd2:0
    setb 0xd2:4
    mov a, #0x01
    setb eic2:5

lab_f4c2:
    mov 0x013c, a
    ret

lab_f4c6:
    mov a, #0x00
    clrb eic2:5
    jmp lab_f4c2

sub_f4cd:
    bbs 0x00d2:0, lab_f4e6
    bbc pdr6:3, lab_f4e1            ;DIAG ILL
    mov a, #0x64

lab_f4d5:
    mov 0x013b, a

lab_f4d8:
    mov a, 0x0148
    and a, #0xfe
    mov 0x0148, a
    ret

lab_f4e1:
    mov a, #0x00
    jmp lab_f4d5

lab_f4e6:
    clrb 0xd2:0
    movw a, 0x0141
    movw 0xd4, a
    movw a, 0x0143
    movw a, 0xd4
    clrc
    addcw a
    bhs lab_f4f9
    movw a, #0xffff

lab_f4f9:
    movw a, #0xff00
    andw a
    swap
    mov r0, a
    movw a, 0xd4
    movw a, #0xff00
    andw a
    swap
    call sub_f644
    mov a, r1
    cmp a, #0x64
    blo lab_f510
    mov a, #0x64

lab_f510:
    mov 0x013b, a
    jmp lab_f4d8


sub_f516:
;TODO unknown but related to illumination control
    bbc 0x009c:1, lab_f520  ;Branch if "play dead" flag is clear

    ;Playing dead
    clrb 0x9c:3
lab_f51b:
    clrb pdr3:6             ;ILL_CONT1 = low
    clrb pdr3:7             ;ILL_CONT2 = low
    ret

lab_f520:
    bbc 0x009c:3, lab_f51b
    bbc 0x00d2:4, lab_f532
lab_f526:
    mov a, #0x14
    mov 0x0145, a
    clrb 0xd2:4
    setb pdr3:6             ;ILL_CONT1 = high
    clrb pdr3:7             ;ILL_CONT2 = low
lab_f531:
    ret
lab_f532:
    mov a, 0x0145
    bne lab_f531
    bbs pdr6:3, lab_f526
    clrb pdr3:6             ;ILL_CONT1 = low
    setb pdr3:7             ;ILL_CONT2 = high
    jmp lab_f531


sub_f541:
    movw a, ps              ;Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;  R0=0x100, R1=0x101...
    andw a
    movw ps, a

    call sub_f516           ;TODO related to illumination control
    call sub_f571
    mov a, 0x0148
    rorc a
    bhs lab_f557
    call sub_f4cd

lab_f556:
    ret

lab_f557:
    rorc a
    bhs lab_f556
    call sub_f59f
    call sub_f5c3
    call sub_f5ec
    call sub_f617
    mov a, 0x0148
    and a, #0xfd
    mov 0x0148, a
    jmp lab_f556

sub_f571:
    mov a, 0x0147
    bne lab_f57e
    mov a, #0x01
    mov 0x0147, a
    mov 0x0148, a

lab_f57e:
    bbc 0x00d2:3, lab_f592
    mov a, 0x0147
    clrc
    rolc a
    cmp a, #0x04
    blo lab_f58c
    mov a, #0x01

lab_f58c:
    mov 0x0147, a
    mov 0x0148, a

lab_f592:
    bbs 0x00d2:2, lab_f59e
    setb 0xd2:2
    clrb 0xd2:3
    mov a, #0x05
    mov 0x0149, a

lab_f59e:
    ret

sub_f59f:
    mov adc2, #0x01
    mov adc1, #0x61

lab_f5a5:
    bbc adc1:3, lab_f5a5
    mov a, adcd
    mov r0, a
    mov adc1, #0x21

lab_f5ae:
    bbc adc1:3, lab_f5ae
    mov a, adcd
    call sub_f644
    call sub_f66b
    mov a, 0x0146
    and a, #0xfc
    or a, r1
    mov 0x0146, a
    ret

sub_f5c3:
    mov adc2, #0x01
    mov adc1, #0x61

lab_f5c9:
    bbc adc1:3, lab_f5c9
    mov a, adcd
    mov r0, a
    mov adc1, #0x31

lab_f5d2:
    bbc adc1:3, lab_f5d2
    mov a, adcd
    call sub_f644
    call sub_f66b
    clrc
    mov a, r1
    rolc a
    rolc a
    mov r1, a
    mov a, 0x0146
    and a, #0xf3
    or a, r1
    mov 0x0146, a
    ret

sub_f5ec:
    mov adc2, #0x01
    mov adc1, #0x61

lab_f5f2:
    bbc adc1:3, lab_f5f2
    mov a, adcd
    mov r0, a
    mov adc1, #0x41

lab_f5fb:
    bbc adc1:3, lab_f5fb
    mov a, adcd
    call sub_f644
    call sub_f66b
    clrc
    mov a, r1
    rolc a
    rolc a
    rolc a
    rolc a
    mov r1, a
    mov a, 0x0146
    and a, #0xcf
    or a, r1
    mov 0x0146, a
    ret

sub_f617:
    mov adc2, #0x01
    mov adc1, #0x61

lab_f61d:
    bbc adc1:3, lab_f61d
    mov a, adcd
    mov r0, a
    mov adc1, #0x51

lab_f626:
    bbc adc1:3, lab_f626
    mov a, adcd
    call sub_f644
    call sub_f66b
    clrc
    mov a, r1
    rolc a
    rolc a
    rolc a
    rolc a
    rolc a
    rolc a
    mov r1, a
    mov a, 0x0146
    and a, #0x3f
    or a, r1
    mov 0x0146, a
    ret

sub_f644:
    mov r2, a
    mov r1, #0x00
    mov a, r0
    beq lab_f657
    mov a, r2
    beq lab_f659
    clrc
    subc a, r0
    blo lab_f65a
    mov r1, #0x64
    clrc
    subc a, r0
    blo lab_f65a

lab_f657:
    mov r1, #0xc8

lab_f659:
    ret

lab_f65a:
    clrc
    addc a, r0
    mov a, #0x64
    mulu a
    movw 0xd4, a
    movw a, 0xd4
    mov a, r0
    divu a
    clrc
    addc a, r1
    mov r1, a
    jmp lab_f659

sub_f66b:
    mov a, r1
    cmp a, #0x28
    bhs lab_f673
    mov r1, #0x02

lab_f672:
    ret

lab_f673:
    cmp a, #0x62
    bhs lab_f67c
    mov r1, #0x01
    jmp lab_f672

lab_f67c:
    cmp a, #0x79
    bhs lab_f685
    mov r1, #0x03
    jmp lab_f672

lab_f685:
    cmp a, #0x86
    bhs lab_f68e
    mov r1, #0x00
    jmp lab_f672

lab_f68e:
    mov r1, #0x02
    jmp lab_f672

sub_f693:
;called from irq2_e187: irq2 (external interrupt #2) clipping input
    mov a, 0xcc
    bne lab_f6a5
    mov 0xcc, #0x01
    setb eic2:1
    clrb cntr:3
    mov comr, #0x96
    mov cntr, #0x19
    ret

lab_f6a5:
    cmp a, #0x01
    bne lab_f6b7
    mov 0xcc, #0x02
    clrb eic2:1
    clrb cntr:3
    mov comr, #0x64
    mov cntr, #0x19
    ret

lab_f6b7:
    setb 0xcd:5
    setb 0xce:0
    mov cntr, #0x10
    clrb eic2:0
    ret

sub_f6c1:
;called from irq4_e163: irq4 (8-bit pwm timer)
    mov a, 0xcc
    cmp a, #0x01
    bne lab_f6d1
    setb 0xcd:5
    setb 0xce:0
    mov cntr, #0x10
    clrb eic2:0
    ret

lab_f6d1:
    cmp a, #0x02
    bne lab_f6de
    setb 0xcd:5
    clrb 0xce:0
    mov cntr, #0x10
    clrb eic2:0

lab_f6de:
    ret


sub_f6df:
;TODO seems ADC related
    mov a, 0xd1
    bne lab_f711
    bbc 0x00cd:7, lab_f707

lab_f6e6:
    mov 0xcf, #0x19
    clrb 0xcd:7
    setb 0xcd:6
    mov adc2, #0x01
    mov adc1, #0x71

lab_f6f3:
    bbc adc1:3, lab_f6f3
    mov a, adcd
    cmp a, #0x0d
    blo lab_f70d
    setb 0xcd:1
    clrb 0xcd:4

lab_f700:
    call sub_f749
    call sub_f72d
    ret

lab_f707:
    bbc 0x00cd:6, lab_f6e6
    jmp lab_f700

lab_f70d:
    cmp a, #0x02
    bhs lab_f718

lab_f711:
    setb 0xcd:2
    clrb 0xcd:4
    jmp lab_f700

lab_f718:
    bbs 0x00cd:4, lab_f700
    mov 0xcc, #0x00
    clrb 0xcd:5
    clrb eic2:1
    clrb cntr:2
    clrb eic2:3
    setb 0xcd:4
    setb eic2:0
    jmp lab_f700

sub_f72d:
    bbc 0x00cd:1, lab_f73a
    clrb 0xcd:1
    bbs 0x00cd:0, lab_f739
    setb 0xcd:0
    setb 0xcd:3

lab_f739:
    ret

lab_f73a:
    bbc 0x00cd:2, lab_f739
    clrb 0xcd:2
    bbc 0x00cd:0, lab_f739
    clrb 0xcd:0
    setb 0xcd:3
    jmp lab_f739

sub_f749:
    bbc 0x00cd:4, lab_f760
    bbc 0x00cd:5, lab_f766
    bbc 0x00ce:0, lab_f761
    setb 0xcd:2

lab_f754:
    mov a, #0x0a
    mov 0xd0, a
    clrb 0xce:2
    setb 0xce:1
    clrb 0xcd:5
    clrb 0xce:0

lab_f760:
    ret

lab_f761:
    setb 0xcd:1
    jmp lab_f754

lab_f766:
    bbc 0x00ce:2, lab_f760
    clrb 0xce:2
    mov 0xcc, #0x00
    clrb eic2:1
    clrb cntr:2
    clrb eic2:3
    setb eic2:0
    jmp lab_f760

upd_read_key_data:
;Read key data from uPD16432B
;
    setb pdr0:2             ;UPD_STB = high (select uPD16432B)

    mov a, #0x44            ;Command byte = 0x44 (0b01000100)
                            ;Data Setting Command
                            ;  4=Read key data
    call upd_send_byte      ;Send byte in A to the uPD16432B

    mov ddr0, #0x0e
    setb pdr0:0             ;UPD_DATA = high
    setb pdr0:1             ;UPD_CLK = high
    movw a, #0x008f         ;A = pointer to 4-byte buffer for key data
    movw 0x80, a            ;Save pointer to buffer in 0x80
    mov 0x82, #0x04         ;4 bytes left to receive

lab_f78f:
    mov a, 0x82             ;A = number of bytes left to receive
    beq lab_f7bd            ;Branch if no more bytes left
    decw a                  ;Decrement number of bytes left
    mov 0x82, a             ;Save number of bytes left
    mov 0x84, #0x08         ;8 bits left to receive

lab_f799:
;Receive a byte of key data from uPD16432B
;
    mov a, 0x84             ;A = number of bits left to receive
    beq lab_f7b5            ;Branch if no more bits left
    decw a
    mov 0x84, a
    clrb pdr0:1             ;UPD_CLK = low
    nop
    nop
    setb pdr0:1             ;UPD_CLK = high

    movw a, 0x80            ;A = pointer to 4-byte key data buffer
    movw ep, a              ;EP = A
    mov a, @ep              ;Get current byte from buffer
    clrc
    rolc a                  ;Rotate 0 into the byte
    mov @ep, a              ;Store byte back in the buffer

    bbc pdr0:0, lab_f799    ;Branch if UPD_DATA = low
    or a, #0x01             ;Set bit 0 in the byte
    mov @ep, a              ;Store byte back in the buffer

    bne lab_f799

lab_f7b5:
    movw a, 0x80            ;A = pointer to 4-byte key data buffer
    incw a                  ;Increment it
    movw 0x80, a            ;Store it
    jmp lab_f78f

lab_f7bd:
;All 4 bytes of key data have been received from uPD16432B
;
    clrb pdr0:2             ;UPD_STB = low (deselect uPD16432B)

    ;Compare 0x008b-0x008e buffer with 0x008f-0x0092 buffer
    movw ix, #0x008b
    mov a, 0x8f             ;A = Byte 0 of 4-byte key data buffer
    xor a, @ix+0x00         ;XOR with 0x008b
    mov a, 0x90             ;A = Byte 1 of 4-byte key data buffer
    xor a, @ix+0x01         ;XOR with 0x008c
    or a
    mov a, 0x91             ;A = Byte 2 of 4-byte key data buffer
    xor a, @ix+0x02         ;XOR with 0x008d
    or a
    mov a, 0x92             ;A = Byte 3 of 4-byte key data buffer
    xor a, @ix+0x03         ;XOR with 0x008e
    or a
    bne lab_f80e

    mov a, 0x0108
    bne lab_f801

    ;Compare 0x0093-0x0096 buffer with 0x008f-0x0092 buffer
    movw ix, #0x0093
    mov a, 0x8f             ;A = Byte 0 of 4-byte key data buffer
    xor a, @ix+0x00         ;XOR with 0x0093
    mov a, 0x90             ;A = Byte 1 of 4-byte key data buffer
    xor a, @ix+0x01         ;XOR with 0x0094
    or a
    mov a, 0x91             ;A = Byte 2 of 4-byte key data buffer
    xor a, @ix+0x02         ;XOR with 0x0095
    or a
    mov a, 0x92             ;A = Byte 3 of 4-byte key data buffer
    xor a, @ix+0x03         ;XOR with 0x0096
    or a
    beq lab_f81b

    movw a, 0x8f            ;Copy 4-byte key data buffer
    movw 0x93, a            ;  from 0x008f-0x0092
    movw a, 0x91            ;  to   0x0093-0x0096
    movw 0x95, a

    setb 0x88:0             ;Set "key data ready" flag
    jmp lab_f81b

lab_f801:
    movw a, #0x0000
    mov a, 0x0108
    decw a
    mov 0x0108, a
    jmp lab_f81b

lab_f80e:
    movw a, 0x8f            ;Copy 4-byte key data buffer
    movw 0x8b, a            ;  from 0x008f-0x0092
    movw a, 0x91            ;  to   0x008b-0x008e
    movw 0x8d, a

    mov a, #0x02
    mov 0x0108, a

lab_f81b:
    ret

parse_upd_key_data:
;Parse 4 bytes of key data from uPD16432B
    mov 0x85, #0x1c
    mov 0x82, #0x00
    mov 0x83, #0x00
    mov 0x84, #0x04         ;Counter: 4 bytes of key data to process
    movw ep, #0x0093        ;EP = pointer to 4-byte key data buffer

lab_f82b:
    mov a, @ep              ;A = byte from key data buffer
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit
    call parse_upd_key_bit

    incw ep                 ;Move to next byte in key data buffer

    movw a, #0x0000         ;Decrement count of key data bytes to process
    mov a, 0x84
    decw a
    mov 0x84, a
    bne lab_f82b            ;Keep going until 4 bytes have been processed

    mov a, 0x83
    bne lab_f86e            ;TODO what is 0x0083?

    ;0x0083 = 0
    movw a, #0x0000         ;Clear 0x008b-0x0096:
    movw 0x8f, a            ;    Clear 0x008f-0x0090
    movw 0x91, a            ;    Clear 0x0091-0x0092
    movw 0x8b, a            ;    Clear 0x008b-0x008c
    movw 0x8d, a            ;    Clear 0x008d-0x008e
    movw 0x93, a            ;    Clear 0x0093-0x0094
    movw 0x95, a            ;    Clear 0x0095-0x0096

    clrb 0x89:0
    mov 0xd6, #0x00
    setb 0x88:1

lab_f869:
    mov a, #0x20
    mov 0x8a, a

lab_f86d:
    ret

lab_f86e:
;A is from 0x0083, and A != 0
    cmp a, #0x01
    bne lab_f895
    bbs 0x0089:0, lab_f884
    setb 0x89:0
    mov a, 0x85

lab_f879:
    or a, #0x80
    mov 0x8a, a
    setb 0x88:1
    clrb 0x89:7
    jmp lab_f86d

lab_f884:
    mov a, 0x85
    mov a, 0x8a
    cmp a
    beq lab_f86d
    bbs 0x0089:7, lab_f86d
    setb 0x88:1

lab_f890:
    setb 0x89:7
    jmp lab_f869

lab_f895:
;A is from 0x0083, A != 0, A != 1
    cmp a, #0x03
    bne lab_f890
    cmp 0xd6, #0x07
    bne lab_f8a1
    bbs 0x0089:0, lab_f890

lab_f8a1:
    mov a, 0xd3
    call sub_f939
    mov a, 0x86
    call sub_f939
    mov a, 0x85
    call sub_f939
    cmp 0xd6, #0x07
    bne lab_f890
    setb 0x89:0
    mov a, #0x19
    bne lab_f879

parse_upd_key_bit:
    rolc a                  ;Rotate left, store bit 7 in carry
    bnc lab_f8d8            ;Branch if no carry

    mov a, 0x86
    mov 0xd3, a
    xch a, t

    mov a, 0x85
    mov 0x86, a
    xch a, t

    mov a, 0x82
    mov 0x85, a
    xch a, t

    cmp 0x83, #0x04
    bhs lab_f8d8

    mov a, 0x83
    incw a
    mov 0x83, a
    xch a, t

lab_f8d8:
    mov a, 0x82
    incw a
    mov 0x82, a
    xch a, t
    ret

try_parse_mfsw:
    mov a, 0x0127           ;Get byte from MFSW
    cmp a, #0xff            ;Is it 0xFF (no MFSW key)?
    bne parse_mfsw_byte     ;  No: branch to handle MFSW key
    bbc 0x0089:3, lab_f8f3
    clrb 0x89:3
    clrb 0x89:0

lab_f8ed:
    mov a, #0x20
    mov 0x8a, a
    setb 0x88:1

lab_f8f3:
    ret

parse_mfsw_byte_good:
    or a, #0x80
    mov 0x8a, a
    setb 0x88:1
    setb 0x89:3
    setb 0x89:0

parse_mfsw_byte_done:
    ret

parse_mfsw_byte:
;Parse MFSW key code in 0x0127
    bbs 0x0089:0, lab_f928
    mov a, 0x0127
    mov 0x014c, a

    ;MFSW 0x00 -> Key Code 0x1c (vol down)
    cmp a, #0x00            ;MSFW key = 0x00?
    bne parse_mfsw_try_01   ;No: branch to try next MFSW key
    mov a, #0x1c            ;A = key code for vol down
    bne parse_mfsw_byte_good ;Branch always

parse_mfsw_try_01:
    ;MFSW 0x01 -> Key Code 0x1d (vol up)
    cmp a, #0x01            ;MFSW key = 0x01?
    bne parse_mfsw_try_0a   ;No: branch to try next MFSW key
    mov a, #0x1d            ;A = key code for vol up
    bne parse_mfsw_byte_good ;Branch always

parse_mfsw_try_0a:
    ;MFSW 0x0a -> Key Code 0x1e (down)
    cmp a, #0x0a            ;MFSW key = 0x0a?
    bne parse_mfsw_try_0b   ;No: branch to try next MFSW key
    mov a, #0x1e            ;A = key code for down
    bne parse_mfsw_byte_good ;Branch always

parse_mfsw_try_0b:
    ;MFSW 0x0b -> Key Code 0x1f (up)
    cmp a, #0x0b            ;MFSW key = 0x0b?
    bne parse_mfsw_byte_done ;No: branch to done, no more MFSW keys to try
    mov a, #0x1f            ;fA = key code for up
    bne parse_mfsw_byte_good ;Branch always

lab_f928:
    mov a, 0x0127
    mov a, 0x014c
    cmp a
    beq parse_mfsw_byte_done ;branch to return
    mov a, #0xfe
    mov 0x014c, a
    jmp lab_f8ed            ;jmp to ret

sub_f939:
    cmp a, #0x18
    bne lab_f940
    setb 0xd6:0
    ret

lab_f940:
    cmp a, #0x06
    bne lab_f947
    setb 0xd6:1
    ret

lab_f947:
    cmp a, #0x00
    bne lab_f94d
    setb 0xd6:2

lab_f94d:
    ret

upd_send_all_data:
;Send uPD16432B characters and pictographs
;
;Reads 11 bytes of uPD16432B display data to 0x012f-0x139.  The faceplate LCD
;has the characters in reverse order so the buffer is read backwards.
;
;Reads 8 bytes of uPD16432B pictograph data to 0x00a1-0x00a8.
;
    pushw ix

    mov a, #0x40            ;Command byte = 0x40 (0b01000000)
                            ;Data Setting Command
                            ;  0=Write to display RAM
                            ;  Address increment mode: 0=increment
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B

    movw ix, #0x012f+11     ;IX = first byte of display data to send

    mov a, #0x82            ;Command byte = 0x82 (0b10000010)
                            ;  Address Setting Command
                            ;  Address = 02

    setb pdr0:2             ;UPD_STB = high (select uPD16432B)
    nop
    nop

lab_f95d:
;Send 11 display data bytes
    call upd_send_byte      ;Send byte in A to the uPD16432B

    movw a, ix
    movw a, #0x012f
    cmpw a                  ;Last byte of display data sent?
    beq lab_f96d            ;Yes: we're done, branch out

    decw ix                 ;Move pointer to next display data byte
    mov a, @ix+0x00         ;A = display data byte to send

    jmp lab_f95d

lab_f96d:
    clrb pdr0:2             ;UPD_STB = low (deselect uPD16432B)
    nop
    nop

    mov a, #0x41            ;Command byte = 0x41 (0b01000001)
                            ;Data Setting Command
                            ;  1=Write to pictograph RAM
                            ;  Address
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B


    movw ix, #0x00a1-1      ;IX = pointer to pictograph bytes - 1

    mov a, #0x80            ;Command byte = 0x80 (0b10000000)
                            ;Address Setting Command
                            ;  Address = 00

    setb pdr0:2             ;UPD_STB = high (select uPD16432B)
    nop
    nop

lab_f97f:
;Send 8 pictograph bytes
    call upd_send_byte      ;Send byte in A to the uPD16432B

    movw a, ix              ;A = pointer to pictographs buffer
    movw a, #0x00a8         ;A = pointer to end of buffer + 1
    cmpw a                  ;Reached the end of the buffer?
    beq lab_f98f            ;  Yes: branch out

    incw ix                 ;Increment pointer to pictographs buffer
    mov a, @ix+0x00         ;A = pictograph byte from buffer

    jmp lab_f97f            ;Jump to send the byte

lab_f98f:
    clrb pdr0:2             ;UPD_STB = low (deselect uPD16432B)
    popw ix
    ret

upd_init_and_clear:
;Initialize the uPD16432B and clear the display
;
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    mov a, #0x04            ;Command byte = 0x04 (0b00000100)
                            ;Display Setting Command
                            ;  Duty setting: 0=1/8 duty
                            ;  Master/slave setting: 0=master
                            ;  Drive voltage supply method: 1=internal
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B

    mov a, #0xcf            ;Command byte = 0xcf (0b11001111)
                            ;Status command
                            ;  Test mode setting: 0=Normal operation
                            ;  Standby mode setting: 0=Normal operation
                            ;  Key scan control: 1=Key scan operation
                            ;  LED control: 1=Normal operation
                            ;  LCD mode: 3=Normal operation (0b11)
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B

    mov a, #0x20            ;A = 0x2020 (two space characters)
    swap
    mov a, #0x20
    movw ix, #0x012f        ;IX = 0x012f (display buffer)
    movw @ix+0x00, a        ;Fill all 11 bytes of display buffer
    movw @ix+0x02, a
    movw @ix+0x04, a
    movw @ix+0x06, a
    movw @ix+0x08, a
    mov @ix+0x0a, a

    movw a, #0x0000         ;A = 0 (two empty pictograph bytes)
    movw ix, #0x00a1        ;IX = 0x00a1 (pictograph buffer)
    movw @ix+0x00, a        ;Fill all 8 bytes of pictograph buffer
    movw @ix+0x02, a
    movw @ix+0x04, a
    movw @ix+0x06, a

    call upd_send_all_data  ;Send characters and pictographs to uPD16432B
    setb 0xa9:6
    ret

upd_send_cmd_byte:
;Send a single-byte command to the uPD16432B
;STB is activated before the byte and deactivated after.
;
    setb pdr0:2             ;UPD_STB = high (select uPD16432B)
    nop
    nop
    call upd_send_byte      ;Send byte in A to the uPD16432B
    nop
    nop
    clrb pdr0:2             ;UPD_STB = low (deselect uPD16432B)
    nop
    nop
    ret

upd_send_byte:
;Send byte in A to uPD16432B
;STB is unaffected.
;
    mov ddr0, #0x0f
    setb pdr0:1             ;UPD_CLK = high
    mov r7, #0x08

lab_f9e2:
    rolc a
    bnc lab_f9e9
    setb pdr0:0             ;UPD_DATA = high
    bc lab_f9eb

lab_f9e9:
    clrb pdr0:0             ;UPD_DATA = low

lab_f9eb:
    clrb pdr0:1             ;UPD_CLK = low
    nop
    nop
    setb pdr0:1             ;UPD_CLK = high
    dec r7
    bne lab_f9e2
    ret

upd_init_and_write:
;Initialize uPD16432B and write all data
;
    bbc 0x0087:7, lab_fa08
    clrb 0x87:7

    mov a, #0x04            ;Command byte = 0x04 (0b00000100)
                            ;Display Setting Command
                            ;  Duty setting: 0=1/8 duty
                            ;  Master/slave setting: 0=master
                            ;  Drive voltage supply method: 1=internal
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B

    mov a, #0xcf            ;Command byte = 0xcf (0b11001111)
                            ;Status command
                            ;  Test mode setting: 0=Normal operation
                            ;  Standby mode setting: 0=Normal operation
                            ;  Key scan control: 1=Key scan operation
                            ;  LED control: 1=Normal operation
                            ;  LCD mode: 3=Normal operation (0b11)
    call upd_send_cmd_byte  ;Send single-byte command to uPD16432B

    call upd_send_all_data  ;Send characters and pictographs to uPD16432B
    ret

lab_fa08:
    bbc 0x0087:2, lab_fa0f
    clrb 0x87:2
    setb 0x87:7

lab_fa0f:
    ret

sub_fa10:
    mov a, 0x0145
    beq lab_fa19
    decw a
    mov 0x0145, a

lab_fa19:
    bbc 0x00cd:6, lab_fa2a
    movw a, #0x0000
    mov a, 0xcf
    decw a
    mov 0xcf, a
    bne lab_fa2a
    clrb 0xcd:6
    setb 0xcd:7

lab_fa2a:
    bbc 0x00ce:1, lab_fa3b
    movw a, #0x0000
    mov a, 0xd0
    decw a
    mov 0xd0, a
    bne lab_fa3b
    clrb 0xce:1
    setb 0xce:2

lab_fa3b:
    mov a, 0x99
    incw a
    mov 0x99, a
    cmp a, #0x0a
    blo lab_fa58
    mov 0x99, #0x00
    setb 0x97:0
    movw a, #0x0000
    mov a, 0x98
    decw a
    mov 0x98, a
    bne lab_fa58
    mov 0x98, #0x0a
    setb 0x97:1

lab_fa58:
    ret

sub_fa59:
    bbc 0x0097:0, lab_fa61
    clrb 0x97:0
    call sub_fa6a

lab_fa61:
    bbc 0x0097:1, lab_fa69
    clrb 0x97:1
    call sub_fad2

lab_fa69:
    ret

sub_fa6a:
    bbc 0x00a9:6, lab_fa70
    call upd_read_key_data  ;Read key data from uPD16432B

lab_fa70:
    bbc 0x00d2:2, lab_fa83
    movw a, #0x0000
    mov a, 0x0149
    decw a
    mov 0x0149, a
    bne lab_fa83
    clrb 0xd2:2
    setb 0xd2:3

lab_fa83:
    bbc 0x009a:1, lab_fa96
    movw a, #0x0000
    mov a, 0x0121
    decw a
    mov 0x0121, a
    bne lab_fa96
    clrb 0x9a:1
    setb 0x9a:2

lab_fa96:
    bbc 0x009b:6, lab_faa7
    movw a, #0x0000
    mov a, 0x9f
    decw a
    mov 0x9f, a
    bne lab_faa7
    clrb 0x9b:6
    setb 0x9b:7

lab_faa7:
    mov a, 0x0123
    beq lab_fab0
    decw a
    mov 0x0123, a

lab_fab0:
    bbc 0x009b:2, lab_fac1
    movw a, #0x0000
    mov a, 0x9d
    decw a
    mov 0x9d, a
    bne lab_fac1
    clrb 0x9b:2
    setb 0x9b:3

lab_fac1:
    mov a, 0x013a
    beq lab_faca
    decw a
    mov 0x013a, a

lab_faca:
    mov a, 0xcb
    beq lab_fad1
    decw a
    mov 0xcb, a

lab_fad1:
    ret

sub_fad2:
    mov a, 0xc7
    beq lab_fad9
    decw a
    mov 0xc7, a

lab_fad9:
    mov a, 0xc9
    beq lab_fae0
    decw a
    mov 0xc9, a

lab_fae0:
    mov a, 0xd1
    beq lab_fae7
    decw a
    mov 0xd1, a

lab_fae7:
    ret

    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    .byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

    .word reset_e012        ;ffc0  e0 12       VECTOR callv #0
    .word reset_e012        ;ffc2  e0 12       VECTOR callv #1
    .word reset_e012        ;ffc4  e0 12       VECTOR callv #2
    .word reset_e012        ;ffc6  e0 12       VECTOR callv #3
    .word reset_e012        ;ffc8  e0 12       VECTOR callv #4
    .word reset_e012        ;ffca  e0 12       VECTOR callv #5
    .word reset_e012        ;ffcc  e0 12       VECTOR callv #6
    .word reset_e012        ;ffce  e0 12       VECTOR callv #7
    .word 0xffff            ;ffd0  ff ff       VECTOR irq15 (unused)
    .word 0xffff            ;ffd2  ff ff       VECTOR irq14 (unused)
    .word 0xffff            ;ffd4  ff ff       VECTOR irq13 (unused)
    .word 0xffff            ;ffd6  ff ff       VECTOR irq12 (unused)
    .word 0xffff            ;ffd8  ff ff       VECTOR irq11 (unused)
    .word 0xffff            ;ffda  ff ff       VECTOR irq10 (unused)
    .word 0xffff            ;ffdc  ff ff       VECTOR irqf (unused)
    .word 0xffff            ;ffde  ff ff       VECTOR irqe (unused)
    .word 0xffff            ;ffe0  ff ff       VECTOR irqd (unused)
    .word 0xffff            ;ffe2  ff ff       VECTOR irqc (unused)
    .word reset_e012        ;ffe4  e0 12       VECTOR irqb (unused)
    .word reset_e012        ;ffe6  e0 12       VECTOR irqa (timebase timer)
    .word reset_e012        ;ffe8  e0 12       VECTOR irq9 (a/d converter)
    .word reset_e012        ;ffea  e0 12       VECTOR irq8 (8-bit serial I/O #2)
    .word irq7_e0cb         ;ffec  e0 cb       VECTOR irq7 (8-bit serial I/O #1)
    .word irq6_e0dd         ;ffee  e0 dd       VECTOR irq6 (16-bit timer/counter)
    .word irq5_e0ef         ;fff0  e0 ef       VECTOR irq5 (pulse width count timer)
    .word irq4_e163         ;fff2  e1 63       VECTOR irq4 (8-bit pwm timer)
    .word irq3_e175         ;fff4  e1 75       VECTOR irq3 (external interrupt #3)
    .word irq2_e187         ;fff6  e1 87       VECTOR irq2 (external interrupt #2)
    .word reset_e012        ;fff8  e0 12       VECTOR irq1 (external interrupt #1)
    .word irq0_e199         ;fffa  e1 99       VECTOR irq0 (external interrupt #0)
    .byte 0xFF              ;fffc  ff          DATA '\xff'
    .byte 0x00              ;fffd  00          DATA '\x00'
    .word reset_e012        ;fffe  e0 12       VECTOR reset
