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
    mov pdr0, #0xf3         ;e012  85 00 f3
    mov ddr0, #0x07         ;e015  85 01 07
    mov pdr1, #0xbf         ;e018  85 02 bf
    mov ddr1, #0x40         ;e01b  85 03 40
    mov pdr2, #0x01         ;e01e  85 04 01
    mov pdr3, #0x3f         ;e021  85 0c 3f
    mov ddr3, #0xf4         ;e024  85 0d f4
    mov pdr4, #0xff         ;e027  85 0e ff
    mov pdr5, #0xff         ;e02a  85 10 ff
    mov pdr6, #0xff         ;e02d  85 11 ff
    movw ix, #0x0080        ;e030  e6 00 80

lab_e033:
    mov a, #0x00            ;e033  04 00
    mov @ix+0x00, a         ;e035  46 00
    incw ix                 ;e037  c2
    movw a, ix              ;e038  f2
    movw a, #0x027f         ;e039  e4 02 7f
    cmpw a                  ;e03c  13
    bne lab_e033            ;e03d  fc f4
    movw a, #0x027f         ;e03f  e4 02 7f
    movw sp, a              ;e042  e1
    movw a, #0x0030         ;e043  e4 00 30
    movw ps, a              ;e046  71
    mov a, #0x0a            ;e047  04 0a
    .byte 0x61, 0x00, 0xd1  ;e049  61 00 d1     mov 0x00d1, a
    mov a, #0x20            ;e04c  04 20
    .byte 0x61, 0x00, 0x8a  ;e04e  61 00 8a     mov 0x008a, a
    mov 0xaa, #0x09         ;e051  85 aa 09
    call sub_e0b8           ;e054  31 e0 b8
    call sub_e1c0           ;e057  31 e1 c0
    mov 0x98, #0x05         ;e05a  85 98 05
    mov a, #0x05            ;e05d  04 05
    mov 0x013a, a           ;e05f  61 01 3a
    mov a, #0x14            ;e062  04 14
    mov 0x0145, a           ;e064  61 01 45
    mov a, #0x14            ;e067  04 14
    .byte 0x61, 0x00, 0xc9  ;e069  61 00 c9     mov 0x00c9, a

lab_e06c:
    bbc 0x00a9:7, lab_e075  ;e06c  b7 a9 06
    bbs 0x00a9:6, lab_e075  ;e06f  be a9 03
    call upd_init_and_clear ;e072  31 f9 93     Initialize uPD16432B and clear display

lab_e075:
    call sub_fa59           ;e075  31 fa 59
    call sub_e40c           ;e078  31 e4 0c
    bbc 0x0088:0, lab_e086  ;e07b  b0 88 08     Branch if "key data ready" flag is clear
    clrb 0x88:0             ;e07e  a0 88        Clear "key data ready" flag for next time
    call parse_upd_key_data ;e080  31 f8 1c     Parse 4 bytes of key data from uPD16432B
    jmp lab_e089            ;e083  21 e0 89

lab_e086:
    call try_parse_mfsw     ;e086  31 f8 df     Try to get a key code from MFSW

lab_e089:
    bbc 0x00a9:6, lab_e08f  ;e089  b6 a9 03
    call upd_init_and_write ;e08c  31 f9 f5     Initialize uPD16432B and write all data

lab_e08f:
    call sub_f3c7           ;e08f  31 f3 c7
    call sub_e20a           ;e092  31 e2 0a
    call m2s_cmd_process    ;e095  31 e2 6e     Process a Main-to-Sub command packet if one is ready
    call m2s_update_display ;e098  31 e5 5b     Process Main-to-Sub display update command if one was received
    call sub_f1ac           ;e09b  31 f1 ac     TODO seems FIS related
    call sub_f6df           ;e09e  31 f6 df     TODO seems ADC related
    call sub_f541           ;e0a1  31 f5 41
    call sub_e0aa           ;e0a4  31 e0 aa
    jmp lab_e06c            ;e0a7  21 e0 6c


sub_e0aa:
    mov a, 0x013a           ;e0aa  60 01 3a     TODO what is 0x013a?
    bnz lab_e0b2            ;e0ad  fc 03
    bbc 0x009c:1, lab_e0b5  ;e0af  b1 9c 03     Branch if "play dead" flag is clear
lab_e0b2:
    ;Playing dead
    clrb pdr0:3             ;e0b2  a3 00        UPD_OE = low (turn off uPD16432B LCD display)
    ret                     ;e0b4  20
lab_e0b5:
    ;Not playing dead
    setb pdr0:3             ;e0b5  ab 00        UPD_OE = high (turn on uPD16432B LCD display)
    ret                     ;e0b7  20


sub_e0b8:
    movw a, ps              ;e0b8  70           Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;e0b9  e4 00 ff       R0=0x100, R1=0x101...
    andw a                  ;e0bc  63
    movw ps, a              ;e0bd  71

    call sub_f59f           ;e0be  31 f5 9f
    call sub_f5c3           ;e0c1  31 f5 c3
    call sub_f5ec           ;e0c4  31 f5 ec
    call sub_f617           ;e0c7  31 f6 17
    ret                     ;e0ca  20

irq7_e0cb:
;irq7 (8-bit serial I/O #1)
;main-to-sub spi bus
    pushw a                 ;e0cb  40
    xchw a, t               ;e0cc  43
    pushw a                 ;e0cd  40
    pushw ix                ;e0ce  41
    movw a, ep              ;e0cf  f3
    pushw a                 ;e0d0  40
    clrb smr1:7             ;e0d1  a7 1c
    call sub_e2ff           ;e0d3  31 e2 ff
    popw a                  ;e0d6  50
    movw ep, a              ;e0d7  e3
    popw ix                 ;e0d8  51
    popw a                  ;e0d9  50
    xchw a, t               ;e0da  43
    popw a                  ;e0db  50
    reti                    ;e0dc  30

irq6_e0dd:
;irq6 (16-bit timer/counter)
    pushw a                 ;e0dd  40
    xchw a, t               ;e0de  43
    pushw a                 ;e0df  40
    pushw ix                ;e0e0  41
    movw a, ep              ;e0e1  f3
    pushw a                 ;e0e2  40
    clrb tmcr:2             ;e0e3  a2 18
    call sub_e437           ;e0e5  31 e4 37
    popw a                  ;e0e8  50
    movw ep, a              ;e0e9  e3
    popw ix                 ;e0ea  51
    popw a                  ;e0eb  50
    xchw a, t               ;e0ec  43
    popw a                  ;e0ed  50
    reti                    ;e0ee  30

irq5_e0ef:
;irq5 (pulse width count timer)
    pushw a                 ;e0ef  40
    xchw a, t               ;e0f0  43
    pushw a                 ;e0f1  40
    pushw ix                ;e0f2  41
    movw a, ep              ;e0f3  f3
    pushw a                 ;e0f4  40
    clrb pcr1:2             ;e0f5  a2 14
    movw a, #0x0000         ;e0f7  e4 00 00
    mov a, 0xaa             ;e0fa  05 aa
    beq lab_e107            ;e0fc  fd 09
    decw a                  ;e0fe  d0
    mov 0xaa, a             ;e0ff  45 aa
    bne lab_e107            ;e101  fc 04
    setb pdr1:6             ;e103  ae 02        TODO what is pdr1:6?
    setb 0xa9:7             ;e105  af a9

lab_e107:
    mov a, #0x80            ;e107  04 80
    xor a, 0xd2             ;e109  55 d2
    mov 0xd2, a             ;e10b  45 d2
    call sub_e2b2           ;e10d  31 e2 b2
    bbc 0x00d2:7, lab_e14a  ;e110  b7 d2 37
    call sub_fa10           ;e113  31 fa 10
    bbs pdr3:0, lab_e151    ;e116  b8 0c 38     Branch if /M2S_ENA_IN = high
    bbs 0x009b:1, lab_e12d  ;e119  b9 9b 11
    setb 0x9b:1             ;e11c  a9 9b
    mov a, #0x05            ;e11e  04 05
    mov 0xcb, a             ;e120  45 cb

    mov a, #0x00            ;e122  04 00        Reset count of bytes received from Main-MCU
    mov 0x0122, a           ;e124  61 01 22

    clrb smr1:0             ;e127  a0 1c
    nop                     ;e129  00
    nop                     ;e12a  00
    setb smr1:0             ;e12b  a8 1c

lab_e12d:
    mov a, 0xc4             ;e12d  05 c4
    beq lab_e134            ;e12f  fd 03
    decw a                  ;e131  d0
    mov 0xc4, a             ;e132  45 c4

lab_e134:
    mov a, 0xca             ;e134  05 ca
    beq lab_e13b            ;e136  fd 03
    decw a                  ;e138  d0
    mov 0xca, a             ;e139  45 ca

lab_e13b:
    mov a, 0xc8             ;e13b  05 c8
    beq lab_e142            ;e13d  fd 03
    decw a                  ;e13f  d0
    mov 0xc8, a             ;e140  45 c8

lab_e142:
    bbc pdr4:7, lab_e156    ;e142  b7 0e 11     ;Branch if DISP_ENA_IN = low
    mov a, 0xc5             ;e145  05 c5
    incw a                  ;e147  c0
    mov 0xc5, a             ;e148  45 c5

lab_e14a:
    popw a                  ;e14a  50
    movw ep, a              ;e14b  e3
    popw ix                 ;e14c  51
    popw a                  ;e14d  50
    xchw a, t               ;e14e  43
    popw a                  ;e14f  50
    reti                    ;e150  30

lab_e151:
    clrb 0x9b:1             ;e151  a1 9b
    jmp lab_e12d            ;e153  21 e1 2d

lab_e156:
;DISP_ENA_IN is low
    mov a, 0xc5             ;e156  05 c5
    beq lab_e14a            ;e158  fd f0
    mov 0xc6, a             ;e15a  45 c6
    mov a, #0x00            ;e15c  04 00
    mov 0xc5, a             ;e15e  45 c5
    jmp lab_e14a            ;e160  21 e1 4a

irq4_e163:
;irq4 (8-bit pwm timer)
    pushw a                 ;e163  40
    xchw a, t               ;e164  43
    pushw a                 ;e165  40
    pushw ix                ;e166  41
    movw a, ep              ;e167  f3
    pushw a                 ;e168  40
    clrb cntr:2             ;e169  a2 12
    call sub_f6c1           ;e16b  31 f6 c1
    popw a                  ;e16e  50
    movw ep, a              ;e16f  e3
    popw ix                 ;e170  51
    popw a                  ;e171  50
    xchw a, t               ;e172  43
    popw a                  ;e173  50
    reti                    ;e174  30

irq3_e175:
;irq3 (external interrupt #3)
;diag ill input
    pushw a                 ;e175  40
    xchw a, t               ;e176  43
    pushw a                 ;e177  40
    pushw ix                ;e178  41
    movw a, ep              ;e179  f3
    pushw a                 ;e17a  40
    clrb eic2:7             ;e17b  a7 25
    call sub_f44b           ;e17d  31 f4 4b
    popw a                  ;e180  50
    movw ep, a              ;e181  e3
    popw ix                 ;e182  51
    popw a                  ;e183  50
    xchw a, t               ;e184  43
    popw a                  ;e185  50
    reti                    ;e186  30

irq2_e187:
;irq2 (external interrupt #2)
;clipping input
    pushw a                 ;e187  40
    xchw a, t               ;e188  43
    pushw a                 ;e189  40
    pushw ix                ;e18a  41
    movw a, ep              ;e18b  f3
    pushw a                 ;e18c  40
    clrb eic2:3             ;e18d  a3 25
    call sub_f693           ;e18f  31 f6 93
    popw a                  ;e192  50
    movw ep, a              ;e193  e3
    popw ix                 ;e194  51
    popw a                  ;e195  50
    xchw a, t               ;e196  43
    popw a                  ;e197  50
    reti                    ;e198  30

irq0_e199:
;irq0 (external interrupt #0)
;mfsw input
    pushw a                 ;e199  40
    xchw a, t               ;e19a  43
    pushw a                 ;e19b  40
    pushw ix                ;e19c  41
    movw a, ep              ;e19d  f3
    pushw a                 ;e19e  40
    clrb eic1:3             ;e19f  a3 24
    call sub_e34e           ;e1a1  31 e3 4e
    popw a                  ;e1a4  50
    movw ep, a              ;e1a5  e3
    popw ix                 ;e1a6  51
    popw a                  ;e1a7  50
    xchw a, t               ;e1a8  43
    popw a                  ;e1a9  50
    reti                    ;e1aa  30

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
    mov tbtc, #0x00         ;e1c0  85 0a 00
    mov wdtc, #0x00         ;e1c3  85 09 00
    mov cntr, #0x00         ;e1c6  85 12 00
    mov comr, #0x00         ;e1c9  85 13 00
    mov rlbr, #0x1f         ;e1cc  85 16 1f
    mov pcr2, #0x08         ;e1cf  85 15 08
    mov pcr1, #0xa0         ;e1d2  85 14 a0
    mov tchr, #0x00         ;e1d5  85 19 00
    mov tclr, #0x00         ;e1d8  85 1a 00
    mov tmcr, #0x03         ;e1db  85 18 03
    mov sdr1, #0x00         ;e1de  85 1d 00
    mov smr1, #0x4f         ;e1e1  85 1c 4f
    mov sdr2, #0x00         ;e1e4  85 1f 00
    mov smr2, #0x3a         ;e1e7  85 1e 3a
    mov bzcr, #0x00         ;e1ea  85 0f 00
    mov eic1, #0x01         ;e1ed  85 24 01
    bbs pdr6:1, lab_e1f6    ;e1f0  b9 11 03
    mov eic1, #0x21         ;e1f3  85 24 21

lab_e1f6:
    mov eic2, #0x10         ;e1f6  85 25 10
    mov adc1, #0x00         ;e1f9  85 20 00
    mov adc2, #0x01         ;e1fc  85 21 01
    mov ilr1, #0xa9         ;e1ff  85 7c a9
    mov ilr2, #0x9a         ;e202  85 7d 9a
    mov ilr3, #0xfe         ;e205  85 7e fe
    seti                    ;e208  90
    ret                     ;e209  20

sub_e20a:
    call sub_e24e           ;e20a  31 e2 4e
    bbs 0x009a:0, lab_e24d  ;e20d  b8 9a 3d
    bbs 0x009b:6, lab_e24d  ;e210  be 9b 3a
    bbc 0x009a:4, lab_e24d  ;e213  b4 9a 37
    clrb 0x9a:4             ;e216  a4 9a

    mov a, 0x8a             ;e218  05 8a
    mov 0x0109, a           ;e21a  61 01 09

    mov a, 0x9e             ;e21d  05 9e
    mov 0x010a, a           ;e21f  61 01 0a

    mov a, 0x013b           ;e222  60 01 3b
    mov 0x010b, a           ;e225  61 01 0b

    mov a, 0x0146           ;e228  60 01 46
    mov 0x010c, a           ;e22b  61 01 0c

    movw a, 0x0109          ;e22e  c4 01 09
    movw 0x010e, a          ;e231  d4 01 0e
    movw a, 0x010b          ;e234  c4 01 0b
    movw 0x0110, a          ;e237  d4 01 10

    mov a, #0x20            ;e23a  04 20
    mov 0x0114, a           ;e23c  61 01 14
    mov a, #0x0a            ;e23f  04 0a
    mov 0x9f, a             ;e241  45 9f
    setb 0x9b:6             ;e243  ae 9b
    clrb 0x9b:7             ;e245  a7 9b
    clrb 0x9c:2             ;e247  a2 9c
    setb 0x9a:0             ;e249  a8 9a
    setb 0x9c:0             ;e24b  a8 9c

lab_e24d:
    ret                     ;e24d  20

sub_e24e:
    bbc 0x0088:1, lab_e261  ;e24e  b1 88 10
    bbs 0x009a:0, lab_e260  ;e251  b8 9a 0c
    clrb 0x88:1             ;e254  a1 88
    setb 0x9a:4             ;e256  ac 9a
    clrb 0x9b:3             ;e258  a3 9b
    setb 0x9b:2             ;e25a  aa 9b
    mov a, #0x0a            ;e25c  04 0a
    mov 0x9d, a             ;e25e  45 9d

lab_e260:
    ret                     ;e260  20

lab_e261:
    bbc 0x009b:0, lab_e260  ;e261  b0 9b fc
    bbs 0x009a:0, lab_e260  ;e264  b8 9a f9
    clrb 0x9b:0             ;e267  a0 9b
    setb 0x9a:4             ;e269  ac 9a
    jmp lab_e260            ;e26b  21 e2 60


m2s_cmd_process:
;Process a Main-to-Sub command packet if one is ready
;
    bbc 0x009a:3, m2s_cmd_done  ;e26e  b3 9a 0b  Branch if "Main-MCU packet ready" flag is clear
    ;A command packet is ready
    clrb 0x9a:3             ;e271  a3 9a         Clear "Main-MCU packet ready" flag for next time
    mov a, 0x0115           ;e273  60 01 15      A = first byte of Main-MCU packet (command byte)
    and a, #0xf0            ;e276  64 f0         Mask off low nibble
    cmp a, #0x80            ;e278  14 80         High nibble = 0x80?
    beq m2s_cmd_dispatch    ;e27a  fd 01         Yes: probably valid command, try to dispatch it
                            ;                    No: not a valid command, do nothing
m2s_cmd_done:
    ret                     ;e27c  20

m2s_cmd_dispatch:
;Try to dispatch a Main-to-Sub command from the current packet
;
    mov a, 0x0115           ;e27d  60 01 15     A = command byte from packet

    cmp a, #0x81            ;e280  14 81        0x81 = Write to both LCD and FIS
    beq m2s_cmd_81          ;e282  fd 0b

    cmp a, #0x82            ;e284  14 82        0x82 = Write only to FIS (used during KWP1281 output tests)
    beq m2s_cmd_82          ;e286  fd 20

    cmp a, #0x83            ;e288  14 83        0x83 = Power off? TODO?
    beq m2s_cmd_83          ;e28a  fd 21

    jmp m2s_cmd_done        ;e28c  21 e2 7c     Other = invalid comment, do nothing

m2s_cmd_81:
;Handle Main-to-Sub command 0x81 (Write to both LCD and FIS)
;A = 0x81
    clrb 0xab:4             ;e28f  a4 ab        Clear "write to FIS only flag"

lab_e291:
    ;Copy 0x0116-0x011a to 0x011c-0x0120
    movw a, 0x0116          ;e291  c4 01 16
    movw 0x011c, a          ;e294  d4 01 1c     Copy 0x0116-0x0117 to 0x011c-0x011d
    movw a, 0x0118          ;e297  c4 01 18
    movw 0x011e, a          ;e29a  d4 01 1e     Copy 0x0118-0x0119 to 0x011e-0x011f
    mov a, 0x011a           ;e29d  60 01 1a
    mov 0x0120, a           ;e2a0  61 01 20     Copy 0x011a to 0x0120

    setb 0x9a:7             ;e2a3  af 9a        Set "display command ready" flag
    jmp m2s_cmd_done        ;e2a5  21 e2 7c

m2s_cmd_82:
;Handle Main-to-Sub command 0x82 = Write only to FIS (used during KWP1281 output tests)
;A = 0x82
    setb 0xab:4             ;e2a8  ac ab        Set "write to FIS only" flag
    jmp lab_e291            ;e2aa  21 e2 91

m2s_cmd_83:
;Handle Main-to-Sub command 0x83 = Play dead (act like powered off)
;A = 0x83
    setb 0x9c:1             ;e2ad  a9 9c        Set "play dead" flag
    jmp m2s_cmd_done        ;e2af  21 e2 7c


sub_e2b2:
    bbc 0x009a:0, lab_e2db  ;e2b2  b0 9a 26
    bbc 0x009c:2, lab_e2f8  ;e2b5  b2 9c 40
    bbc 0x009c:0, lab_e2e1  ;e2b8  b0 9c 26
    clrb 0x9c:0             ;e2bb  a0 9c
    clrb pdr3:4             ;e2bd  a4 0c        /S2M_CLK_OUT = low
    clrc                    ;e2bf  81

    movw ix, #0x010e        ;e2c0  e6 01 0e
    mov a, @ix+0x03         ;e2c3  06 03
    rolc a                  ;e2c5  02

    mov @ix+0x03, a         ;e2c6  46 03
    mov a, @ix+0x02         ;e2c8  06 02
    rolc a                  ;e2ca  02

    mov @ix+0x02, a         ;e2cb  46 02
    mov a, @ix+0x01         ;e2cd  06 01
    rolc a                  ;e2cf  02

    mov @ix+0x01, a         ;e2d0  46 01
    mov a, @ix+0x00         ;e2d2  06 00
    rolc a                  ;e2d4  02

    mov @ix+0x00, a         ;e2d5  46 00
    bnc lab_e2dc            ;e2d7  f8 03
    setb pdr3:5             ;e2d9  ad 0c        S2M_DATA_OUT = high
lab_e2db:
    ret                     ;e2db  20
lab_e2dc:
    clrb pdr3:5             ;e2dc  a5 0c        S2M_DATA_OUT = low
    jmp lab_e2db            ;e2de  21 e2 db

lab_e2e1:
    setb 0x9c:0             ;e2e1  a8 9c
    movw a, #0x0000         ;e2e3  e4 00 00
    mov a, 0x0114           ;e2e6  60 01 14
    decw a                  ;e2e9  d0
    mov 0x0114, a           ;e2ea  61 01 14
    bne lab_e2f3            ;e2ed  fc 04
    clrb 0x9a:0             ;e2ef  a0 9a
    setb pdr2:0             ;e2f1  a8 04        /S2M_ENA_OUT = high

lab_e2f3:
    setb pdr3:4             ;e2f3  ac 0c        /S2M_CLK_OUT = high
    jmp lab_e2db            ;e2f5  21 e2 db

lab_e2f8:
    clrb pdr2:0             ;e2f8  a0 04        /S2M_ENA_OUT = low
    setb 0x9c:2             ;e2fa  aa 9c
    jmp lab_e2db            ;e2fc  21 e2 db


sub_e2ff:
;something to do with main-to-sub bus.  new byte received?
    bbc 0x009a:2, lab_e307  ;e2ff  b2 9a 05

    mov a, #0x00            ;e302  04 00        Reset count of bytes received from Main-MCU
    mov 0x0122, a           ;e304  61 01 22

lab_e307:
    mov a, #0x04            ;e307  04 04
    mov 0x0121, a           ;e309  61 01 21
    setb 0x9a:1             ;e30c  a9 9a
    clrb 0x9a:2             ;e30e  a2 9a

    movw ix, #0x0115        ;e310  e6 01 15

    movw a, @ix+0x01        ;e313  c6 01        Shift existing buffer bytes to the left
    movw @ix+0x00, a        ;e315  d6 00
    movw a, @ix+0x03        ;e317  c6 03
    movw @ix+0x02, a        ;e319  d6 02
    mov a, @ix+0x05         ;e31b  06 05
    mov @ix+0x04, a         ;e31d  46 04

    mov a, sdr1             ;e31f  05 1d        A = byte from M2S_DATA_IN
    mov @ix+0x05, a         ;e321  46 05        Store as 6th byte in the buffer

    setb smr1:0             ;e323  a8 1c

    mov a, 0x0122           ;e325  60 01 22     Increment count of bytes received from Main-MCU
    incw a                  ;e328  c0
    mov 0x0122, a           ;e329  61 01 22

    mov a, #0x06            ;e32c  04 06
    cmp a                   ;e32e  12           6 bytes received from Main-MCU?
    bne lab_e339            ;e32f  fc 08        No: branch to lab_e339
    setb 0x9a:3             ;e331  ab 9a        Yes: set "Main-MCU packet ready" flag

lab_e333:
    mov a, #0x00            ;e333  04 00        Reset count of bytes received from Main-MCU
    mov 0x0122, a           ;e335  61 01 22

lab_e338:
    ret                     ;e338  20

lab_e339:
    mov a, 0x0122           ;e339  60 01 22
    cmp a, #0x01            ;e33c  14 01        1 byte received from Main-MCU?
    bne lab_e338            ;e33e  fc f8        No: branch to return

    ;1 byte received from Main-MCU
    movw ix, #0x0115        ;e340  e6 01 15
    mov a, @ix+0x05         ;e343  06 05        A = byte from Main-MCU

    and a, #0xf0            ;e345  64 f0
    cmp a, #0x80            ;e347  14 80
    beq lab_e338            ;e349  fd ed
    jmp lab_e333            ;e34b  21 e3 33

sub_e34e:
;mfsw input changed
    mov a, 0x0126           ;e34e  60 01 26
    bne lab_e35e            ;e351  fc 0b
    movw a, tchr            ;e353  c5 19
    movw 0x0124, a          ;e355  d4 01 24
    mov a, #0x01            ;e358  04 01
    mov 0x0126, a           ;e35a  61 01 26

lab_e35d:
    ret                     ;e35d  20

lab_e35e:
    call sub_e364           ;e35e  31 e3 64
    jmp lab_e35d            ;e361  21 e3 5d

sub_e364:
;mfsw got bit
    mov a, 0x0126           ;e364  60 01 26
    incw a                  ;e367  c0
    mov 0x0126, a           ;e368  61 01 26
    movw a, tchr            ;e36b  c5 19
    movw a, 0x0124          ;e36d  c4 01 24
    clrc                    ;e370  81
    subcw a                 ;e371  33
    movw 0x012d, a          ;e372  d4 01 2d
    movw a, tchr            ;e375  c5 19
    movw 0x0124, a          ;e377  d4 01 24

    movw a, 0x012d          ;e37a  c4 01 2d
    movw a, #0x9c40         ;e37d  e4 9c 40
    cmpw a                  ;e380  13
    blo lab_e389            ;e381  f9 06

    mov a, #0x01            ;e383  04 01
    mov 0x0126, a           ;e385  61 01 26

lab_e388:
    ret                     ;e388  20

lab_e389:
;0x012d < #0x9c40
    movw a, 0x012d          ;e389  c4 01 2d
    movw a, #0x60ae         ;e38c  e4 60 ae
    cmpw a                  ;e38f  13
    blo lab_e395            ;e390  f9 03
    jmp lab_e388            ;e392  21 e3 88     ;return

lab_e395:
;0x012d < #0x60ae
    movw a, 0x012d          ;e395  c4 01 2d
    movw a, #0x34b2         ;e398  e4 34 b2
    cmpw a                  ;e39b  13
    blo lab_e3ab            ;e39c  f9 0d

;0x012d >= #0x34b2
    bbc 0x00a0:3, lab_e3a3  ;e39e  b3 a0 02
    setb 0xa0:7             ;e3a1  af a0

lab_e3a3:
    mov a, #0x00            ;e3a3  04 00
    mov 0x0126, a           ;e3a5  61 01 26
    jmp lab_e388            ;e3a8  21 e3 88     ;return

lab_e3ab:
;0x012d < #0x34b2
    movw a, 0x012d          ;e3ab  c4 01 2d
    movw a, #0x0d20         ;e3ae  e4 0d 20
    cmpw a                  ;e3b1  13
    blo lab_e3bb            ;e3b2  f9 07
    setc                    ;e3b4  91

lab_e3b5:
    call sub_e3bf           ;e3b5  31 e3 bf
    jmp lab_e388            ;e3b8  21 e3 88     ;return

lab_e3bb:
    clrc                    ;e3bb  81
    jmp lab_e3b5            ;e3bc  21 e3 b5

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
    mov a, 0x0129           ;e3bf  60 01 29     ;rotate
    rorc a                  ;e3c2  03
    mov 0x0129, a           ;e3c3  61 01 29

    mov a, 0x012a           ;e3c6  60 01 2a     ;rotate
    rorc a                  ;e3c9  03
    mov 0x012a, a           ;e3ca  61 01 2a

    mov a, 0x012b           ;e3cd  60 01 2b     ;rotate
    rorc a                  ;e3d0  03
    mov 0x012b, a           ;e3d1  61 01 2b

    mov a, 0x012c           ;e3d4  60 01 2c     ;rotate
    rorc a                  ;e3d7  03
    mov 0x012c, a           ;e3d8  61 01 2c

    mov a, 0x0126           ;e3db  60 01 26     ;compare count of bits received?
    cmp a, #0x22            ;e3de  14 22
    bne lab_e406            ;e3e0  fc 24        ;branch if != 34 bits

    movw a, 0x012b          ;e3e2  c4 01 2b     ;compare first two bytes in packet
    movw a, #0x1782         ;e3e5  e4 17 82
    cmpw a                  ;e3e8  13
    bne lab_e407            ;e3e9  fc 1c        ;branch if != 0x1782

    setb 0xa0:3             ;e3eb  ab a0

    mov a, 0x0129           ;e3ed  60 01 29
    mov a, 0x012a           ;e3f0  60 01 2a
    xor a                   ;e3f3  52
    incw a                  ;e3f4  c0
    cmp a, #0x00            ;e3f5  14 00
    bne lab_e401            ;e3f7  fc 08        ;checksum failed?

    mov a, 0x012a           ;e3f9  60 01 2a     ;equal: load a = 0x012a
    mov 0x0128, a           ;e3fc  61 01 28     ;       store a in 0x0128
    setb 0xa0:0             ;e3ff  a8 a0

lab_e401:
    mov a, #0x00            ;e401  04 00
    mov 0x0126, a           ;e403  61 01 26     ;not equal

lab_e406:
    ret                     ;e406  20

lab_e407:
;checksum didn't match?
    clrb 0xa0:3             ;e407  a3 a0
    jmp lab_e401            ;e409  21 e4 01

sub_e40c:
    bbc 0x00a0:0, lab_e41d  ;e40c  b0 a0 0e
    clrb 0xa0:0             ;e40f  a0 a0

    mov a, 0x0128           ;e411  60 01 28     ;Copy 0x128 to 0x127
    mov 0x0127, a           ;e414  61 01 27

lab_e417:
    mov a, #0x0f            ;e417  04 0f
    mov 0x0123, a           ;e419  61 01 23

lab_e41c:
    ret                     ;e41c  20

lab_e41d:
    bbc 0x00a0:7, lab_e42f  ;e41d  b7 a0 0f
    clrb 0xa0:7             ;e420  a7 a0
    mov a, 0x0123           ;e422  60 01 23
    bne lab_e417            ;e425  fc f0

lab_e427:
    mov a, #0xff            ;e427  04 ff
    mov 0x0127, a           ;e429  61 01 27
    jmp lab_e41c            ;e42c  21 e4 1c     ;jmp to ret

lab_e42f:
    mov a, 0x0123           ;e42f  60 01 23
    beq lab_e427            ;e432  fd f3
    jmp lab_e41c            ;e434  21 e4 1c

sub_e437:
    mov a, 0x014a           ;e437  60 01 4a
    incw a                  ;e43a  c0
    mov 0x014a, a           ;e43b  61 01 4a
    ret                     ;e43e  20


make_upd_text:
;Convert 11 byte buffer at 0x012f-0x139 from ASCII to uPD16432B chars
;
    movw ep, #0x012f+0      ;e43f  e7 01 2f
    call ascii_to_upd       ;e442  31 e4 9b     Replace ASCII char at 0x012f with uPD16432B char
    movw ep, #0x012f+1      ;e445  e7 01 30
    call ascii_to_upd       ;e448  31 e4 9b     Replace ASCII char at 0x0130 with uPD16432B char
    movw ep, #0x012f+2      ;e44b  e7 01 31
    bbs 0x00a9:1, lab_e457  ;e44e  b9 a9 06     Branch if "mode or preset digits" flag is set
    call ascii_to_upd       ;e451  31 e4 9b     Replace ASCII char at 0x0131 with uPD16432B char
    jmp lab_e45a            ;e454  21 e4 5a
lab_e457:
    call ascii_to_upd_fm12  ;e457  31 e5 15     Replace ASCII char at @ep for uPD16432B char for FM1/2
lab_e45a:
    movw ep, #0x012f+3      ;e45a  e7 01 32
    bbs 0x00a9:1, lab_e466  ;e45d  b9 a9 06     Branch if "mode or preset digits" flag is set
    call ascii_to_upd       ;e460  31 e4 9b     Replace ASCII char at 0x0132 with uPD16432B char
    jmp lab_e469            ;e463  21 e4 69     Jump to convert buffer at 0x0133-0x139 from ASCII to uPD16432B
lab_e466:
    call ascii_to_upd_preset ;e466  31 e5 36    Replace ASCII char at @ep with uPD16432B char for station presets
lab_e469:
    movw ep, #0x012f+4      ;e469  e7 01 33
    call ascii_to_upd       ;e46c  31 e4 9b     Replace ASCII char at 0x0133 with uPD16432B char
    movw ep, #0x012f+5      ;e46f  e7 01 34
    call ascii_to_upd       ;e472  31 e4 9b     Replace ASCII char at 0x0134 with uPD16432B char
    movw ep, #0x012f+6      ;e475  e7 01 35
    call ascii_to_upd       ;e478  31 e4 9b     Replace ASCII char at 0x0135 with uPD16432B char
    movw ep, #0x012f+7      ;e47b  e7 01 36
    call ascii_to_upd       ;e47e  31 e4 9b     Replace ASCII char at 0x0136 with uPD16432B char
    movw ep, #0x012f+8      ;e481  e7 01 37
    call ascii_to_upd       ;e484  31 e4 9b     Replace ASCII char at 0x0137 with uPD16432B char
    movw ep, #0x012f+9      ;e487  e7 01 38
    call ascii_to_upd       ;e48a  31 e4 9b     Replace ASCII char at 0x0138 with uPD16432B char
    movw ep, #0x012f+10     ;e48d  e7 01 39
    call ascii_to_upd       ;e490  31 e4 9b     Replace ASCII char at 0x0139 with uPD16432B char

    bbs 0x00ab:4, lab_e49a  ;e493  bc ab 04     Branch if "write to FIS only" flag is set
    setb 0x87:2             ;e496  aa 87
    setb 0xab:5             ;e498  ad ab
lab_e49a:
    ret                     ;e49a  20


ascii_to_upd:
;Replace the ASCII char at @ep with its equivalent upd16432B char.
;
    mov a, @ep              ;e49b  07
    mov a, #0x20            ;e49c  04 20
    cmp a                   ;e49e  12
    blo lab_e4b7            ;e49f  f9 16
    mov a, @ep              ;e4a1  07
    mov a, #0x7b            ;e4a2  04 7b
    cmp a                   ;e4a4  12
    bhs lab_e4b7            ;e4a5  f8 10
    movw a, #0x0000         ;e4a7  e4 00 00
    mov a, @ep              ;e4aa  07
    mov a, #0x20            ;e4ab  04 20
    clrc                    ;e4ad  81
    subc a                  ;e4ae  32
    movw a, #ascii_to_upd_table ;e4af  e4 e4 ba
    clrc                    ;e4b2  81
    addcw a                 ;e4b3  23
    mov a, @a               ;e4b4  92
    mov @ep, a              ;e4b5  47
    ret                     ;e4b6  20

lab_e4b7:
    mov @ep, #0x20          ;e4b7  87 20
    ret                     ;e4b9  20

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
    mov a, @ep              ;e515  07
    mov a, #'1              ;e516  04 31
    cmp a                   ;e518  12
    blo lab_e531            ;e519  f9 16        Branch if ASCII char at @ep < '1'

    mov a, @ep              ;e51b  07
    mov a, #'3              ;e51c  04 33
    cmp a                   ;e51e  12
    bhs lab_e531            ;e51f  f8 10        Branch if ASCII char at @ep >= '3'

    movw a, #0x0000         ;e521  e4 00 00     Convert ASCII '1'-'2' to binary 0-1
    mov a, @ep              ;e524  07
    mov a, #'1              ;e525  04 31
    clrc                    ;e527  81
    subc a                  ;e528  32

    movw a, #upd_fm12       ;e529  e4 e5 34     Look up uPD16432B char "1" for FM1 or "2" for FM2
    clrc                    ;e52c  81
    addcw a                 ;e52d  23
    mov a, @a               ;e52e  92
    mov @ep, a              ;e52f  47           Store char at pointer
    ret                     ;e530  20
lab_e531:
    mov @ep, #0x20          ;e531  87 20        Store space at pointer (out of range)
    ret                     ;e533  20
upd_fm12:
    .byte 0xEB              ;e534  eb           uPD16432B char "1" for FM1
    .byte 0xEC              ;e535  ec           uPD16432B char "2" for FM2


ascii_to_upd_preset:
;Replace ASCII char at @ep with uPD16432B char for station presets
;  ASCII "1" to "6" becomes uPD16432B "1" to "6"
;  Anything else becomes a space
;
    mov a, @ep              ;e536  07
    mov a, #'1              ;e537  04 31
    cmp a                   ;e539  12
    blo lab_e552            ;e53a  f9 16        Branch if ASCII char at @ep < '1'

    mov a, @ep              ;e53c  07
    mov a, #'7              ;e53d  04 37
    cmp a                   ;e53f  12
    bhs lab_e552            ;e540  f8 10        Branch if ASCII char at @ep >= '7'

    movw a, #0x0000         ;e542  e4 00 00     Convert ASCII '1'-'6' to binary 0-5
    mov a, @ep              ;e545  07
    mov a, #'1              ;e546  04 31
    clrc                    ;e548  81
    subc a                  ;e549  32

    movw a, #upd_presets    ;e54a  e4 e5 55     Look up uPD16432B char for preset
    clrc                    ;e54d  81
    addcw a                 ;e54e  23
    mov a, @a               ;e54f  92
    mov @ep, a              ;e550  47           Store char at pointer
    ret                     ;e551  20
lab_e552:
    mov @ep, #0x20          ;e552  87 20        Store space at pointer (out of range)
    ret                     ;e554  20
upd_presets:
    .byte 0xE5              ;e555  e5           uPD16432B char "1" for preset 1
    .byte 0xED              ;e556  ed           uPD16432B char "2" for preset 2
    .byte 0xEE              ;e557  ee           uPD16432B char "3" for preset 3
    .byte 0xEF              ;e558  ef           uPD16432B char "4" for preset 4
    .byte 0xF0              ;e559  f0           uPD16432B char "5" for preset 5
    .byte 0xF2              ;e560  f2           uPD16432B char "6" for preset 6


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
    movw a, ps              ;e55b  70           Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;e55c  e4 00 ff       R0=0x100, R1=0x101...
    andw a                  ;e55f  63
    movw ps, a              ;e560  71

    bbc 0x009a:7, lab_e57f  ;e561  b7 9a 1b     Branch if "display command ready" flag is clear
    clrb 0x9a:7             ;e564  a7 9a        Clear "display command ready" for next time
    setb 0x9c:3             ;e566  ab 9c
    clrb 0xa9:0             ;e568  a0 a9        Clear "show period" flag
    clrb 0xa9:1             ;e56a  a1 a9        Clear "mode or preset digits" flag

    movw ep, #0x011d        ;e56c  e7 01 1d     EP = pointer to Display Number in command packet
    mov a, @ep              ;e56f  07           A = display number

    bz lab_e5d0             ;e570  fd 5e        Branch if A = 0 (vw-car message)

    cmp a, #0x10            ;e572  14 10
    bhs lab_e580            ;e574  f8 0a
    call msgs_01_0f         ;e576  31 e6 0f     Call if A >= 0x01 and A <= 0x0F (cd messages)

lab_e579:
    call make_upd_picts     ;e579  31 e5 d6     Parse pictograph byte; set uPD16432B bytes at 0x00a1-0x00a8.
    call make_upd_text      ;e57c  31 e4 3f     Convert buffer at 0x012f-0x139 from ASCII to uPD16432B chars

lab_e57f:
    ret                     ;e57f  20

lab_e580:
;A >= 0x10
    cmp a, #0x20            ;e580  14 20
    bhs lab_e58a            ;e582  f8 06
    call msgs_10_1f         ;e584  31 e6 f6     Call if A >= 0x10 and A <= 0x1F ("set" messages)
    jmp lab_e579            ;e587  21 e5 79

lab_e58a:
;A >= 0x20
    cmp a, #0x40            ;e58a  14 40
    bhs lab_e594            ;e58c  f8 06
    call msgs_20_3f         ;e58e  31 e7 61     Call if A >= 0x20 and A <= 0x3F (test mode messages)
    jmp lab_e579            ;e591  21 e5 79

lab_e594:
;A >= 0x40
    cmp a, #0x50            ;e594  14 50
    bhs lab_e59e            ;e596  f8 06
    call msgs_40_4f         ;e598  31 e9 31     Call if A >= 0x40 and A <= 0x4F (tuner messages)
    jmp lab_e579            ;e59b  21 e5 79

lab_e59e:
;A >= 0x50
    cmp a, #0x60            ;e59e  14 60
    bhs lab_e5a8            ;e5a0  f8 06
    call msgs_50_5f         ;e5a2  31 e9 f1     Call if A >= 0x50 and A <= 0x5F (tape messages)
    jmp lab_e579            ;e5a5  21 e5 79

lab_e5a8:
;A >= 0x60
    cmp a, #0x80            ;e5a8  14 80
    bhs lab_e5b2            ;e5aa  f8 06
    call msgs_60_7f         ;e5ac  31 ea 6b     Call if A >= 0x60 and A <= 0x7F (sound messages)
    jmp lab_e579            ;e5af  21 e5 79

lab_e5b2:
;A >= 0x80
    cmp a, #0xb0            ;e5b2  14 b0
    bhs lab_e5bc            ;e5b4  f8 06
    call msgs_80_af         ;e5b6  31 eb 78     Call if A >= 0x80 and A <= 0xAF (code messages)
    jmp lab_e579            ;e5b9  21 e5 79

lab_e5bc:
;A >= 0xb0
    cmp a, #0xc0            ;e5bc  14 c0
    bhs lab_e5c6            ;e5be  f8 06
    call msgs_b0_bf         ;e5c0  31 ec 12     Call if A >= 0xB0 and A < 0xBF (diag messages)
    jmp lab_e579            ;e5c3  21 e5 79

lab_e5c6:
;A >= 0xC0
    cmp a, #0xd0            ;e5c6  14 d0
    bhs lab_e5d0            ;e5c8  f8 06
    call msgs_c0_cf         ;e5ca  31 ec 50     Call if A >= 0xC0 and A < 0xCF (bose messages)
    jmp lab_e579            ;e5cd  21 e5 79

lab_e5d0:
;A = 0 or A >= 0xD0
    call msgs_00_or_gte_d0  ;e5d0  31 ec 8e     Call if A = 0 or A >= 0xD0 (vw-car message)
    jmp lab_e579            ;e5d3  21 e5 79


make_upd_picts:
;Parse pictographs byte in command packet into 8 uPD16432B
;pictograph bytes at 0x00a1-0x00a8
;
    ;Clear 8 uPD16432B pictograph bytes 0x00a1-0x00a8
    movw ix, #0x00a1        ;e5d6  e6 00 a1     IX = pointer to uPD16432B pictograph data
    movw a, #0x0000         ;e5d9  e4 00 00     A = 0x0000
    movw @ix+0x00, a        ;e5dc  d6 00        Clear 8 pictograph bytes
    movw @ix+0x02, a        ;e5de  d6 02
    movw @ix+0x04, a        ;e5e0  d6 04
    movw @ix+0x06, a        ;e5e2  d6 06

    movw ep, #0x011c        ;e5e4  e7 01 1c     EP = pointer to pictographs byte in command packet
    mov a, @ep              ;e5e7  07           A = pictographs byte

    ;Pictograph byte bit 0 = METAL
    rorc a                  ;e5e8  03           Pictograph byte bit 0
    bnc lab_e5ed            ;e5e9  f8 02        Branch if not set
    setb 0xa1+7:3           ;e5eb  ab a8        Set METAL bit in uPD16432B pictograph bytes

lab_e5ed:
    ;Pictograph byte bit 1 = MIX
    rorc a                  ;e5ed  03           Pictograph byte bit 1
    bnc lab_e5f2            ;e5ee  f8 02        Branch if not set
    setb 0xa1+6:0           ;e5f0  a8 a7        Set MIX bit in uPD16432B pictograph bytes

lab_e5f2:
    ;Pictograph byte bit 2 = DOLBY
    rorc a                  ;e5f2  03           Pictograph byte bit 2
    bnc lab_e5f7            ;e5f3  f8 02        Branch if not set
    setb 0xa1+6:5           ;e5f5  ad a7        Set DOLBY bit in uPD16432B pictograph bytes

lab_e5f7:
    ;Pictograph byte bit 3 = HIDDEN MODE AM/FM
    rorc a                  ;e5f7  03           Pictograph byte bit 3
    bnc lab_e5fc            ;e5f8  f8 02        Branch if not set
    setb 0xa1+2:3           ;e5fa  ab a3        Set HIDDEN MODE AM/FM bit in uPD16432B pictograph bytes

lab_e5fc:
    ;Pictograph byte bit 4 = HIDDEN MODE CD
    rorc a                  ;e5fc  03           Pictograph byte bit 4
    bnc lab_e601            ;e5fd  f8 02        Branch if not set
    setb 0xa1+1:0           ;e5ff  a8 a2        Set HIDDEN MODE CD bit in uPD16432B pictograph bytes

lab_e601:
    ;Pictograph byte bit 5 = HIDDEN MODE TAPE
    rorc a                  ;e601  03           Pictograph byte bit 5
    bnc lab_e606            ;e602  f8 02        Branch if not set
    setb 0xa1+1:5           ;e604  ad a2        Set HIDDEN MODE TAPE bit in uPD16432B pictograph bytes

lab_e606:
    ;Pictograph byte bit 6 = PERIOD
    ;Set if the byte in the pictograph is set or always set
    ;if the "show period" flag is set
    rorc a                  ;e606  03           Pictograph byte bit 6
    bc lab_e60c             ;e607  f9 03        Branch to if set
    bbc 0x00a9:0, lab_e60e  ;e609  b0 a9 02     Branch over if "show period" flag is clear
lab_e60c:
    setb 0xa1+3:6           ;e60c  ae a4        Set PERIOD bit in uPD16432B pictograph bytes

lab_e60e:
    ret                     ;e60e  20

msgs_01_0f:
;Called if A >= 0x01 and A <= 0x0F (cd messages)
;Called with EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;e60f  e4 00 00
    mov a, @ep              ;e612  07           A = Display Number
    mov a, #0x01            ;e613  04 01
    clrc                    ;e615  81
    subc a                  ;e616  32
    mov r0, a               ;e617  48
    movw a, #0x000b         ;e618  e4 00 0b
    mulu a                  ;e61b  01
    movw a, #msgs_01_0f_text ;e61c  e4 ed ad     A = pointer to cd messages
    clrc                    ;e61f  81
    addcw a                 ;e620  23
    movw ix, a              ;e621  e2
    movw ep, #0x012f        ;e622  e7 01 2f
    call copy_11_ix_to_ep   ;e625  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;e628  e6 01 2f
    movw ep, #0x011e        ;e62b  e7 01 1e
    movw a, #0x0000         ;e62e  e4 00 00
    mov a, r0               ;e631  08
    cmp a, #0x0f            ;e632  14 0f
    bhs msgs_01_0f_done     ;e634  f8 27
    clrc                    ;e636  81
    rolc a                  ;e637  02
    movw a, #msgs_01_0f_jmp ;e638  e4 e6 3f
    clrc                    ;e63b  81
    addcw a                 ;e63c  23
    movw a, @a              ;e63d  93
    jmp @a                  ;e63e  e0

msgs_01_0f_jmp:
    .word msg_01_cd_tr       ;e63f  e6 61       VECTOR   0x01  'CD...TR....'
    .word msg_02_cue         ;e641  e6 77       VECTOR   0x02  'CUE........'
    .word msg_03_rev         ;e643  e6 9e       VECTOR   0x03  'REV........'
    .word msg_04_scancd_tr   ;e645  e6 a1       VECTOR   0x04  'SCANCD.TR..'
    .word msg_05_no_changer  ;e647  e6 b7       VECTOR   0x05  'NO..CHANGER'
    .word msg_06_no_magazin  ;e649  e6 ba       VECTOR   0x06  'NO  MAGAZIN'
    .word msg_07_no_disc     ;e64b  e6 bd       VECTOR   0x07  '....NO.DISC'
    .word msg_08_cd_error    ;e64d  e6 c0       VECTOR   0x08  'CD...ERROR.'
    .word msg_09_cd_         ;e64f  e6 c9       VECTOR   0x09  'CD.........'
    .word msg_0a_cd_max      ;e651  e6 d2       VECTOR   0x0A  'CD....MAX..'
    .word msg_0b_cd_min      ;e653  e6 db       VECTOR   0x0B  'CD....MIN..'
    .word msg_0c_chk_magazin ;e655  e6 de       VECTOR   0x0C  'CHK.MAGAZIN'
    .word msg_0d_cd_cd_err   ;e657  e6 e1       VECTOR   0x0D  'CD..CD.ERR.'
    .word msg_0e_cd_error    ;e659  e6 ea       VECTOR   0x0E  'CD...ERROR.'
    .word msg_0f_cd_no_cd    ;e65b  e6 ed       VECTOR   0x0F  'CD...NO.CD.'

msgs_01_0f_done:
    call make_fis_text      ;e65d  31 ec ce
    ret                     ;e660  20

msg_01_cd_tr:
;Buffer:  'CD...TR....'
;Example: 'CD 1 TR 03 ' (Param 0 = CD, Param 1 = Track)
;
;Param 0 High Nibble = Unused
;Param 1 Low Nibble  = CD number
;Param 1 Byte        = Track number
;Param 2 Byte        = Unused
    mov a, @ep              ;e661  07           A = Display Param 0 (CD)
    call hex_nib_low        ;e662  31 ed 92     A = CD as hex digit
    mov @ix+0x03, a         ;e665  46 03        Store in buffer

    incw ep                 ;e667  c3           EP = pointer to Display Param 1
    mov a, @ep              ;e668  07           A = Display Param 1 (Track)
    call hex_nib_high       ;e669  31 ed 88
    mov @ix+0x08, a         ;e66c  46 08

    mov a, @ep              ;e66e  07
    call hex_nib_low        ;e66f  31 ed 92
    mov @ix+0x09, a         ;e672  46 09
    jmp msgs_01_0f_done     ;e674  21 e6 5d

msg_02_cue:
;Buffer:  'CUE........'
;Example: 'CUE   047  '
;Example: 'CUE  -002  '
;TODO finish me
    incw ep                 ;e677  c3           EP = pointer to Display Param 1 (TODO)
    mov a, @ep              ;e678  07
    and a, #0xf0            ;e679  64 f0
    beq lab_e688            ;e67b  fd 0b
    call hex_nib_high       ;e67d  31 ed 88
    cmp a, #'A              ;e680  14 41
    bne lab_e686            ;e682  fc 02
    mov a, #'-              ;e684  04 2d
lab_e686:
    mov @ix+0x05, a         ;e686  46 05
lab_e688:
    mov a, @ep              ;e688  07
    call hex_nib_low        ;e689  31 ed 92
    mov @ix+0x06, a         ;e68c  46 06
    incw ep                 ;e68e  c3
    mov a, @ep              ;e68f  07
    call hex_nib_high       ;e690  31 ed 88
    mov @ix+0x07, a         ;e693  46 07
    mov a, @ep              ;e695  07
    call hex_nib_low        ;e696  31 ed 92
    mov @ix+0x08, a         ;e699  46 08
    jmp msgs_01_0f_done     ;e69b  21 e6 5d

msg_03_rev:
;Buffer:  'REV........'
;Example: 'REV   133  '
;Example: 'REV  -002  '
;TODO finish me
    jmp msg_02_cue          ;e69e  21 e6 77

msg_04_scancd_tr:
;Buffer:  'SCANCD.TR..'
;Example: 'SCANCD1TR04' (Param 0 = CD, 1 = Track)
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Track number
;Param 2 Byte        = Unused
    mov a, @ep              ;e6a1  07           A = Param 0 (CD)
    call hex_nib_low        ;e6a2  31 ed 92
    mov @ix+0x06, a         ;e6a5  46 06

    incw ep                 ;e6a7  c3           EP = pointer to Param 1
    mov a, @ep              ;e6a8  07           A = Param 1 (Track)
    call hex_nib_high       ;e6a9  31 ed 88
    mov @ix+0x09, a         ;e6ac  46 09
    mov a, @ep              ;e6ae  07
    call hex_nib_low        ;e6af  31 ed 92
    mov @ix+0x0a, a         ;e6b2  46 0a
    jmp msgs_01_0f_done     ;e6b4  21 e6 5d

msg_05_no_changer:
;Buffer:  'NO..CHANGER'
;Example: 'NO  CHANGER'
;
;No params
    jmp msgs_01_0f_done     ;e6b7  21 e6 5d

msg_06_no_magazin:
;Buffer:  'NO..MAGAZIN'
;Example: 'NO  MAGAZIN'
;
;No params
    jmp msgs_01_0f_done     ;e6ba  21 e6 5d

msg_07_no_disc:
;Buffer:  '....NO.DISC'
;Example: '    NO DISC' (no params)
;
;No params
    jmp msgs_01_0f_done     ;e6bd  21 e6 5d

msg_08_cd_error:
;Buffer:  'CD...ERROR.'
;Example: 'CD 6 ERROR '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;e6c0  07           A = Display Param 0 (CD)
    call hex_nib_low        ;e6c1  31 ed 92     A = ASCII digit for CD number
    mov @ix+0x03, a         ;e6c4  46 03        Write digit into the buffer
    jmp msgs_01_0f_done     ;e6c6  21 e6 5d

msg_09_cd_:
;Buffer:  'CD.........'
;TODO finish me
    mov a, @ep              ;e6c9  07
    call hex_nib_low        ;e6ca  31 ed 92
    mov @ix+0x03, a         ;e6cd  46 03
    jmp msg_02_cue          ;e6cf  21 e6 77

msg_0a_cd_max:
;Buffer:  'CD....MAX..'
;Example: 'CD 5  MAX  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;e6d2  07           A = Display Param 0 (CD)
    call hex_nib_low        ;e6d3  31 ed 92     A = ASCII digit for CD number
    mov @ix+0x03, a         ;e6d6  46 03        Write digit into the buffer
    jmp msgs_01_0f_done     ;e6d8  21 e6 5d

msg_0b_cd_min:
;Buffer:  'CD....MIN..'
;Example: 'CD 5  MIN  '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_0a_cd_max       ;e6db  21 e6 d2

msg_0c_chk_magazin:
;Buffer:  'CHK.MAGAZIN'
;Example: 'CHK MAGAZIN'
;
;No params
    jmp msgs_01_0f_done     ;e6de  21 e6 5d

msg_0d_cd_cd_err:
;Buffer:  'CD..CD.ERR.'
;Example: 'CD6 CD ERR '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;e6e1  07           A = Display Param 0 (CD)
    call hex_nib_low        ;e6e2  31 ed 92     A = ASCII digit for CD number
    mov @ix+0x02, a         ;e6e5  46 02        Write digit into the buffer
    jmp msgs_01_0f_done     ;e6e7  21 e6 5d

msg_0e_cd_error:
;Buffer:  'CD...ERROR.'
;Example: 'CD   ERROR '
;
;No params
    jmp msgs_01_0f_done     ;e6ea  21 e6 5d

msg_0f_cd_no_cd:
;Buffer:  'CD...NO.CD.'
;Example: 'CD 6 NO CD '
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = CD number
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    mov a, @ep              ;e6ed  07           A = Display Param 0 (CD)
    call hex_nib_low        ;e6ee  31 ed 92     A = ASCII digit for CD number
    mov @ix+0x03, a         ;e6f1  46 03        Write digit into the buffer
    jmp msgs_01_0f_done     ;e6f3  21 e6 5d

msgs_10_1f:
;Called if A >= 0x10 and A <= 0x1F ("set" messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;e6f6  e4 00 00
    mov a, @ep              ;e6f9  07
    mov a, #0x10            ;e6fa  04 10
    clrc                    ;e6fc  81
    subc a                  ;e6fd  32
    mov r0, a               ;e6fe  48
    movw a, #0x000b         ;e6ff  e4 00 0b
    mulu a                  ;e702  01
    movw a, #msgs_10_1f_text ;e703  e4 ee 52     A = pointer to "set" messages
    clrc                    ;e706  81
    addcw a                 ;e707  23
    movw ix, a              ;e708  e2
    movw ep, #0x012f        ;e709  e7 01 2f
    call copy_11_ix_to_ep   ;e70c  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;e70f  e6 01 2f
    movw ep, #0x011e        ;e712  e7 01 1e
    movw a, #0x0000         ;e715  e4 00 00
    mov a, r0               ;e718  08
    cmp a, #0x07            ;e719  14 07
    bhs msgs_10_1f_done     ;e71b  f8 17
    clrc                    ;e71d  81
    rolc a                  ;e71e  02
    movw a, #msgs_10_1f_jmp ;e71f  e4 e7 26
    clrc                    ;e722  81
    addcw a                 ;e723  23
    movw a, @a              ;e724  93
    jmp @a                  ;e725  e0

msgs_10_1f_jmp:
    .word msg_10_set_onvol_y ;e726  e7 38       VECTOR   0x10  'SET.ONVOL.Y'
    .word msg_11_set_onvol_n ;e728  e7 3b       VECTOR   0x11  'SET.ONVOL.N'
    .word msg_12_set_onvol_  ;e72a  e7 3e       VECTOR   0x12  'SET.ONVOL..'
    .word msg_13_set_cdmix1  ;e72c  e7 55       VECTOR   0x13  'SET.CD.MIX1'
    .word msg_14_set_cd_mix6 ;e72e  e7 58       VECTOR   0x14  'SET.CD.MIX6'
    .word msg_15_tape_skip_y ;e730  e7 5b       VECTOR   0x15  'TAPE.SKIP.Y'
    .word msg_16_tape_skip_n ;e732  e7 5e       VECTOR   0x16  'TAPE.SKIP.N'

msgs_10_1f_done:
    call make_fis_text       ;e734  31 ec ce
    ret                      ;e737  20

msg_10_set_onvol_y:
;Buffer:  'SET.ONVOL.Y'
;Example: 'SET ONVOL Y'
;
;No params
    jmp msgs_10_1f_done     ;e738  21 e7 34

msg_11_set_onvol_n:
;Buffer:  'SET.ONVOL.N'
;Example: 'SET ONVOL N'
;
;No params
    jmp msgs_10_1f_done     ;e73b  21 e7 34

msg_12_set_onvol_:
;Buffer:  'SET.ONVOL..'
;Example: 'SET ONVOL63' (Param 0 = Level in binary)
;
;Param 0 Byte = Level in binary
;Param 1 Byte = Unused
;Param 2 Byte = Unused
    mov a, @ep              ;e73e  07           A = Display Param 0 (Level)
    call bin_to_bcd         ;e73f  31 ed 5d     R7 = Level in BCD

    mov a, r7               ;e742  0f           A = Level in BCD
    and a, #0xf0            ;e743  64 f0        Mask off all except ten's place
    beq lab_e74c            ;e745  fd 05        Skip write if ten's place is 0
    call hex_nib_high       ;e747  31 ed 88     A = ASCII digit for ten's place
    mov @ix+0x09, a         ;e74a  46 09        Write one's place into buffer
lab_e74c:
    mov a, r7               ;e74c  0f           A = Level in BCD
    call hex_nib_low        ;e74d  31 ed 92     A = ASCII digit for one's place
    mov @ix+0x0a, a         ;e750  46 0a        Wriit one's place into buffer
    jmp msgs_10_1f_done     ;e752  21 e7 34

msg_13_set_cdmix1:
;Buffer:  'SET.CD.MIX1'
;Example: 'SET CD MIX1'
;
;No params
    jmp msgs_10_1f_done     ;e755  21 e7 34

msg_14_set_cd_mix6:
;Buffer:  'SET.CD.MIX6'
;Example: 'SET CD MIX6'
;
;No params
    jmp msgs_10_1f_done     ;e758  21 e7 34

msg_15_tape_skip_y:
;Buffer:  'TAPE.SKIP.Y'
;Example: 'TAPE SKIP Y'
;
;No params
    jmp msgs_10_1f_done     ;e75b  21 e7 34

msg_16_tape_skip_n:
;Buffer:  'TAPE.SKIP.N'
;Example: 'TAPE SKIP N'
;
;No params
    jmp msgs_10_1f_done     ;e75e  21 e7 34

msgs_20_3f:
;Called if A >= 0x20 and A <= 0x3F (test mode messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;e761  e4 00 00
    mov a, @ep              ;e764  07
    mov a, #0x20            ;e765  04 20
    clrc                    ;e767  81
    subc a                  ;e768  32
    mov r0, a               ;e769  48
    movw a, #0x000b         ;e76a  e4 00 0b
    mulu a                  ;e76d  01
    movw a, #msgs_20_3f_text ;e76e  e4 ee 9f     A = pointer to test mode messages
    clrc                    ;e771  81
    addcw a                 ;e772  23
    movw ix, a              ;e773  e2
    movw ep, #0x012f        ;e774  e7 01 2f
    call copy_11_ix_to_ep   ;e777  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;e77a  e6 01 2f
    movw ep, #0x011e        ;e77d  e7 01 1e
    movw a, #0x0000         ;e780  e4 00 00
    mov a, r0               ;e783  08
    cmp a, #0x18            ;e784  14 18
    bhs msgs_20_3f_done     ;e786  f8 39
    clrc                    ;e788  81
    rolc a                  ;e789  02
    movw a, #msgs_20_3f_jmp ;e78a  e4 e7 91
    clrc                    ;e78d  81
    addcw a                 ;e78e  23
    movw a, @a              ;e78f  93
    jmp @a                  ;e790  e0

msgs_20_3f_jmp:
    .word msg_20_rad_3cp_t7  ;e791  e7 c5       VECTOR   0x20  'RAD.3CP.T7.'
    .word msg_21_ver         ;e793  e7 c8       VECTOR   0x21  'VER........'
    .word msg_22_            ;e795  e7 e9       VECTOR   0x22  '...........'
    .word msg_23_hc          ;e797  e8 28       VECTOR   0x23  'HC.........'
    .word msg_24_v           ;e799  e8 31       VECTOR   0x24  'V..........'
    .word msg_25_seekset_m   ;e79b  e8 80       VECTOR   0x25  'SEEKSET.M..'
    .word msg_26_seekset_n   ;e79d  e8 89       VECTOR   0x26  'SEEKSET.N..'
    .word msg_27_seekset_m1  ;e79f  e8 8c       VECTOR   0x27  'SEEKSET.M1.'
    .word msg_28_seekset_m2  ;e7a1  e8 95       VECTOR   0x28  'SEEKSET.M2.'
    .word msg_29_seekset_m3  ;e7a3  e8 98       VECTOR   0x29  'SEEKSET.M3.'
    .word msg_2a_seekset_n1  ;e7a5  e8 9b       VECTOR   0x2A  'SEEKSET.N1.'
    .word msg_2b_seekset_n2  ;e7a7  e8 9e       VECTOR   0x2B  'SEEKSET.N2.'
    .word msg_2c_seekset_n3  ;e7a9  e8 a1       VECTOR   0x2C  'SEEKSET.N3.'
    .word msg_2d_seekset_x   ;e7ab  e8 a4       VECTOR   0x2D  'SEEKSET.X..'
    .word msg_2e_seekset_y   ;e7ad  e8 b7       VECTOR   0x2E  'SEEKSET.Y..'
    .word msg_2f_seekset_z   ;e7af  e8 ba       VECTOR   0x2F  'SEEKSET.Z..'
    .word msg_30_fern_on     ;e7b1  e8 bd       VECTOR   0x30  'FERN...ON..'
    .word msg_31_fern_off    ;e7b3  e8 c0       VECTOR   0x31  'FERN...OFF.'
    .word msg_32_testtun_on  ;e7b5  e8 c3       VECTOR   0x32  'TESTTUN.ON.'
    .word msg_33_test_q      ;e7b7  e8 c6       VECTOR   0x33  'TEST..Q....'
    .word msg_34_testbass    ;e7b9  e9 0a       VECTOR   0x34  'TESTBASS...'
    .word msg_35_testtreb    ;e7bb  e9 28       VECTOR   0x35  'TESTTREB...'
    .word msg_36_testtun_off ;e7bd  e9 2b       VECTOR   0x36  'TESTTUN.OFF'
    .word msg_37_on_tuning   ;e7bf  e9 2e       VECTOR   0x37  '.ON.TUNING.'

msgs_20_3f_done:
    call make_fis_text       ;e7c1  31 ec ce
    ret                      ;e7c4  20

msg_20_rad_3cp_t7:
;Buffer:  'RAD.3CP.T7.'
;Example: 'RAD 3CP T7 '
;
;No params
    jmp msgs_20_3f_done     ;e7c5  21 e7 c1

msg_21_ver:
;Buffer:  'VER........'
;Example: 'VER  0702  ' (Param 0 = None, Param 1 = First two digits)
;TODO finish me
    setb 0xa9:0             ;e7c8  a8 a9        Set "show period" flag

    incw ep                 ;e7ca  c3           EP = Display Param 1 (First two digits)
    mov a, @ep              ;e7cb  07
    call hex_nib_high       ;e7cc  31 ed 88
    mov @ix+0x05, a         ;e7cf  46 05

    mov a, @ep              ;e7d1  07
    call hex_nib_low     ;e7d2  31 ed 92
    mov @ix+0x06, a         ;e7d5  46 06

    movw ep, #table_e000+0x0b ;e7d7  e7 e0 0b   EP = constant byte from this ROM
    mov a, @ep              ;e7da  07           A = constant 0x02
    call hex_nib_high       ;e7db  31 ed 88
    mov @ix+0x07, a         ;e7de  46 07

    mov a, @ep              ;e7e0  07
    call hex_nib_low     ;e7e1  31 ed 92
    mov @ix+0x08, a         ;e7e4  46 08
    jmp msgs_20_3f_done     ;e7e6  21 e7 c1

msg_22_:
;Buffer:  '...........'
;Example: '1079A B C D' (param 0=freq index, param 1=0xAB, param 2=0xCD)
    mov a, @ep              ;e7e9  07           A = FM frequency index
    call num_to_mhz         ;e7ea  31 ed 33     A = BCD freq (word)
    mov r1, a               ;e7ed  49           R1 = BCD freq low byte
    swap                    ;e7ee  10
    mov r2, a               ;e7ef  4a           R2 = BCD freq high byte

    and a, #0xf0            ;e7f0  64 f0        Mask to leave only high nibble
    bz lab_e7f9             ;e7f2  fd 05        Skip digit if it is 0

    call hex_nib_high       ;e7f4  31 ed 88     A = ASCII digit for high nibble
    mov @ix+0x00, a         ;e7f7  46 00        Write digit into buffer

lab_e7f9:
    mov a, r2               ;e7f9  0a           A = BCD freq high byte
    call hex_nib_low        ;e7fa  31 ed 92     A = ASCII digit for low nibble
    mov @ix+0x01, a         ;e7fd  46 01        Write digit into buffer

    mov a, r1               ;e7ff  09           A = BCD freq low byte
    call hex_nib_high       ;e800  31 ed 88     A = ASCII digit for high nibble
    mov @ix+0x02, a         ;e803  46 02        Write digit into buffer

    mov a, r1               ;e805  09           A = BCD freq low byte
    call hex_nib_low        ;e806  31 ed 92     A = ASCII digit for low nibble
    mov @ix+0x03, a         ;e809  46 03        Write digit into buffer

msg_spaced_digits:
    incw ep                 ;e80b  c3           EP = pointer to Display Param 1

    mov a, @ep              ;e80c  07           A = param 1
    call hex_nib_high       ;e80d  31 ed 88     A = ASCII digit for param 1 high nibble
    mov @ix+0x04, a         ;e810  46 04        Write digit into buffer

    mov a, @ep              ;e812  07           A = param 1
    call hex_nib_low        ;e813  31 ed 92     A = ASCII digit for param 1 low nibble
    mov @ix+0x06, a         ;e816  46 06        Write digit into buffer

    incw ep                 ;e818  c3           EP = pointer to Display Param 2

    mov a, @ep              ;e819  07           A = param 2
    call hex_nib_high       ;e81a  31 ed 88     A = ASCII digit for param 2 high nibble
    mov @ix+0x08, a         ;e81d  46 08        Write digit into buffer

    mov a, @ep              ;e81f  07           A = param 2
    call hex_nib_low        ;e820  31 ed 92     A = ASCII digit for param 2 low nibble
    mov @ix+0x0a, a         ;e823  46 0a        Write digit into buffer
    jmp msgs_20_3f_done     ;e825  21 e7 c1

msg_23_hc:
;Buffer:  'HC.........'
;Example: 'HC 4A B C D' (param 0=0x04, param 1=0xAB, param2=0xCD)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e828  07           A = Display Param 0 (number)
    call hex_nib_low        ;e829  31 ed 92     A = Number as a hex digit
    mov @ix+0x03, a         ;e82c  46 03
    jmp msg_spaced_digits   ;e82e  21 e8 0b

msg_24_v:
;'V..........'
;TODO finish me
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e831  07
    and a, #0xf0            ;e832  64 f0
    beq lab_e878            ;e834  fd 42
    mov a, #'-              ;e836  04 2d
    mov @ix+0x01, a         ;e838  46 01
    mov a, @ep              ;e83a  07
    xor a, #0xff            ;e83b  54 ff
    incw a                  ;e83d  c0
lab_e83e:
    call hex_nib_low        ;e83e  31 ed 92
    mov @ix+0x02, a         ;e841  46 02
    incw ep                 ;e843  c3
    mov a, @ep              ;e844  07
    call bin_to_bcd         ;e845  31 ed 5d
    mov a, r6               ;e848  0e
    beq lab_e850            ;e849  fd 05
    call hex_nib_low        ;e84b  31 ed 92
    mov @ix+0x04, a         ;e84e  46 04
lab_e850:
    mov a, r7               ;e850  0f
    call hex_nib_high       ;e851  31 ed 88
    mov @ix+0x05, a         ;e854  46 05
    mov a, r7               ;e856  0f
    call hex_nib_low        ;e857  31 ed 92
    mov @ix+0x06, a         ;e85a  46 06
    incw ep                 ;e85c  c3
    mov a, @ep              ;e85d  07
    call bin_to_bcd         ;e85e  31 ed 5d
    mov a, r6               ;e861  0e
    beq lab_e869            ;e862  fd 05
    call hex_nib_low        ;e864  31 ed 92
    mov @ix+0x08, a         ;e867  46 08
lab_e869:
    mov a, r7               ;e869  0f
    call hex_nib_high       ;e86a  31 ed 88
    mov @ix+0x09, a         ;e86d  46 09
    mov a, r7               ;e86f  0f
    call hex_nib_low        ;e870  31 ed 92
    mov @ix+0x0a, a         ;e873  46 0a
    jmp msgs_20_3f_done     ;e875  21 e7 c1
lab_e878:
    mov a, #'+              ;e878  04 2b
    mov @ix+0x01, a         ;e87a  46 01
    mov a, @ep              ;e87c  07
    jmp lab_e83e            ;e87d  21 e8 3e

msg_25_seekset_m:
;Buffer:  'SEEKSET.M..'
;Example: 'SEEKSET M5 ' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e880  07           A = Display Param 0 (number)
    call hex_nib_low        ;e881  31 ed 92     A = number as hex digit
    mov @ix+0x09, a         ;e884  46 09
    jmp msgs_20_3f_done     ;e886  21 e7 c1

msg_26_seekset_n:
;Buffer:  'SEEKSET.N..'
;Example: 'SEEKSET N5 ' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_25_seekset_m    ;e889  21 e8 80

msg_27_seekset_m1:
;Buffer:  'SEEKSET.M1.'
;Example: 'SEEKSET M15' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e88c  07           A = Display Param 0 (number)
    call hex_nib_low        ;e88d  31 ed 92     A = number as hex digit
    mov @ix+0x0a, a         ;e890  46 0a
    jmp msgs_20_3f_done     ;e892  21 e7 c1

msg_28_seekset_m2:
;Buffer:  'SEEKSET.M2.'
;Example: 'SEEKSET M25' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_27_seekset_m1   ;e895  21 e8 8c

msg_29_seekset_m3:
;Buffer:  'SEEKSET.M3.'
;Example: 'SEEKSET M35' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_27_seekset_m1   ;e898  21 e8 8c

msg_2a_seekset_n1:
;Buffer:  'SEEKSET.N1.'
;Example: 'SEEKSET N15' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_27_seekset_m1   ;e89b  21 e8 8c

msg_2b_seekset_n2:
;Buffer:  'SEEKSET.N2.'
;Example: 'SEEKSET N25' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_27_seekset_m1   ;e89e  21 e8 8c

msg_2c_seekset_n3:
;Buffer:  'SEEKSET.N3.'
;Example: 'SEEKSET N35' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_27_seekset_m1   ;e8a1  21 e8 8c

msg_2d_seekset_x:
;Buffer:  'SEEKSET.X..'
;Example: 'SEEKSET X42' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e8a4  07
    and a, #0xf0            ;e8a5  64 f0
    beq lab_e8ae            ;e8a7  fd 05
    call hex_nib_high       ;e8a9  31 ed 88
    mov @ix+0x09, a         ;e8ac  46 09
lab_e8ae:
    mov a, @ep              ;e8ae  07
    call hex_nib_low        ;e8af  31 ed 92
    mov @ix+0x0a, a         ;e8b2  46 0a
    jmp msgs_20_3f_done     ;e8b4  21 e7 c1

msg_2e_seekset_y:
;Buffer:  'SEEKSET.Y..'
;Example: 'SEEKSET Y42' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_2d_seekset_x    ;e8b7  21 e8 a4

msg_2f_seekset_z:
;Buffer:  'SEEKSET.Z..'
;Example: 'SEEKSET Z42' (Param 0 = number)
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    jmp msg_2d_seekset_x    ;e8ba  21 e8 a4

msg_30_fern_on:
;Buffer:  'FERN...ON..'
;Example: 'FERN   ON  ' (no params)
    jmp msgs_20_3f_done     ;e8bd  21 e7 c1

msg_31_fern_off:
;Buffer:  'FERN...OFF.'
;Example: 'FERN   OFF ' (no params)
    jmp msgs_20_3f_done     ;e8c0  21 e7 c1

msg_32_testtun_on:
;Buffer:  'TESTTUN.ON.'
;Example: 'TESTTUN ON ' (no params)
    jmp msgs_20_3f_done     ;e8c3  21 e7 c1

msg_33_test_q:
;Buffer:  'TEST..Q....'
;Example: TODO finish me
;EP = 0x011e (pointer to Display Param 0 in command packet)
;IX = 0x012f (pointer to buffer for this message)
    mov a, @ep              ;e8c6  07
    and a, #0xf0            ;e8c7  64 f0
    beq lab_e8d0            ;e8c9  fd 05
    call hex_nib_high       ;e8cb  31 ed 88
    mov @ix+0x04, a         ;e8ce  46 04
lab_e8d0:
    mov a, @ep              ;e8d0  07
    call hex_nib_low        ;e8d1  31 ed 92
    mov @ix+0x05, a         ;e8d4  46 05
    incw ep                 ;e8d6  c3
    mov a, @ep              ;e8d7  07
    call hex_nib_low        ;e8d8  31 ed 92
    mov @ix+0x07, a         ;e8db  46 07
    incw ep                 ;e8dd  c3
    mov a, @ep              ;e8de  07
    and a, #0xf0            ;e8df  64 f0
    beq lab_e902            ;e8e1  fd 1f
    mov a, #'-              ;e8e3  04 2d
    mov @ix+0x08, a         ;e8e5  46 08
    mov a, @ep              ;e8e7  07
    xor a, #0xff            ;e8e8  54 ff
    incw a                  ;e8ea  c0
lab_e8eb:
    clrc                    ;e8eb  81
    addc a, #0x00           ;e8ec  24 00
    daa                     ;e8ee  84
    mov r0, a               ;e8ef  48
    call hex_nib_high       ;e8f0  31 ed 88
    cmp a, #'0              ;e8f3  14 30
    beq lab_e8f9            ;e8f5  fd 02
    mov @ix+0x09, a         ;e8f7  46 09
lab_e8f9:
    mov a, r0               ;e8f9  08
    call hex_nib_low        ;e8fa  31 ed 92
    mov @ix+0x0a, a         ;e8fd  46 0a
    jmp msgs_20_3f_done     ;e8ff  21 e7 c1
lab_e902:
    mov a, #'+              ;e902  04 2b
    mov @ix+0x08, a         ;e904  46 08
    mov a, @ep              ;e906  07
    jmp lab_e8eb            ;e907  21 e8 eb

msg_34_testbass:
;'TESTBASS...'
    mov a, @ep              ;e90a  07
    mov r0, a               ;e90b  48
    beq lab_e913            ;e90c  fd 05
    rolc a                  ;e90e  02
    bc lab_e91e            ;e90f  f9 0d
    mov a, #'+              ;e911  04 2b
lab_e913:
    mov @ix+0x09, a         ;e913  46 09
    mov a, r0               ;e915  08
    call hex_nib_low        ;e916  31 ed 92
    mov @ix+0x0a, a         ;e919  46 0a
    jmp msgs_20_3f_done     ;e91b  21 e7 c1
lab_e91e:
    mov a, r0               ;e91e  08
    xor a, #0xff            ;e91f  54 ff
    incw a                  ;e921  c0
    mov r0, a               ;e922  48
    mov a, #'-              ;e923  04 2d
    jmp lab_e913            ;e925  21 e9 13

msg_35_testtreb:
;'TESTTREB...'
    jmp msg_34_testbass     ;e928  21 e9 0a

msg_36_testtun_off:
;'TESTTUN.OFF'
    jmp msgs_20_3f_done     ;e92b  21 e7 c1

msg_37_on_tuning:
;'.ON.TUNING.'
    jmp msgs_20_3f_done     ;e92e  21 e7 c1

msgs_40_4f:
;Called if A >= 0x40 and A <= 0x4F (tuner messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;e931  e4 00 00
    mov a, @ep              ;e934  07
    mov a, #0x40            ;e935  04 40
    clrc                    ;e937  81
    subc a                  ;e938  32
    mov r0, a               ;e939  48
    movw a, #0x000b         ;e93a  e4 00 0b
    mulu a                  ;e93d  01
    movw a, #msgs_40_4f_text ;e93e  e4 ef bd     A = pointer to tuner messages
    clrc                    ;e941  81
    addcw a                 ;e942  23
    movw ix, a              ;e943  e2
    movw ep, #0x012f        ;e944  e7 01 2f
    call copy_11_ix_to_ep   ;e947  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;e94a  e6 01 2f
    movw ep, #0x011e        ;e94d  e7 01 1e
    movw a, #0x0000         ;e950  e4 00 00
    mov a, r0               ;e953  08
    cmp a, #0x08            ;e954  14 08
    bhs msgs_40_4f_done     ;e956  f8 19
    clrc                    ;e958  81
    rolc a                  ;e959  02
    movw a, #msgs_40_4f_jmp ;e95a  e4 e9 61
    clrc                    ;e95d  81
    addcw a                 ;e95e  23
    movw a, @a              ;e95f  93
    jmp @a                  ;e960  e0

msgs_40_4f_jmp:
    .word msg_40_fm_mhz     ;e961  e9 75       VECTOR   0x40  'FM......MHZ'
    .word msg_41_am_khz     ;e963  e9 af       VECTOR   0x41  'AM......KHZ'
    .word msg_42_scan_mhz   ;e965  e9 c1       VECTOR   0x42  'SCAN....MHZ'
    .word msg_43_scan_khz   ;e967  e9 c6       VECTOR   0x43  'SCAN....KHZ'
    .word msg_44_fm_max     ;e969  e9 c9       VECTOR   0x44  'FM....MAX..'
    .word msg_45_fm_min     ;e96b  e9 de       VECTOR   0x45  'FM....MIN..'
    .word msg_46_am_max     ;e96d  e9 e1       VECTOR   0x46  'AM....MAX..'
    .word msg_47_am_min     ;e96f  e9 ee       VECTOR   0x47  'AM....MIN..'

msgs_40_4f_done:
    call make_fis_text      ;e971  31 ec ce
    ret                     ;e974  20

msg_40_fm_mhz:
;Buffer:  'FM......MHZ'
;Example: 'FM261389MHZ'
;
;Param 0 High Nibble = 1, 2 for FM1, FM2
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
    setb 0xa9:0             ;e975  a8 a9        Set "show period" flag
    setb 0xa9:1             ;e977  a9 a9        Set "mode or preset digits" flag

    mov a, @ep              ;e979  07           A = display param 0 (high nib = FM1/2, low = preset)
    call hex_nib_high       ;e97a  31 ed 88     A = ASCII digit for high nibble (FM "1" or "2")
    mov @ix+0x02, a         ;e97d  46 02        Write 1/2 for FM1/2 into buffer

    mov a, @ep              ;e97f  07           A = display param 0 (high nib = FM1/2, low = preset)
    call hex_nib_low        ;e980  31 ed 92     A = ASCII digit for preset ("1" to "6", "0" if none)
    cmp a, #'0              ;e983  14 30        Preset = 0 (no preset)?
    beq lab_e989            ;e985  fd 02          Yes: branch to leave preset blank
    mov @ix+0x03, a         ;e987  46 03        Write preset digit into buffer

lab_e989:
    incw ep                 ;e989  c3           EP = pointer to display param 1 (FM frequency index)
    mov a, @ep              ;e98a  07           A = FM frequency index
    call num_to_mhz         ;e98b  31 ed 33     A = BCD freq (word)

lab_e98e:
    mov r1, a               ;e98e  49           R1 = BCD freq low byte
    swap                    ;e98f  10
    mov r2, a               ;e990  4a           R2 = BCD freq high byte

    and a, #0xf0            ;e991  64 f0        Mask to leave only high nibble
    bz lab_e99a             ;e993  fd 05        Skip digit if it is 0

    call hex_nib_high       ;e995  31 ed 88     A = ASCII digit for high nibble
    mov @ix+0x04, a         ;e998  46 04        Write digit into buffer

lab_e99a:
    mov a, r2               ;e99a  0a           A = BCD freq high byte
    call hex_nib_low        ;e99b  31 ed 92     A = ASCII digit for low nibble
    mov @ix+0x05, a         ;e99e  46 05        Write digit into buffer

    mov a, r1               ;e9a0  09           A = BCD freq low byte
    call hex_nib_high       ;e9a1  31 ed 88     A = ASCII digit for high nibble
    mov @ix+0x06, a         ;e9a4  46 06        Write digit into buffer

    mov a, r1               ;e9a6  09           A = BCD freq low byte
    call hex_nib_low        ;e9a7  31 ed 92     A = ASCII digit for low nibble
    mov @ix+0x07, a         ;e9aa  46 07        Write digit into buffer
    jmp msgs_40_4f_done     ;e9ac  21 e9 71

msg_41_am_khz:
;Buffer:  'AM......KHZ'
;Example: 'AM 2 540KHZ'
;
;Param 0 High Nibble = Unused
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = AM Frequency Index (0=540 kHz, 3080 kHz)
;Param 2 Byte        = Unused
    mov a, @ep              ;e9af  07           A = display param 0 (preset number)
    call hex_nib_low        ;e9b0  31 ed 92     A = ASCII digit for preset
    cmp a, #'0              ;e9b3  14 30        Preset = 0 (no preset)?
    beq lab_e9b9            ;e9b5  fd 02          Yes: branch to leave preset blank
    mov @ix+0x03, a         ;e9b7  46 03        Write preset digit into buffer
lab_e9b9:
    incw ep                 ;e9b9  c3           EP = pointer to display param 1 (AM frequency index)
    mov a, @ep              ;e9ba  07           A = AM frequency index
    call num_to_khz         ;e9bb  31 ed 53     A = BCD freq (word)
    jmp lab_e98e            ;e9be  21 e9 8e

msg_42_scan_mhz:
;Buffer:  'SCAN....MHZ'
;Example: 'SCAN1079MHZ'
;
;Param 0 Byte        = Unused
;Param 1 Byte        = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
;Param 2 Byte        = Unused
    setb 0xa9:0             ;e9c1  a8 a9        Set "show period" flag
    jmp lab_e989            ;e9c3  21 e9 89

msg_43_scan_khz:
;Buffer:  'SCAN....KHZ'
;Example: 'SCAN1079KHZ'
;
;Param 0 Byte       = Unused
;Param 1 Byte       = AM Frequency Index (0=540 kHz, 3080 kHz)
;Param 2 Byte       = Unused
    jmp lab_e9b9            ;e9c6  21 e9 b9

msg_44_fm_max:
;Buffer:  'FM....MAX..'
;Example: 'FM26  MAX  '
;
;Param 0 High Nibble = 1, 2 for FM1, FM2
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    setb 0xa9:1             ;e9c9  a9 a9        Set "mode or preset digits" flag
    mov a, @ep              ;e9cb  07           A = display param 0
    call hex_nib_high       ;e9cc  31 ed 88
    mov @ix+0x02, a         ;e9cf  46 02
    mov a, @ep              ;e9d1  07
    call hex_nib_low        ;e9d2  31 ed 92
    cmp a, #'0              ;e9d5  14 30
    beq lab_e9db            ;e9d7  fd 02
    mov @ix+0x03, a         ;e9d9  46 03
lab_e9db:
    jmp msgs_40_4f_done     ;e9db  21 e9 71

msg_45_fm_min:
;Buffer:  'FM....MIN..'
;Example: 'FM26  MIN  '
;
;Param 0 High Nibble = 1, 2 for FM1, FM2
;Param 0 Low Nibble  = Preset number (0=none, 1-6)
;Param 1 Byte        = Unused
;Param 2 Byte        = Unused
    jmp msg_44_fm_max       ;e9de  21 e9 c9

msg_46_am_max:
;Buffer:  'AM....MAX..'
;Example: 'AM 6  MAX  '
;
;Param 0 High Nibble = Unused
;Param 1 Byte        = Preset number (0=none, 1-6)
;Param 2 Byte        = Unused
    mov a, @ep              ;e9e1  07           A = display param 0 (preset)
    call hex_nib_low        ;e9e2  31 ed 92     A = ASCII digit for preset
    cmp a, #'0              ;e9e5  14 30        Preset = 0 (no preset)?
    beq lab_e9eb            ;e9e7  fd 02          Yes: branch to leave preset blank
    mov @ix+0x03, a         ;e9e9  46 03        Write digit into buffer
lab_e9eb:
    jmp msgs_40_4f_done     ;e9eb  21 e9 71

msg_47_am_min:
;Buffer:  'AM....MIN..'
;Example: 'AM 6  MIN  '
;
;Param 0 High Nibble = Unused
;Param 1 Byte        = Preset number (0=none, 1-6)
;Param 2 Byte        = Unused
    jmp msg_46_am_max       ;e9ee  21 e9 e1

msgs_50_5f:
;Called if A >= 50 and A <= 0x5F (tape messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;e9f1  e4 00 00
    mov a, @ep              ;e9f4  07
    mov a, #0x50            ;e9f5  04 50
    clrc                    ;e9f7  81
    subc a                  ;e9f8  32
    mov r0, a               ;e9f9  48
    movw a, #0x000b         ;e9fa  e4 00 0b
    mulu a                  ;e9fd  01
    movw a, #msgs_50_5f_text ;e9fe  e4 f0 15     A = pointer to tape messages
    clrc                    ;ea01  81
    addcw a                 ;ea02  23
    movw ix, a              ;ea03  e2
    movw ep, #0x012f        ;ea04  e7 01 2f
    call copy_11_ix_to_ep   ;ea07  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;ea0a  e6 01 2f
    movw ep, #0x011e        ;ea0d  e7 01 1e
    movw a, #0x0000         ;ea10  e4 00 00
    mov a, r0               ;ea13  08
    cmp a, #0x0e            ;ea14  14 0e
    bhs msgs_50_5f_done     ;ea16  f8 25
    clrc                    ;ea18  81
    rolc a                  ;ea19  02
    movw a, #msgs_50_5f_jmp ;ea1a  e4 ea 21
    clrc                    ;ea1d  81
    addcw a                 ;ea1e  23
    movw a, @a              ;ea1f  93
    jmp @a                  ;ea20  e0

msgs_50_5f_jmp:
    .word msg_50_tape_play_a  ;ea21  ea 41       VECTOR   0x50  'TAPE.PLAY.A'
    .word msg_51_tape_play_b  ;ea23  ea 44       VECTOR   0x51  'TAPE.PLAY.B'
    .word msg_52_tape_ff      ;ea25  ea 47       VECTOR   0x52  'TAPE..FF...'
    .word msg_53_tape_rew     ;ea27  ea 4a       VECTOR   0x53  'TAPE..REW..'
    .word msg_54_tape_mss_ff  ;ea29  ea 4d       VECTOR   0x54  'TAPEMSS.FF.'
    .word msg_55_tape_mss_rew ;ea2b  ea 50       VECTOR   0x55  'TAPEMSS.REW'
    .word msg_56_tape_scan_a  ;ea2d  ea 53       VECTOR   0x56  'TAPE.SCAN.A'
    .word msg_57_tape_scan_b  ;ea2f  ea 56       VECTOR   0x57  'TAPE.SCAN.B'
    .word msg_58_tape_metal   ;ea31  ea 59       VECTOR   0x58  'TAPE.METAL.'
    .word msg_59_tape_bls     ;ea33  ea 5c       VECTOR   0x59  'TAPE..BLS..'
    .word msg_5a_no_tape      ;ea35  ea 5f       VECTOR   0x5A  '....NO.TAPE'
    .word msg_5b_tape_error   ;ea37  ea 62       VECTOR   0x5B  'TAPE.ERROR.'
    .word msg_5c_tape_max     ;ea39  ea 65       VECTOR   0x5C  'TAPE..MAX..'
    .word msg_5d_tape_min     ;ea3b  ea 68       VECTOR   0x5D  'TAPE..MIN..'

msgs_50_5f_done:
    call make_fis_text      ;ea3d  31 ec ce
    ret                     ;ea40  20

msg_50_tape_play_a:
;Buffer:  'TAPE.PLAY.A'
;Example: 'TAPE PLAY A'
;
;No params
    jmp msgs_50_5f_done     ;ea41  21 ea 3d

msg_51_tape_play_b:
;'TAPE.PLAY.B'
    jmp msgs_50_5f_done     ;ea44  21 ea 3d

msg_52_tape_ff:
;'TAPE..FF...'
    jmp msgs_50_5f_done     ;ea47  21 ea 3d

msg_53_tape_rew:
;'TAPE..REW..'
    jmp msgs_50_5f_done     ;ea4a  21 ea 3d

msg_54_tape_mss_ff:
;'TAPEMSS.FF.'
    jmp msgs_50_5f_done     ;ea4d  21 ea 3d

msg_55_tape_mss_rew:
;'TAPEMSS.REW'
    jmp msgs_50_5f_done     ;ea50  21 ea 3d

msg_56_tape_scan_a:
;'TAPE.SCAN.A'
    jmp msgs_50_5f_done     ;ea53  21 ea 3d

msg_57_tape_scan_b:
;'TAPE.SCAN.B'
    jmp msgs_50_5f_done     ;ea56  21 ea 3d

msg_58_tape_metal:
;'TAPE.METAL.'
    jmp msgs_50_5f_done     ;ea59  21 ea 3d

msg_59_tape_bls:
;'TAPE..BLS..'
    jmp msgs_50_5f_done     ;ea5c  21 ea 3d

msg_5a_no_tape:
;'....NO.TAPE'
    jmp msgs_50_5f_done     ;ea5f  21 ea 3d

msg_5b_tape_error:
;'TAPE.ERROR.'
    jmp msgs_50_5f_done     ;ea62  21 ea 3d

msg_5c_tape_max:
;'TAPE..MAX..'
    jmp msgs_50_5f_done     ;ea65  21 ea 3d

msg_5d_tape_min:
;'TAPE..MIN..'
    jmp msgs_50_5f_done     ;ea68  21 ea 3d

msgs_60_7f:
;Called if A >= 0x60 and A <= 0x7F (sound messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;ea6b  e4 00 00
    mov a, @ep              ;ea6e  07
    mov a, #0x60            ;ea6f  04 60
    clrc                    ;ea71  81
    subc a                  ;ea72  32
    mov r0, a               ;ea73  48
    cmp a, #0x02            ;ea74  14 02
    blo lab_ea88            ;ea76  f9 10
    movw a, #0x000b         ;ea78  e4 00 0b
    mulu a                  ;ea7b  01
    movw a, #msgs_60_7f_text ;ea7c  e4 f0 af     A = pointer to sound messages
    clrc                    ;ea7f  81
    addcw a                 ;ea80  23
    movw ix, a              ;ea81  e2
    movw ep, #0x012f        ;ea82  e7 01 2f
    call copy_11_ix_to_ep   ;ea85  31 ec a1     Copy 11 bytes from @ix to @ep
lab_ea88:
    movw ix, #0x012f        ;ea88  e6 01 2f
    movw ep, #0x011e        ;ea8b  e7 01 1e
    movw a, #0x0000         ;ea8e  e4 00 00
    mov a, r0               ;ea91  08
    cmp a, #0x0a            ;ea92  14 0a
    bhs msgs_60_7f_done     ;ea94  f8 1d
    clrc                    ;ea96  81
    rolc a                  ;ea97  02
    movw a, #msgs_60_7f_jmp ;ea98  e4 ea 9f
    clrc                    ;ea9b  81
    addcw a                 ;ea9c  23
    movw a, @a              ;ea9d  93
    jmp @a                  ;ea9e  e0

msgs_60_7f_jmp:
    .word msg_60_max        ;ea9f  ea b7       VECTOR   0x60  '.....MAX...'
    .word msg_61_min        ;eaa1  ea d2       VECTOR   0x61  '.....MIN...'
    .word msg_61_bass       ;eaa3  ea ed       VECTOR   0x62  'BASS.......'
    .word msg_63_treb       ;eaa5  eb 0b       VECTOR   0x63  'TREB.......'
    .word msg_64_bal_left   ;eaa7  eb 0e       VECTOR   0x64  'BAL.LEFT...'
    .word msg_65_bal_right  ;eaa9  eb 3d       VECTOR   0x65  'BAL.RIGHT..'
    .word msg_66_bal_center ;eaab  eb 6c       VECTOR   0x66  'BAL.CENTER.'
    .word msg_67_fadefront  ;eaad  eb 6f       VECTOR   0x67  'FADEFRONT..'
    .word msg_68_faderear   ;eaaf  eb 72       VECTOR   0x68  'FADEREAR...'
    .word msg_69_fadecenter ;eab1  eb 75       VECTOR   0x69  'FADECENTER.'

msgs_60_7f_done:
    call make_fis_text      ;eab3  31 ec ce
    ret                     ;eab6  20

msg_60_max:
;'.....MAX...'
    mov a, #0x00            ;eab7  04 00
    mov @ix+0x04, a         ;eab9  46 04
    mov @ix+0x05, a         ;eabb  46 05
    mov a, #'M              ;eabd  04 4d
    mov @ix+0x06, a         ;eabf  46 06
    mov a, #'A              ;eac1  04 41
    mov @ix+0x07, a         ;eac3  46 07
    mov a, #'X              ;eac5  04 58
    mov @ix+0x08, a         ;eac7  46 08
    mov a, #0x00            ;eac9  04 00
    mov @ix+0x09, a         ;eacb  46 09
    mov @ix+0x0a, a         ;eacd  46 0a
    jmp msgs_60_7f_done     ;eacf  21 ea b3

msg_61_min:
;'.....MIN...'
    mov a, #0x00            ;ead2  04 00
    mov @ix+0x04, a         ;ead4  46 04
    mov @ix+0x05, a         ;ead6  46 05
    mov a, #'M              ;ead8  04 4d
    mov @ix+0x06, a         ;eada  46 06
    mov a, #'I              ;eadc  04 49
    mov @ix+0x07, a         ;eade  46 07
    mov a, #'N              ;eae0  04 4e
    mov @ix+0x08, a         ;eae2  46 08
    mov a, #0x00            ;eae4  04 00
    mov @ix+0x09, a         ;eae6  46 09
    mov @ix+0x0a, a         ;eae8  46 0a
    jmp msgs_60_7f_done     ;eaea  21 ea b3

msg_61_bass:
;'BASS.......'
    mov a, @ep              ;eaed  07
    mov r0, a               ;eaee  48
    beq lab_eaf6            ;eaef  fd 05
    rolc a                  ;eaf1  02
    blo lab_eb01            ;eaf2  f9 0d
    mov a, #'+              ;eaf4  04 2b
lab_eaf6:
    mov @ix+0x06, a         ;eaf6  46 06
    mov a, r0               ;eaf8  08
    call hex_nib_low        ;eaf9  31 ed 92
    mov @ix+0x08, a         ;eafc  46 08
    jmp msgs_60_7f_done     ;eafe  21 ea b3
lab_eb01:
    mov a, r0               ;eb01  08
    xor a, #0xff            ;eb02  54 ff
    incw a                  ;eb04  c0
    mov r0, a               ;eb05  48
    mov a, #'-              ;eb06  04 2d
    jmp lab_eaf6            ;eb08  21 ea f6

msg_63_treb:
;'TREB.......'
    jmp msg_61_bass         ;eb0b  21 ea ed

msg_64_bal_left:
;'BAL.LEFT...'
    mov a, @ep              ;eb0e  07
    and a, #0xf0            ;eb0f  64 f0
    cmp a, #0xf0            ;eb11  14 f0
    beq lab_eb32            ;eb13  fd 1d
    mov a, @ep              ;eb15  07
    cmp a, #0x09            ;eb16  14 09
    blo lab_eb1f            ;eb18  f9 05
    clrc                    ;eb1a  81
    addc a, #0x00           ;eb1b  24 00
    daa                     ;eb1d  84
    mov @ep, a              ;eb1e  47
lab_eb1f:
    mov a, @ep              ;eb1f  07
    and a, #0xf0            ;eb20  64 f0
    beq lab_eb29            ;eb22  fd 05
    call hex_nib_high       ;eb24  31 ed 88
    mov @ix+0x09, a         ;eb27  46 09
lab_eb29:
    mov a, @ep              ;eb29  07
    call hex_nib_low        ;eb2a  31 ed 92
    mov @ix+0x0a, a         ;eb2d  46 0a
    jmp msgs_60_7f_done     ;eb2f  21 ea b3
lab_eb32:
    mov a, @ep              ;eb32  07
    xor a, #0xff            ;eb33  54 ff
    clrc                    ;eb35  81
    addc a, #0x01           ;eb36  24 01
    daa                     ;eb38  84
    mov @ep, a              ;eb39  47
    jmp lab_eb1f            ;eb3a  21 eb 1f

msg_65_bal_right:
;'BAL.RIGHT..'
    mov a, @ep              ;eb3d  07
    and a, #0xf0            ;eb3e  64 f0
    cmp a, #0xf0            ;eb40  14 f0
    beq lab_eb61            ;eb42  fd 1d
    mov a, @ep              ;eb44  07
    cmp a, #0x09            ;eb45  14 09
    blo lab_eb4e            ;eb47  f9 05
    clrc                    ;eb49  81
    addc a, #0x00           ;eb4a  24 00
    daa                     ;eb4c  84
    mov @ep, a              ;eb4d  47
lab_eb4e:
    mov a, @ep              ;eb4e  07
    and a, #0xf0            ;eb4f  64 f0
    beq lab_eb58            ;eb51  fd 05
    call hex_nib_high       ;eb53  31 ed 88
    mov @ix+0x09, a         ;eb56  46 09
lab_eb58:
    mov a, @ep              ;eb58  07
    call hex_nib_low        ;eb59  31 ed 92
    mov @ix+0x0a, a         ;eb5c  46 0a
    jmp msgs_60_7f_done     ;eb5e  21 ea b3
lab_eb61:
    mov a, @ep              ;eb61  07
    xor a, #0xff            ;eb62  54 ff
    clrc                    ;eb64  81
    addc a, #0x01           ;eb65  24 01
    daa                     ;eb67  84
    mov @ep, a              ;eb68  47
    jmp lab_eb4e            ;eb69  21 eb 4e

msg_66_bal_center:
;'BAL.CENTER.'
    jmp msgs_60_7f_done     ;eb6c  21 ea b3

msg_67_fadefront:
;'FADEFRONT..'
    jmp msg_65_bal_right    ;eb6f  21 eb 3d

msg_68_faderear:
;'FADEREAR...'
    jmp msg_64_bal_left     ;eb72  21 eb 0e

msg_69_fadecenter:
;'FADECENTER.'
    jmp msgs_60_7f_done     ;eb75  21 ea b3

msgs_80_af:
;Called if A >= 0x80 and A < 0xB0 (code messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;eb78  e4 00 00
    mov a, @ep              ;eb7b  07
    mov a, #0x80            ;eb7c  04 80
    clrc                    ;eb7e  81
    subc a                  ;eb7f  32
    mov r0, a               ;eb80  48
    movw a, #0x000b         ;eb81  e4 00 0b
    mulu a                  ;eb84  01
    movw a, #msgs_80_af_text ;eb85  e4 f1 1d     A = pointer to code messages
    clrc                    ;eb88  81
    addcw a                 ;eb89  23
    movw ix, a              ;eb8a  e2
    movw ep, #0x012f        ;eb8b  e7 01 2f
    call copy_11_ix_to_ep   ;eb8e  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;eb91  e6 01 2f
    movw ep, #0x011e        ;eb94  e7 01 1e
    movw a, #0x0000         ;eb97  e4 00 00
    mov a, r0               ;eb9a  08
    cmp a, #0x08            ;eb9b  14 08
    bhs msgs_80_af_done     ;eb9d  f8 19
    clrc                    ;eb9f  81
    rolc a                  ;eba0  02
    movw a, #msgs_80_af_jmp ;eba1  e4 eb a8
    clrc                    ;eba4  81
    addcw a                 ;eba5  23
    movw a, @a              ;eba6  93
    jmp @a                  ;eba7  e0

msgs_80_af_jmp:
    .word msg_80_no_code    ;eba8  eb bc       VECTOR   0x80  '....NO.CODE'
    .word msg_81_code       ;ebaa  eb bf       VECTOR   0x81  '.....CODE..'
    .word msg_82_           ;ebac  eb c2       VECTOR   0x82  '...........'
    .word msg_83_safe       ;ebae  eb e9       VECTOR   0x83  '.....SAFE..'
    .word msg_84_initial    ;ebb0  eb f6       VECTOR   0x84  '....INITIAL'
    .word msg_85_no_code    ;ebb2  eb f9       VECTOR   0x85  '....NO.CODE'
    .word msg_86_safe       ;ebb4  eb fc       VECTOR   0x86  '.....SAFE..'
    .word msg_87_clear      ;ebb6  ec 0f       VECTOR   0x87  '....CLEAR..'

msgs_80_af_done:
    call make_fis_text      ;ebb8  31 ec ce
    ret                     ;ebbb  20

msg_80_no_code:
;'....NO.CODE'
    jmp msgs_80_af_done     ;ebbc  21 eb b8

msg_81_code:
;'.....CODE..'
    jmp msgs_80_af_done     ;ebbf  21 eb b8

msg_82_:
;Buffer:  '...........'
;Example:
    mov a, @ep              ;ebc2  07       A = Display Param 0 (Attempt)
    and a, #0x0f            ;ebc3  64 0f    Mask to leave only low nibble
    bz lab_ebcc             ;ebc5  fd 05    Skip writing attempt if it is 0
    call hex_nib_low        ;ebc7  31 ed 92 A = ASCII digit for attempt
    mov @ix+0x00, a         ;ebca  46 00    Write attempt into the buffer
lab_ebcc:
    incw ep                 ;ebcc  c3       A = Display Param 1
    mov a, @ep              ;ebcd  07
    call hex_nib_high       ;ebce  31 ed 88
    mov @ix+0x05, a         ;ebd1  46 05
    mov a, @ep              ;ebd3  07
    call hex_nib_low        ;ebd4  31 ed 92
    mov @ix+0x06, a         ;ebd7  46 06

    incw ep                 ;ebd9  c3       A = Display Param 2
    mov a, @ep              ;ebda  07
    call hex_nib_high       ;ebdb  31 ed 88
    mov @ix+0x07, a         ;ebde  46 07
    mov a, @ep              ;ebe0  07
    call hex_nib_low        ;ebe1  31 ed 92
    mov @ix+0x08, a         ;ebe4  46 08
    jmp msgs_80_af_done     ;ebe6  21 eb b8

msg_83_safe:
;Buffer:  '.....SAFE..'
;Example: '2....SAFE..' (Param 0 = Attempt number)
    mov a, @ep              ;ebe9  07       A = Display Param 0 (Attempt)
    and a, #0x0f            ;ebea  64 0f    Mask off all except low nibble
    bz lab_ebf3             ;ebec  fd 05    Skip if low nibble = 0
    call hex_nib_low        ;ebee  31 ed 92 A = ASCII digit for attempt
    mov @ix+0x00, a         ;ebf1  46 00    Write it into the buffer
lab_ebf3:
    jmp msgs_80_af_done     ;ebf3  21 eb b8

msg_84_initial:
;'....INITIAL'
    jmp msgs_80_af_done     ;ebf6  21 eb b8

msg_85_no_code:
;'....NO.CODE'
    jmp msgs_80_af_done     ;ebf9  21 eb b8

msg_86_safe:
;Buffer:  '.....SAFE..'
;Example: '05...SAFE..' (Param 0 = Attempt number)
    mov a, @ep              ;ebfc  07       A = Display Param 0 (Attempt)
    call bin_to_bcd         ;ebfd  31 ed 5d R7 = Attempt converted to BCD

    mov a, r7               ;ec00  0f       A = ten's place and one's place
    call hex_nib_high       ;ec01  31 ed 88 A = ASCII digit for ten's place
    mov @ix+0x00, a         ;ec04  46 00    Write it in the buffer

    mov a, r7               ;ec06  0f       A = ten's place and one's place
    call hex_nib_low        ;ec07  31 ed 92 A = ASCII digit for one's place
    mov @ix+0x01, a         ;ec0a  46 01    Write it in the buffer
    jmp msgs_80_af_done     ;ec0c  21 eb b8

msg_87_clear:
;'....CLEAR..'
    jmp msgs_80_af_done     ;ec0f  21 eb b8

msgs_b0_bf:
;Called if A >= 0xB0 and A < 0xC0 (diag messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;ec12  e4 00 00
    mov a, @ep              ;ec15  07
    mov a, #0xb0            ;ec16  04 b0
    clrc                    ;ec18  81
    subc a                  ;ec19  32
    mov r0, a               ;ec1a  48
    movw a, #0x000b         ;ec1b  e4 00 0b
    mulu a                  ;ec1e  01
    movw a, #msgs_b0_bf_text ;ec1f  e4 f1 75     A = pointer to diag messages
    clrc                    ;ec22  81
    addcw a                 ;ec23  23
    movw ix, a              ;ec24  e2
    movw ep, #0x012f        ;ec25  e7 01 2f
    call copy_11_ix_to_ep   ;ec28  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;ec2b  e6 01 2f
    movw ep, #0x011e        ;ec2e  e7 01 1e
    movw a, #0x0000         ;ec31  e4 00 00
    mov a, r0               ;ec34  08
    cmp a, #0x02            ;ec35  14 02
    bhs msgs_b0_bf_done     ;ec37  f8 0d
    clrc                    ;ec39  81
    rolc a                  ;ec3a  02
    movw a, #msgs_b0_bf_jmp ;ec3b  e4 ec 42
    clrc                    ;ec3e  81
    addcw a                 ;ec3f  23
    movw a, @a              ;ec40  93
    jmp @a                  ;ec41  e0

msgs_b0_bf_jmp:
    .word msg_b0_diag        ;ec42  ec 4a       VECTOR   A=0x00  '.....DIAG..'
    .word msg_b1_testdisplay ;ec44  ec 4d       VECTOR   A=0x01 'TESTDISPLAY'

msgs_b0_bf_done:
    call make_fis_text      ;ec46  31 ec ce
    ret                     ;ec49  20

msg_b0_diag:
;'.....DIAG..'
    jmp msgs_b0_bf_done     ;ec4a  21 ec 46

msg_b1_testdisplay:
;'TESTDISPLAY'
    jmp msgs_b0_bf_done     ;ec4d  21 ec 46

msgs_c0_cf:
;Called if A >= 0xC0 and A <= 0xCF (bose messages)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;ec50  e4 00 00
    mov a, @ep              ;ec53  07
    mov a, #0xc0            ;ec54  04 c0
    clrc                    ;ec56  81
    subc a                  ;ec57  32
    mov r0, a               ;ec58  48
    movw a, #0x000b         ;ec59  e4 00 0b
    mulu a                  ;ec5c  01
    movw a, #msgs_c0_cf_text ;ec5d  e4 f1 8b     A = pointer to bose messages
    clrc                    ;ec60  81
    addcw a                 ;ec61  23
    movw ix, a              ;ec62  e2
    movw ep, #0x012f        ;ec63  e7 01 2f
    call copy_11_ix_to_ep   ;ec66  31 ec a1     Copy 11 bytes from @ix to @ep
    movw ix, #0x012f        ;ec69  e6 01 2f
    movw ep, #0x011e        ;ec6c  e7 01 1e
    movw a, #0x0000         ;ec6f  e4 00 00
    mov a, r0               ;ec72  08
    cmp a, #0x02            ;ec73  14 02
    bhs msgs_c0_cf_done     ;ec75  f8 0d
    clrc                    ;ec77  81
    rolc a                  ;ec78  02
    movw a, #msgs_c0_cf_jmp ;ec79  e4 ec 80
    clrc                    ;ec7c  81
    addcw a                 ;ec7d  23
    movw a, @a              ;ec7e  93
    jmp @a                  ;ec7f  e0

msgs_c0_cf_jmp:
    .word msg_c0_bose       ;ec80  ec 88       VECTOR   0xC0  '.....BOSE..'
    .word msg_c1_           ;ec82  ec 8b       VECTOR   0xC1  '...........'

msgs_c0_cf_done:
    call make_fis_text      ;ec84  31 ec ce
    ret                     ;ec87  20

msg_c0_bose:
;'.....BOSE..'
    jmp msgs_c0_cf_done     ;ec88  21 ec 84

msg_c1_:
;'...........'
    jmp msgs_c0_cf_done     ;ec8b  21 ec 84

msgs_00_or_gte_d0:
;Called if A = 0 or A >= 0xD0 (vw-car message)
;EP = 0x011d (pointer to Display Number in command packet)
    movw a, #0x0000         ;ec8e  e4 00 00
    movw a, #msgs_00_or_gte_d0_text ;ec91  e4 f1 a1     A = pointer to vw-car message
    clrc                    ;ec94  81
    addcw a                 ;ec95  23
    movw ix, a              ;ec96  e2
    movw ep, #0x012f        ;ec97  e7 01 2f
    call copy_11_ix_to_ep   ;ec9a  31 ec a1     Copy 11 bytes from @ix to @ep
    call make_fis_text      ;ec9d  31 ec ce
    ret                     ;eca0  20

copy_11_ix_to_ep:
;Copy 11 bytes from @ix to @ep
    mov a, @ix+0x00         ;eca1  06 00
    mov @ep, a              ;eca3  47       Copy byte 0
    incw ep                 ;eca4  c3
    mov a, @ix+0x01         ;eca5  06 01
    mov @ep, a              ;eca7  47       Copy byte 1
    incw ep                 ;eca8  c3
    mov a, @ix+0x02         ;eca9  06 02
    mov @ep, a              ;ecab  47       Copy byte 2
    incw ep                 ;ecac  c3
    mov a, @ix+0x03         ;ecad  06 03
    mov @ep, a              ;ecaf  47       Copy byte 3
    incw ep                 ;ecb0  c3
    mov a, @ix+0x04         ;ecb1  06 04
    mov @ep, a              ;ecb3  47       Copy byte 4
    incw ep                 ;ecb4  c3
    mov a, @ix+0x05         ;ecb5  06 05
    mov @ep, a              ;ecb7  47       Copy byte 5
    incw ep                 ;ecb8  c3
    mov a, @ix+0x06         ;ecb9  06 06
    mov @ep, a              ;ecbb  47       Copy byte 6
    incw ep                 ;ecbc  c3
    mov a, @ix+0x07         ;ecbd  06 07
    mov @ep, a              ;ecbf  47       Copy byte 7
    incw ep                 ;ecc0  c3
    mov a, @ix+0x08         ;ecc1  06 08
    mov @ep, a              ;ecc3  47       Copy byte 8
    incw ep                 ;ecc4  c3
    mov a, @ix+0x09         ;ecc5  06 09
    mov @ep, a              ;ecc7  47       Copy byte 9
    incw ep                 ;ecc8  c3
    mov a, @ix+0x0a         ;ecc9  06 0a
    mov @ep, a              ;eccb  47       Copy byte 10
    incw ep                 ;eccc  c3
    ret                     ;eccd  20


make_fis_text:
;Reads 11 bytes of ASCII display data from 0x012f-0x139.
;Writes 16 bytes of FIS display data to 0x00d7-0x00e6.
    movw ix, #0x00d7        ;ecce  e6 00 d7     IX = pointer to start of 16-byte FIS output buf
    movw ep, #0x012f        ;ecd1  e7 01 2f     EP = pointer to start of 11-byte ASCII input buf

    ;Copy 4 bytes from 0x012f-0x132 to 0x00d7-0x00da and mask for 7-bit ASCII
    mov r0, #0x04           ;ecd4  88 04
lab_ecd6:
    mov a, @ep              ;ecd6  07
    and a, #0x7f            ;ecd7  64 7f
    mov @ix+0x00, a         ;ecd9  46 00
    incw ix                 ;ecdb  c2
    incw ep                 ;ecdc  c3
    dec r0                  ;ecdd  d8
    bne lab_ecd6            ;ecde  fc f6

    ;Clear 4 bytes from 0x00db-0x00de
    movw ix, #0x00d7        ;ece0  e6 00 d7
    mov a, #0x00            ;ece3  04 00
    mov @ix+0x04, a         ;ece5  46 04
    mov @ix+0x05, a         ;ece7  46 05
    mov @ix+0x06, a         ;ece9  46 06
    mov @ix+0x07, a         ;eceb  46 07

    ;Copy 7 bytes from 0x0133-0x139 to 0x0df-0x0e5 and mask for 7-bit ASCII
    movw ix, #0x00d7+8      ;eced  e6 00 df
    movw ep, #0x0133        ;ecf0  e7 01 33
    mov r0, #0x07           ;ecf3  88 07
lab_ecf5:
    mov a, @ep              ;ecf5  07
    and a, #0x7f            ;ecf6  64 7f
    mov @ix+0x00, a         ;ecf8  46 00
    incw ix                 ;ecfa  c2
    incw ep                 ;ecfb  c3
    dec r0                  ;ecfc  d8
    bne lab_ecf5            ;ecfd  fc f6

    ;Clear 1 byte at 0x00e6
    movw ix, #0x00d7        ;ecff  e6 00 d7
    mov a, #0x00            ;ed02  04 00
    mov @ix+0x0f, a         ;ed04  46 0f

    movw ix, #0x00d7        ;ed06  e6 00 d7

    ;Decide if a period needs to be inserted
    mov a, 0x011c           ;ed09  60 01 1c     A = pictographs byte in M2S command packet
    and a, #0x40            ;ed0c  64 40        Mask of all except "period" pictograph bit
    bnz lab_ed13            ;ed0e  fc 03        Branch if "period" pictograph is set
    bbc 0x00a9:0, lab_ed27  ;ed10  b0 a9 14     Branch if "show period" flag is clear

lab_ed13:
    ;A period needs to be inserted.  Shift four characters to the right to
    ;make room for the period and then write the period.

    ;Copy 0x00e5 to 0x00e6
    mov a, @ix+0x0e         ;ed13  06 0e
    mov @ix+0x0f, a         ;ed15  46 0f
    ;Copy 0x00e4 to 0x00e5
    mov a, @ix+0x0d         ;ed17  06 0d
    mov @ix+0x0e, a         ;ed19  46 0e
    ;Copy 0x00e3 to 0x00e4
    mov a, @ix+0x0c         ;ed1b  06 0c
    mov @ix+0x0d, a         ;ed1d  46 0d
    ;Copy 0x00e2 to 0x00e3
    mov a, @ix+0x0b         ;ed1f  06 0b
    mov @ix+0x0c, a         ;ed21  46 0c
    ;Put period char at 0x00e3
    mov a, #'.              ;ed23  04 2e
    mov @ix+0x0b, a         ;ed25  46 0b

lab_ed27:
    bbc 0x00a9:1, lab_ed32  ;ed27  b1 a9 08     Branch if "mode or preset digits" flag is clear

    ;Copy byte from 0x00da to 0x00db
    mov a, @ix+0x03         ;ed2a  06 03
    mov @ix+0x04, a         ;ed2c  46 04

    ;Clear byte at 0x00da
    mov a, #0x00            ;ed2e  04 00
    mov @ix+0x03, a         ;ed30  46 03

lab_ed32:
    ret                     ;ed32  20


num_to_mhz:
;Return a FM frequency in BCD for the index number in A
;A=0x00 returns A=0x0879 (87.9 MHz)
;A=0xFF returns A=0x1389 (138.9 MHz)
    mov r3, a               ;ed33  4b
    mov r1, #0x79           ;ed34  89 79    R1, R2 = BCD 0x0879 (87.9 MHz)
    mov r2, #0x08           ;ed36  8a 08
    mov r4, #0x02           ;ed38  8c 02    R4 = Increment of BCD 0x02

lab_ed3a:
    mov a, r3               ;ed3a  0b
    decw a                  ;ed3b  d0
    cmp a, #0xff            ;ed3c  14 ff
    beq lab_ed4f            ;ed3e  fd 0f
    mov r3, a               ;ed40  4b
    mov a, r1               ;ed41  09
    mov a, r4               ;ed42  0c
    clrc                    ;ed43  81
    addc a                  ;ed44  22
    daa                     ;ed45  84
    mov r1, a               ;ed46  49
    mov a, r2               ;ed47  0a
    addc a, #0x00           ;ed48  24 00
    daa                     ;ed4a  84
    mov r2, a               ;ed4b  4a
    jmp lab_ed3a            ;ed4c  21 ed 3a
lab_ed4f:
    mov a, r2               ;ed4f  0a
    swap                    ;ed50  10
    mov a, r1               ;ed51  09
    ret                     ;ed52  20

num_to_khz:
;Return a AM frequency in BCD for the index number in A
;A=0x00 returns R2=0x05, R1=0x30 (530 kHz)
;A=0xFF returns R2=0x30, R1=0x80 (3080 kHz)
    mov r3, a               ;ed53  4b
    mov r1, #0x30           ;ed54  89 30    R1, R2 = BCD 0x0530 (530 KHz)
    mov r2, #0x05           ;ed56  8a 05
    mov r4, #0x10           ;ed58  8c 10    R4 = Increment of BCD 0x010
    jmp lab_ed3a            ;ed5a  21 ed 3a


bin_to_bcd:
    mov r5, a               ;ed5d  4d
    mov r6, #0x00           ;ed5e  8e 00  Low nibble: hundred's place, High nibble: thousand's place
    mov r7, #0x00           ;ed60  8f 00  Low nibble: one's place,     High nibble: ten's place
    mov a, r5               ;ed62  0d
lab_ed63:
    clrc                    ;ed63  81
    subc a, #100            ;ed64  34 64
    bnc lab_ed79            ;ed66  f8 11
    clrc                    ;ed68  81
    addc a, #100            ;ed69  24 64
lab_ed6b:
    clrc                    ;ed6b  81
    subc a, #10             ;ed6c  34 0a
    bnc lab_ed7d            ;ed6e  f8 0d
    clrc                    ;ed70  81
    addc a, #10             ;ed71  24 0a
    mov a, r7               ;ed73  0f
    clrc                    ;ed74  81
    addc a                  ;ed75  22
    daa                     ;ed76  84
    mov r7, a               ;ed77  4f
    ret                     ;ed78  20
lab_ed79:
    inc r6                  ;ed79  ce
    jmp lab_ed63            ;ed7a  21 ed 63
lab_ed7d:
    mov r5, a               ;ed7d  4d
    mov a, r7               ;ed7e  0f
    clrc                    ;ed7f  81
    addc a, #0x10           ;ed80  24 10
    daa                     ;ed82  84
    mov r7, a               ;ed83  4f
    mov a, r5               ;ed84  0d
    jmp lab_ed6b            ;ed85  21 ed 6b


hex_nib_high:
;Convert high nibble in A to an ASCII hex digit
;Returns ASCII digit A
    movw a, #0x00f0         ;ed88  e4 00 f0
    andw a                  ;ed8b  63
    clrc                    ;ed8c  81
    rolc a                  ;ed8d  02
    rolc a                  ;ed8e  02
    rolc a                  ;ed8f  02
    rolc a                  ;ed90  02
    rolc a                  ;ed91  02

hex_nib_low:
;Convert low nibble in A to an ASCII hex digit
;Returns ASCII digit in A
    movw a, #0x000f         ;ed92  e4 00 0f
    andw a                  ;ed95  63
    movw a, #alphanum       ;ed96  e4 ed 9d
    clrc                    ;ed99  81
    addcw a                 ;ed9a  23
    mov a, @a               ;ed9b  92
    ret                     ;ed9c  20

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
    movw a, ps              ;f1ac  70           Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;f1ad  e4 00 ff       R0=0x100, R1=0x101...
    andw a                  ;f1b0  63
    movw ps, a              ;f1b1  71

    call sub_f1f3           ;f1b2  31 f1 f3
    bbc 0x00ab:5, lab_f1d4  ;f1b5  b5 ab 1c
    bbc 0x00ab:0, lab_f1d4  ;f1b8  b0 ab 19
    clrb 0xab:5             ;f1bb  a5 ab
    mov a, #0x10            ;f1bd  04 10
    mov 0xca, a             ;f1bf  45 ca

lab_f1c1:
    mov a, #0x05            ;f1c1  04 05
    mov 0xcb, a             ;f1c3  45 cb
    mov a, #0x14            ;f1c5  04 14
    mov 0xc9, a             ;f1c7  45 c9

    mov a, #0x04            ;f1c9  04 04
    mov 0xc3, a             ;f1cb  45 c3        Set 0x00C3 = 0x04

lab_f1cd:
    call sub_f230           ;f1cd  31 f2 30
    call sub_f3b2           ;f1d0  31 f3 b2
    ret                     ;f1d3  20

lab_f1d4:
    bbc 0x00ab:4, lab_f1e3  ;f1d4  b4 ab 0c     Branch if "write to FIS only" flag is clear
    bbc 0x00ab:0, lab_f1e3  ;f1d7  b0 ab 09
    clrb 0xab:4             ;f1da  a4 ab        Clear "write to FIS only" flag
    mov a, #0x10            ;f1dc  04 10
    mov 0xca, a             ;f1de  45 ca
    jmp lab_f1c1            ;f1e0  21 f1 c1

lab_f1e3:
    mov a, 0xc9             ;f1e3  05 c9
    bne lab_f1ec            ;f1e5  fc 05
    setb 0xab:0             ;f1e7  a8 ab
    jmp lab_f1c1            ;f1e9  21 f1 c1

lab_f1ec:
    mov a, 0xcb             ;f1ec  05 cb
    bne lab_f1cd            ;f1ee  fc dd
    jmp lab_f1c1            ;f1f0  21 f1 c1

sub_f1f3:
    mov a, 0xc6             ;f1f3  05 c6
    cmp a, #0x04            ;f1f5  14 04
    bhs lab_f213            ;f1f7  f8 1a
    cmp a, #0x02            ;f1f9  14 02
    blo lab_f213            ;f1fb  f9 16

lab_f1fd:
    mov a, #0x14            ;f1fd  04 14
    mov 0xc9, a             ;f1ff  45 c9
    mov a, #0x00            ;f201  04 00
    mov 0xc6, a             ;f203  45 c6
    bbs 0x00ab:0, lab_f212  ;f205  b8 ab 0a
    setb 0xab:0             ;f208  a8 ab
    mov a, #0x00            ;f20a  04 00
    mov 0xca, a             ;f20c  45 ca

    mov a, #0x04            ;f20e  04 04
    mov 0xc3, a             ;f210  45 c3        Set 0x00C3 = 0x04

lab_f212:
    ret                     ;f212  20

lab_f213:
    mov a, 0xc6             ;f213  05 c6
    cmp a, #0x07            ;f215  14 07
    bhs lab_f220            ;f217  f8 07
    cmp a, #0x04            ;f219  14 04
    blo lab_f220            ;f21b  f9 03
    jmp lab_f1fd            ;f21d  21 f1 fd

lab_f220:
    mov a, 0xc6             ;f220  05 c6
    cmp a, #0x0a            ;f222  14 0a
    bhs lab_f212            ;f224  f8 ec
    cmp a, #0x07            ;f226  14 07
    blo lab_f212            ;f228  f9 e8
    mov 0xc6, #0x00         ;f22a  85 c6 00
    jmp lab_f212            ;f22d  21 f2 12

sub_f230:
    mov a, 0xc3             ;f230  05 c3        A = read byte at 0x00C3
    bne lab_f235            ;f232  fc 01

lab_f234:
    ret                     ;f234  20

lab_f235:
    cmp a, #0x02            ;f235  14 02        If A = 0x02, call sub_f267 and return
    bne lab_f23f            ;f237  fc 06
    call sub_f267           ;f239  31 f2 67
    jmp lab_f234            ;f23c  21 f2 34

lab_f23f:
    cmp a, #0x04            ;f23f  14 04        If A = 0x04, call ...
    bne lab_f249            ;f241  fc 06
    call sub_f281           ;f243  31 f2 81
    jmp lab_f234            ;f246  21 f2 34

lab_f249:
    cmp a, #0x06            ;f249  14 06
    bne lab_f253            ;f24b  fc 06
    call sub_f29d           ;f24d  31 f2 9d
    jmp lab_f234            ;f250  21 f2 34

lab_f253:
    cmp a, #0x08            ;f253  14 08
    bne lab_f25d            ;f255  fc 06
    call sub_f2c4           ;f257  31 f2 c4
    jmp lab_f234            ;f25a  21 f2 34

lab_f25d:
    cmp a, #0x0a            ;f25d  14 0a
    bne lab_f234            ;f25f  fc d3
    call sub_f2f4           ;f261  31 f2 f4
    jmp lab_f234            ;f264  21 f2 34

sub_f267:
;handle 0x00C3 = 0x02
    clrb pdr4:3             ;f267  a3 0e        ;/DISP_ENA_OUT = low

    movw a, #0x0007         ;f269  e4 00 07     ;Busy loop
lab_f26c:
    decw a                  ;f26c  d0
    bne lab_f26c            ;f26d  fc fd

    setb pdr4:3             ;f26f  ab 0e        ;/DISP_ENA_OUT = high

    movw a, #0x0020         ;f271  e4 00 20     ;Busy loop
lab_f274:
    decw a                  ;f274  d0
    bne lab_f274            ;f275  fc fd

    mov a, #0xf3            ;f277  04 f3
    call sub_f2ff           ;f279  31 f2 ff     ;Send 0xF3 out 3LB SPI bus

    mov a, #0x04            ;f27c  04 04
    mov 0xc3, a             ;f27e  45 c3        ;Set 0x00C3 = 0x04
    ret                     ;f280  20

sub_f281:
;handle 0x00C3 = 0x04
    mov a, 0xca             ;f281  05 ca
    bne lab_f29c            ;f283  fc 17

    mov a, #0x06            ;f285  04 06
    mov 0xc3, a             ;f287  45 c3        ;Set 0x00C3 = 0x06

    call build_fis_packet  ;f289  31 f3 0f
    mov 0xc2, #0x00         ;f28c  85 c2 00
    mov a, #0x03            ;f28f  04 03
    mov 0xc8, a             ;f291  45 c8
    mov a, 0xe7             ;f293  05 e7
    cmp a, #0x05            ;f295  14 05
    beq lab_f29c            ;f297  fd 03
    incw a                  ;f299  c0
    mov 0xe7, a             ;f29a  45 e7

lab_f29c:
    ret                     ;f29c  20

sub_f29d:
;handle 0x00C3 = 0x06
    bbs pdr4:7, lab_f2c3    ;f29d  bf 0e 23     Branch if DISP_ENA_IN = high
    mov a, 0xc8             ;f2a0  05 c8
    bne lab_f2c3            ;f2a2  fc 1f
    clrb pdr4:3             ;f2a4  a3 0e        /DISP_ENA_OUT = low

    movw a, #0x0007         ;f2a6  e4 00 07     Busy loop
lab_f2a9:
    decw a                  ;f2a9  d0
    bne lab_f2a9            ;f2aa  fc fd

    setb pdr4:3             ;f2ac  ab 0e        /DISP_ENA_OUT = high

    movw a, #0x0020         ;f2ae  e4 00 20     Busy loop
lab_f2b1:
    decw a                  ;f2b1  d0
    bne lab_f2b1            ;f2b2  fc fd

    call sub_f2fc           ;f2b4  31 f2 fc     Send byte at pointer in 0x00C0 out 3LB SPI

    mov a, #0x08            ;f2b7  04 08
    mov 0xc3, a             ;f2b9  45 c3        Set 0xc3 = 8

    movw a, 0xc0            ;f2bb  c5 c0        Increment pointer at 0x00C0
    incw a                  ;f2bd  c0
    movw 0xc0, a            ;f2be  d5 c0

    mov 0xc4, #0x00         ;f2c0  85 c4 00     Set 0x00c4 = 0

lab_f2c3:
    ret                     ;f2c3  20

sub_f2c4:
;handle 0x00C = 0x08
    mov a, 0xc4             ;f2c4  05 c4
    bne lab_f2f3            ;f2c6  fc 2b
    bbc pdr4:7, lab_f2f3    ;f2c8  b7 0e 28     Branch if DISP_ENA_IN = low
    mov a, #0x00            ;f2cb  04 00
    mov 0xe7, a             ;f2cd  45 e7
    movw a, #0x0000         ;f2cf  e4 00 00
    mov a, 0xc2             ;f2d2  05 c2
    mov a, #0xac            ;f2d4  04 ac
    clrc                    ;f2d6  81
    addc a                  ;f2d7  22
    mov a, @a               ;f2d8  92
    call sub_f2fc           ;f2d9  31 f2 fc     Send byte at pointer in 0x00C0 out 3LB SPI
    mov 0xc4, #0x00         ;f2dc  85 c4 00
    setb 0xab:1             ;f2df  a9 ab

    movw a, 0xc0            ;f2e1  c5 c0        Increment pointer at 0x00C0
    incw a                  ;f2e3  c0
    movw 0xc0, a            ;f2e4  d5 c0

    mov a, 0xc2             ;f2e6  05 c2
    incw a                  ;f2e8  c0
    mov 0xc2, a             ;f2e9  45 c2

    cmp a, #0x13            ;f2eb  14 13
    bne lab_f2f3            ;f2ed  fc 04

    mov a, #0x0a            ;f2ef  04 0a
    mov 0xc3, a             ;f2f1  45 c3        Set 0x00C3 = 0x0A

lab_f2f3:
    ret                     ;f2f3  20

sub_f2f4:
;handle 0x00C3 = 0x0A
    mov a, #0x00            ;f2f4  04 00
    mov 0xc3, a             ;f2f6  45 c3        ;Set 0x00C3 = 0
    mov 0xc6, #0x00         ;f2f8  85 c6 00
    ret                     ;f2fb  20

sub_f2fc:
;Read a byte from the pointer in 0x00C0 and send it out 3LB bus SPI
    movw a, 0xc0            ;f2fc  c5 c0
    mov a, @a               ;f2fe  92

sub_f2ff:
;Send byte in A out 3LB bus SPI
    mov sdr2, a             ;f2ff  45 1f
    clrb smr2:7             ;f301  a7 1e
    nop                     ;f303  00
    nop                     ;f304  00
    nop                     ;f305  00
    setb smr2:0             ;f306  a8 1e
    nop                     ;f308  00
    nop                     ;f309  00
    nop                     ;f30a  00
lab_f30b:
    bbc smr2:7, lab_f30b    ;f30b  b7 1e fd
    ret                     ;f30e  20


build_fis_packet:
;Reads 16-byte FIS display buffer in 0x00d7-0x00e6.
;Stores complete "Navi protocol" FIS packet in 0x00ac-0x00bf.
;Sets pointer at 0x00c0 to start of packet (0x00ac).
;
    ;0x00d7 -> 0x00af
    mov a, 0xd7             ;f30f  05 d7    A = value from 0x00d7
    bnz lab_f315            ;f311  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f313  04 20    A = space character
lab_f315:
    mov 0xaf, a             ;f315  45 af    Save A in 0x00af

    ;0x00d8 -> 0x00b0
    mov a, 0xd8             ;f317  05 d8    A = value from 0x00d8
    bnz lab_f31d            ;f319  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f31b  04 20    A = space character
lab_f31d:
    mov 0xb0, a             ;f31d  45 b0    Save A in 0x00b0

    ;0x00d9 -> 0x00b1
    mov a, 0xd9             ;f31f  05 d9    A = value from 0x00d9
    bnz lab_f325            ;f321  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f323  04 20    A = space character
lab_f325:
    mov 0xb1, a             ;f325  45 b1    Save A in 0x00b1

    ;0x00da -> 0x00b2
    mov a, 0xda             ;f327  05 da    A = value from 0x00da
    bnz lab_f32d            ;f329  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f32b  04 20    A = space character
lab_f32d:
    mov 0xb2, a             ;f32d  45 b2    Save A in 0x00b2

    ;0x00db -> 0x00b3
    mov a, 0xdb             ;f32f  05 db    A = value from 0x00db
    bnz lab_f335            ;f331  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f333  04 20    A = space character
lab_f335:
    mov 0xb3, a             ;f335  45 b3    Save A in 0x00b3

    ;0x00dc -> 0x00b4
    mov a, 0xdc             ;f337  05 dc    A = value at 0x00dc
    bnz lab_f33d            ;f339  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f33b  04 20    A = space character
lab_f33d:
    mov 0xb4, a             ;f33d  45 b4    Save A in 0x00b4

    ;0x00dd -> 0x00b5
    mov a, 0xdd             ;f33f  05 dd    A = value at 0x00dd
    bnz lab_f345            ;f341  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f343  04 20    A = space character
lab_f345:
    mov 0xb5, a             ;f345  45 b5    Save A in 0x00b5

    ;0x00de -> 0x00b6
    mov a, 0xde             ;f347  05 de    A = value at 0x00de
    bnz lab_f34d            ;f349  fc 02    Skip space change if A != 0
    mov a, #0x20            ;f34b  04 20    A = space character
lab_f34d:
    mov 0xb6, a             ;f34d  45 b6    Save A in 0x00b6

    ;0x00df -> 0x00b7
    mov a, 0xdf             ;f34f  05 df    A = value at 0x00df
    bnz lab_f355            ;f351  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f353  04 1c    A = 0x1c
lab_f355:
    mov 0xb7, a             ;f355  45 b7    Save A in 0x00b7

    ;0x00e0 -> 0x00b8
    mov a, 0xe0             ;f357  05 e0    A = value at 0x00e0
    bnz lab_f35d            ;f359  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f35b  04 1c    A = 0x1c
lab_f35d:
    mov 0xb8, a             ;f35d  45 b8    Save A in 0x00b8

    ;0x00e1 -> 0x00b9
    mov a, 0xe1             ;f35f  05 e1    A = value at 0x00e1
    bnz lab_f365            ;f361  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f363  04 1c    A = 0x1c
lab_f365:
    mov 0xb9, a             ;f365  45 b9    Save A in 0x00b9

    ;0x00e2 -> 0x00ba
    mov a, 0xe2             ;f367  05 e2    A = value at 0x00e2
    bnz lab_f36d            ;f369  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f36b  04 1c    A = 0x1c
lab_f36d:
    mov 0xba, a             ;f36d  45 ba    Save A in 0x00b9

    ;0x00e3 -> 0x00bb
    mov a, 0xe3             ;f36f  05 e3    A = value at 0x00e3
    bnz lab_f375            ;f371  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f373  04 1c    A = 0x1c
lab_f375:
    mov 0xbb, a             ;f375  45 bb    Save A in 0x00bb

    ;0x00e4 -> 0x00bc
    mov a, 0xe4             ;f377  05 e4    A = value at 0x00e4
    bnz lab_f37d            ;f379  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f37b  04 1c    A = 0x1c
lab_f37d:
    mov 0xbc, a             ;f37d  45 bc    Save A in 0x00bc

    ;0x00e5 -> 0x00bd
    mov a, 0xe5             ;f37f  05 e5    A = value at 0x00e5
    bnz lab_f385            ;f381  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f383  04 1c    A = 0x1c
lab_f385:
    mov 0xbd, a             ;f385  45 bd    Save A in 0x00bd

    ;0x00e6 -> 0x00be
    mov a, 0xe6             ;f387  05 e6    A = value at 0x00e6
    bnz lab_f38d            ;f389  fc 02    Skip 0x1c change if A != 0
    mov a, #0x1c            ;f38b  04 1c    A = 0x1c
lab_f38d:
    mov 0xbe, a             ;f38d  45 be    Save A in 0x00be

    ;Prepend packet header

    mov a, #0x81            ;f38f  04 81    0x00AC = Navi packet byte 0 = 0x81
    mov 0xac, a             ;f391  45 ac

    mov a, #0x12            ;f393  04 12    0x00AD = Navi packet byte 1 = Number of bytes (0x12)
    mov 0xad, a             ;f395  45 ad

    mov a, #0xf0            ;f397  04 f0
    mov 0xae, a             ;f399  45 ae    0x00AE = Navi packet byte 2 = 0xF0

    ;Append packet checksum

    mov r0, #0x12           ;f39b  88 12     R0 = 0x12 bytes to count down
    movw ix, #0x00ac        ;f39d  e6 00 ac  IX = pointer to start of Navi packet buffer

    mov a, @ix+0x00         ;f3a0  06 00     A = read byte in Navi packet buffer
lab_f3a2:
    incw ix                 ;f3a2  c2        Increment pointer
    mov a, @ix+0x00         ;f3a3  06 00     A = read next byte in buffer, T = previous byte
    xor a                   ;f3a5  52        A = A ^ T
    dec r0                  ;f3a6  d8
    bne lab_f3a2            ;f3a7  fc f9     Loop until 0x12 bytes are done

    decw a                  ;f3a9  d0
    mov 0xac+19, a          ;f3aa  45 bf     Store checksum in last byte of packet buffer

    movw a, #0x00ac         ;f3ac  e4 00 ac
    movw 0xc0, a            ;f3af  d5 c0     0x00C0 = pointer to start of Navi packet buffer
    ret                     ;f3b1  20


sub_f3b2:
    bbc 0x00ab:1, lab_f3be  ;f3b2  b1 ab 09
    clrb 0xab:1             ;f3b5  a1 ab
    setb 0xab:2             ;f3b7  aa ab
    mov a, #0x0a            ;f3b9  04 0a
    mov 0xc7, a             ;f3bb  45 c7

lab_f3bd:
    ret                     ;f3bd  20

lab_f3be:
    mov a, 0xc7             ;f3be  05 c7
    bne lab_f3bd            ;f3c0  fc fb
    clrb 0xab:2             ;f3c2  a2 ab
    jmp lab_f3bd            ;f3c4  21 f3 bd

sub_f3c7:
    bbc 0x009b:3, lab_f3e4  ;f3c7  b3 9b 1a

lab_f3ca:
    clrb 0x9b:3             ;f3ca  a3 9b
    setb 0x9b:2             ;f3cc  aa 9b
    mov a, #0x0a            ;f3ce  04 0a
    mov 0x9d, a             ;f3d0  45 9d
    call read_bose          ;f3d2  31 f3 ef     Read BOSE_SW1, BOSE_SW1 and set bits in 0x9e
    call read_0xab_bit2     ;f3d5  31 f4 13     Read 0xab:2 and set a bit in 0x9e
    call read_0xe7          ;f3d8  31 f4 1f     Read 0xe7 and set a bit in 0x9e
    call read_diag          ;f3db  31 f4 2e     Read DIAG_SW1, DIAG_SW2 and set bits in 0x9e
    call read_0xcd_bit0     ;f3de  31 f4 3f     Read 0xcd:0 and set a bit in 0x9e
    setb 0x9b:0             ;f3e1  a8 9b

lab_f3e3:
    ret                     ;f3e3  20

lab_f3e4:
    bbc 0x009b:2, lab_f3ca  ;f3e4  b2 9b e3
    bbc 0x00cd:3, lab_f3e3  ;f3e7  b3 cd f9
    clrb 0xcd:3             ;f3ea  a3 cd
    jmp lab_f3ca            ;f3ec  21 f3 ca


read_bose:
;Read BOSE_SW1, BOSE_SW2 and set two bits in 0x9e
;
;BOSE_SW2 = 1, BOSE_SW1 = 0 -> 0x9e = 0bXXXXXX01
;BOSE_SW2 = 0, BOSE_SW1 = 1 -> 0x9e = 0bXXXXXX10
;Anything else              -> 0x9e = 0bXXXXXX00
;
    mov a, 0x9e             ;f3ef  05 9e    Clear bits in 0x9e to receive BOSE switches
    and a, #0b11111100      ;f3f1  64 fc
    mov 0x9e, a             ;f3f3  45 9e

    mov a, pdr0             ;f3f5  05 00    Read port with BOSE switches
    and a, #0b11000000      ;f3f7  64 c0    Mask off all except BOSE_SW2 (bit 7) and BOSE_SW1 (bit 6)
    cmp a, #0b10000000      ;f3f9  14 80    Compare with BOSE_SW2=1, BOSE_SW1=0
    bne read_bose_case_2    ;f3fb  fc 08

    ;BOSE_SW2 = 1, BOSE_SW1 = 0
    mov a, #0b00000001      ;f3fd  04 01

read_bose_done:
    mov a, 0x9e             ;f3ff  05 9e    Set bits in 0x9e with new BOSE switch status
    orw a                   ;f401  73
    mov 0x9e, a             ;f402  45 9e
    ret                     ;f404  20

read_bose_case_2:
    cmp a, #0b01000000      ;f405  14 40    Compare with BOSE_SW2=0, BOSE_SW1=1
    bne read_bose_case_else ;f407  fc 05

    ;BOSE_SW2 = 0, BOSE_SW1 = 1
    mov a, #0b00000010      ;f409  04 02
    jmp read_bose_done      ;f40b  21 f3 ff

read_bose_case_else:
    ;Any other combination of BOSE_SW2 and BOSE_SW1
    mov a, #0               ;f40e  04 00
    jmp read_bose_done      ;f410  21 f3 ff


read_0xab_bit2:
;Read 0xab:2 and put it in 0x9e:3
;
;0xab:2 = 0 -> 0bXXXX0XXX
;0xab:2 = 1 -> 0bXXXX1XXX
;
    mov a, 0x9e             ;f413  05 9e
    and a, #0b11110111      ;f415  64 f7
    mov 0x9e, a             ;f417  45 9e
    bbc 0x00ab:2, read_0xab_bit2_done  ;f419  b2 ab 02
    setb 0x9e:3             ;f41c  ab 9e
read_0xab_bit2_done:
    ret                     ;f41e  20


read_0xe7:
;Read 0xe7 and set 0x9e:4 if 0xe7 = 5
;
;0xe5  = 5 -> 0bXXX0XXXX
;0xe5 != 5 -> 0bXXX1XXXX
;
    mov a, 0x9e             ;f41f  05 9e
    and a, #0b11101111      ;f421  64 ef
    mov 0x9e, a             ;f423  45 9e

    mov a, 0xe7             ;f425  05 e7
    cmp a, #0x05            ;f427  14 05
    bne read_0xe7_done      ;f429  fc 02

    setb 0x9e:4             ;f42b  ac 9e
read_0xe7_done:
    ret                     ;f42d  20


read_diag:
;Read DIAG_SW1, DIAG_SW2 and set two bits in 0x9e
;
;DIAG_SW2 = 0, DIAG_SW1 = 0 -> 0x9e = 0b00XXXXXX
;DIAG_SW2 = 0, DIAG_SW1 = 1 -> 0x9e = 0b01XXXXXX
;DIAG_SW2 = 1, DIAG_SW1 = 0 -> 0x9e = 0b10XXXXXX
;DIAG_SW2 = 1, DIAG_SW1 = 1 -> 0x9e = 0b11XXXXXX
;
    mov a, 0x9e             ;f42e  05 9e        Clear bits in 0x9e to receive DIAG switches
    and a, #0b00111111      ;f430  64 3f
    mov 0x9e, a             ;f432  45 9e

    bbc pdr0:4, lab_f439    ;f434  b4 00 02     Branch if DIAG_SW1 = low

    ;DIAG_SW1 = high
    setb 0x9e:6             ;f437  ae 9e

lab_f439:
    bbc pdr0:5, read_diag_done ;f439  b5 00 02  Branch if DIAG_SW2 = low

    ;DIAG_SW2 = high
    setb 0x9e:7             ;f43c  af 9e

read_diag_done:
    ret                     ;f43e  20


read_0xcd_bit0:
;Read 0xcd:0 and put it in 0x9e:5
;TODO what is 0xcd:0?
;
    mov a, 0x9e             ;f43f  05 9e
    and a, #0b11011111      ;f441  64 df
    mov 0x9e, a             ;f443  45 9e

    bbc 0x00cd:0, read_0xcd_bit0_done  ;f445  b0 cd 02

    setb 0x9e:5             ;f448  ad 9e
read_0xcd_bit0_done:
    ret                     ;f44a  20


sub_f44b:
    movw a, tchr            ;f44b  c5 19
    movw 0x013f, a          ;f44d  d4 01 3f
    mov a, 0x013c           ;f450  60 01 3c
    bne lab_f45b            ;f453  fc 06
    call sub_f46b           ;f455  31 f4 6b

lab_f458:
    clrb eic2:7             ;f458  a7 25
    ret                     ;f45a  20

lab_f45b:
    cmp a, #0x01            ;f45b  14 01
    bne lab_f465            ;f45d  fc 06
    call sub_f483           ;f45f  31 f4 83
    jmp lab_f458            ;f462  21 f4 58

lab_f465:
    call sub_f4a6           ;f465  31 f4 a6
    jmp lab_f458            ;f468  21 f4 58

sub_f46b:
    bbc pdr6:3, lab_f47c    ;f46b  b3 11 0e
    movw a, 0x013f          ;f46e  c4 01 3f
    movw 0x013d, a          ;f471  d4 01 3d
    mov a, #0x01            ;f474  04 01
    setb eic2:5             ;f476  ad 25

lab_f478:
    mov 0x013c, a           ;f478  61 01 3c
    ret                     ;f47b  20

lab_f47c:
    mov a, #0x00            ;f47c  04 00
    clrb eic2:5             ;f47e  a5 25
    jmp lab_f478            ;f480  21 f4 78

sub_f483:
    bbs pdr6:3, lab_f49f    ;f483  bb 11 19
    clrc                    ;f486  81
    movw a, 0x013f          ;f487  c4 01 3f
    movw a, 0x013d          ;f48a  c4 01 3d
    subcw a                 ;f48d  33
    movw 0x0141, a          ;f48e  d4 01 41
    movw a, 0x013f          ;f491  c4 01 3f
    movw 0x013d, a          ;f494  d4 01 3d
    mov a, #0x02            ;f497  04 02
    clrb eic2:5             ;f499  a5 25

lab_f49b:
    mov 0x013c, a           ;f49b  61 01 3c
    ret                     ;f49e  20

lab_f49f:
    mov a, #0x00            ;f49f  04 00
    clrb eic2:5             ;f4a1  a5 25
    jmp lab_f49b            ;f4a3  21 f4 9b

sub_f4a6:
    bbc pdr6:3, lab_f4c6    ;f4a6  b3 11 1d
    clrc                    ;f4a9  81
    movw a, 0x013f          ;f4aa  c4 01 3f
    movw a, 0x013d          ;f4ad  c4 01 3d
    subcw a                 ;f4b0  33
    movw 0x0143, a          ;f4b1  d4 01 43
    movw a, 0x013f          ;f4b4  c4 01 3f
    movw 0x013d, a          ;f4b7  d4 01 3d
    setb 0xd2:0             ;f4ba  a8 d2
    setb 0xd2:4             ;f4bc  ac d2
    mov a, #0x01            ;f4be  04 01
    setb eic2:5             ;f4c0  ad 25

lab_f4c2:
    mov 0x013c, a           ;f4c2  61 01 3c
    ret                     ;f4c5  20

lab_f4c6:
    mov a, #0x00            ;f4c6  04 00
    clrb eic2:5             ;f4c8  a5 25
    jmp lab_f4c2            ;f4ca  21 f4 c2

sub_f4cd:
    bbs 0x00d2:0, lab_f4e6  ;f4cd  b8 d2 16
    bbc pdr6:3, lab_f4e1    ;f4d0  b3 11 0e
    mov a, #0x64            ;f4d3  04 64

lab_f4d5:
    mov 0x013b, a           ;f4d5  61 01 3b

lab_f4d8:
    mov a, 0x0148           ;f4d8  60 01 48
    and a, #0xfe            ;f4db  64 fe
    mov 0x0148, a           ;f4dd  61 01 48
    ret                     ;f4e0  20

lab_f4e1:
    mov a, #0x00            ;f4e1  04 00
    jmp lab_f4d5            ;f4e3  21 f4 d5

lab_f4e6:
    clrb 0xd2:0             ;f4e6  a0 d2
    movw a, 0x0141          ;f4e8  c4 01 41
    movw 0xd4, a            ;f4eb  d5 d4
    movw a, 0x0143          ;f4ed  c4 01 43
    movw a, 0xd4            ;f4f0  c5 d4
    clrc                    ;f4f2  81
    addcw a                 ;f4f3  23
    bhs lab_f4f9            ;f4f4  f8 03
    movw a, #0xffff         ;f4f6  e4 ff ff

lab_f4f9:
    movw a, #0xff00         ;f4f9  e4 ff 00
    andw a                  ;f4fc  63
    swap                    ;f4fd  10
    mov r0, a               ;f4fe  48
    movw a, 0xd4            ;f4ff  c5 d4
    movw a, #0xff00         ;f501  e4 ff 00
    andw a                  ;f504  63
    swap                    ;f505  10
    call sub_f644           ;f506  31 f6 44
    mov a, r1               ;f509  09
    cmp a, #0x64            ;f50a  14 64
    blo lab_f510            ;f50c  f9 02
    mov a, #0x64            ;f50e  04 64

lab_f510:
    mov 0x013b, a           ;f510  61 01 3b
    jmp lab_f4d8            ;f513  21 f4 d8


sub_f516:
;TODO unknown but related to illumination control
    bbc 0x009c:1, lab_f520  ;f516  b1 9c 07     Branch if "play dead" flag is clear

    ;Playing dead
    clrb 0x9c:3             ;f519  a3 9c
lab_f51b:
    clrb pdr3:6             ;f51b  a6 0c        ILL_CONT1 = low
    clrb pdr3:7             ;f51d  a7 0c        ILL_CONT2 = low
    ret                     ;f51f  20

lab_f520:
    bbc 0x009c:3, lab_f51b  ;f520  b3 9c f8
    bbc 0x00d2:4, lab_f532  ;f523  b4 d2 0c
lab_f526:
    mov a, #0x14            ;f526  04 14
    mov 0x0145, a           ;f528  61 01 45
    clrb 0xd2:4             ;f52b  a4 d2
    setb pdr3:6             ;f52d  ae 0c        ILL_CONT1 = high
    clrb pdr3:7             ;f52f  a7 0c        ILL_CONT2 = low
lab_f531:
    ret                     ;f531  20
lab_f532:
    mov a, 0x0145           ;f532  60 01 45
    bne lab_f531            ;f535  fc fa
    bbs pdr6:3, lab_f526    ;f537  bb 11 ec
    clrb pdr3:6             ;f53a  a6 0c        ILL_CONT1 = low
    setb pdr3:7             ;f53c  af 0c        ILL_CONT2 = high
    jmp lab_f531            ;f53e  21 f5 31


sub_f541:
    movw a, ps              ;f541  70           Clear RP (register bank pointer) in PS
    movw a, #0x00ff         ;f542  e4 00 ff       R0=0x100, R1=0x101...
    andw a                  ;f545  63
    movw ps, a              ;f546  71

    call sub_f516           ;f547  31 f5 16     TODO related to illumination control
    call sub_f571           ;f54a  31 f5 71
    mov a, 0x0148           ;f54d  60 01 48
    rorc a                  ;f550  03
    bhs lab_f557            ;f551  f8 04
    call sub_f4cd           ;f553  31 f4 cd

lab_f556:
    ret                     ;f556  20

lab_f557:
    rorc a                  ;f557  03
    bhs lab_f556            ;f558  f8 fc
    call sub_f59f           ;f55a  31 f5 9f
    call sub_f5c3           ;f55d  31 f5 c3
    call sub_f5ec           ;f560  31 f5 ec
    call sub_f617           ;f563  31 f6 17
    mov a, 0x0148           ;f566  60 01 48
    and a, #0xfd            ;f569  64 fd
    mov 0x0148, a           ;f56b  61 01 48
    jmp lab_f556            ;f56e  21 f5 56

sub_f571:
    mov a, 0x0147           ;f571  60 01 47
    bne lab_f57e            ;f574  fc 08
    mov a, #0x01            ;f576  04 01
    mov 0x0147, a           ;f578  61 01 47
    mov 0x0148, a           ;f57b  61 01 48

lab_f57e:
    bbc 0x00d2:3, lab_f592  ;f57e  b3 d2 11
    mov a, 0x0147           ;f581  60 01 47
    clrc                    ;f584  81
    rolc a                  ;f585  02
    cmp a, #0x04            ;f586  14 04
    blo lab_f58c            ;f588  f9 02
    mov a, #0x01            ;f58a  04 01

lab_f58c:
    mov 0x0147, a           ;f58c  61 01 47
    mov 0x0148, a           ;f58f  61 01 48

lab_f592:
    bbs 0x00d2:2, lab_f59e  ;f592  ba d2 09
    setb 0xd2:2             ;f595  aa d2
    clrb 0xd2:3             ;f597  a3 d2
    mov a, #0x05            ;f599  04 05
    mov 0x0149, a           ;f59b  61 01 49

lab_f59e:
    ret                     ;f59e  20

sub_f59f:
    mov adc2, #0x01         ;f59f  85 21 01
    mov adc1, #0x61         ;f5a2  85 20 61

lab_f5a5:
    bbc adc1:3, lab_f5a5    ;f5a5  b3 20 fd
    mov a, adcd             ;f5a8  05 22
    mov r0, a               ;f5aa  48
    mov adc1, #0x21         ;f5ab  85 20 21

lab_f5ae:
    bbc adc1:3, lab_f5ae    ;f5ae  b3 20 fd
    mov a, adcd             ;f5b1  05 22
    call sub_f644           ;f5b3  31 f6 44
    call sub_f66b           ;f5b6  31 f6 6b
    mov a, 0x0146           ;f5b9  60 01 46
    and a, #0xfc            ;f5bc  64 fc
    or a, r1                ;f5be  79
    mov 0x0146, a           ;f5bf  61 01 46
    ret                     ;f5c2  20

sub_f5c3:
    mov adc2, #0x01         ;f5c3  85 21 01
    mov adc1, #0x61         ;f5c6  85 20 61

lab_f5c9:
    bbc adc1:3, lab_f5c9    ;f5c9  b3 20 fd
    mov a, adcd             ;f5cc  05 22
    mov r0, a               ;f5ce  48
    mov adc1, #0x31         ;f5cf  85 20 31

lab_f5d2:
    bbc adc1:3, lab_f5d2    ;f5d2  b3 20 fd
    mov a, adcd             ;f5d5  05 22
    call sub_f644           ;f5d7  31 f6 44
    call sub_f66b           ;f5da  31 f6 6b
    clrc                    ;f5dd  81
    mov a, r1               ;f5de  09
    rolc a                  ;f5df  02
    rolc a                  ;f5e0  02
    mov r1, a               ;f5e1  49
    mov a, 0x0146           ;f5e2  60 01 46
    and a, #0xf3            ;f5e5  64 f3
    or a, r1                ;f5e7  79
    mov 0x0146, a           ;f5e8  61 01 46
    ret                     ;f5eb  20

sub_f5ec:
    mov adc2, #0x01         ;f5ec  85 21 01
    mov adc1, #0x61         ;f5ef  85 20 61

lab_f5f2:
    bbc adc1:3, lab_f5f2    ;f5f2  b3 20 fd
    mov a, adcd             ;f5f5  05 22
    mov r0, a               ;f5f7  48
    mov adc1, #0x41         ;f5f8  85 20 41

lab_f5fb:
    bbc adc1:3, lab_f5fb    ;f5fb  b3 20 fd
    mov a, adcd             ;f5fe  05 22
    call sub_f644           ;f600  31 f6 44
    call sub_f66b           ;f603  31 f6 6b
    clrc                    ;f606  81
    mov a, r1               ;f607  09
    rolc a                  ;f608  02
    rolc a                  ;f609  02
    rolc a                  ;f60a  02
    rolc a                  ;f60b  02
    mov r1, a               ;f60c  49
    mov a, 0x0146           ;f60d  60 01 46
    and a, #0xcf            ;f610  64 cf
    or a, r1                ;f612  79
    mov 0x0146, a           ;f613  61 01 46
    ret                     ;f616  20

sub_f617:
    mov adc2, #0x01         ;f617  85 21 01
    mov adc1, #0x61         ;f61a  85 20 61

lab_f61d:
    bbc adc1:3, lab_f61d    ;f61d  b3 20 fd
    mov a, adcd             ;f620  05 22
    mov r0, a               ;f622  48
    mov adc1, #0x51         ;f623  85 20 51

lab_f626:
    bbc adc1:3, lab_f626    ;f626  b3 20 fd
    mov a, adcd             ;f629  05 22
    call sub_f644           ;f62b  31 f6 44
    call sub_f66b           ;f62e  31 f6 6b
    clrc                    ;f631  81
    mov a, r1               ;f632  09
    rolc a                  ;f633  02
    rolc a                  ;f634  02
    rolc a                  ;f635  02
    rolc a                  ;f636  02
    rolc a                  ;f637  02
    rolc a                  ;f638  02
    mov r1, a               ;f639  49
    mov a, 0x0146           ;f63a  60 01 46
    and a, #0x3f            ;f63d  64 3f
    or a, r1                ;f63f  79
    mov 0x0146, a           ;f640  61 01 46
    ret                     ;f643  20

sub_f644:
    mov r2, a               ;f644  4a
    mov r1, #0x00           ;f645  89 00
    mov a, r0               ;f647  08
    beq lab_f657            ;f648  fd 0d
    mov a, r2               ;f64a  0a
    beq lab_f659            ;f64b  fd 0c
    clrc                    ;f64d  81
    subc a, r0              ;f64e  38
    blo lab_f65a            ;f64f  f9 09
    mov r1, #0x64           ;f651  89 64
    clrc                    ;f653  81
    subc a, r0              ;f654  38
    blo lab_f65a            ;f655  f9 03

lab_f657:
    mov r1, #0xc8           ;f657  89 c8

lab_f659:
    ret                     ;f659  20

lab_f65a:
    clrc                    ;f65a  81
    addc a, r0              ;f65b  28
    mov a, #0x64            ;f65c  04 64
    mulu a                  ;f65e  01
    movw 0xd4, a            ;f65f  d5 d4
    movw a, 0xd4            ;f661  c5 d4
    mov a, r0               ;f663  08
    divu a                  ;f664  11
    clrc                    ;f665  81
    addc a, r1              ;f666  29
    mov r1, a               ;f667  49
    jmp lab_f659            ;f668  21 f6 59

sub_f66b:
    mov a, r1               ;f66b  09
    cmp a, #0x28            ;f66c  14 28
    bhs lab_f673            ;f66e  f8 03
    mov r1, #0x02           ;f670  89 02

lab_f672:
    ret                     ;f672  20

lab_f673:
    cmp a, #0x62            ;f673  14 62
    bhs lab_f67c            ;f675  f8 05
    mov r1, #0x01           ;f677  89 01
    jmp lab_f672            ;f679  21 f6 72

lab_f67c:
    cmp a, #0x79            ;f67c  14 79
    bhs lab_f685            ;f67e  f8 05
    mov r1, #0x03           ;f680  89 03
    jmp lab_f672            ;f682  21 f6 72

lab_f685:
    cmp a, #0x86            ;f685  14 86
    bhs lab_f68e            ;f687  f8 05
    mov r1, #0x00           ;f689  89 00
    jmp lab_f672            ;f68b  21 f6 72

lab_f68e:
    mov r1, #0x02           ;f68e  89 02
    jmp lab_f672            ;f690  21 f6 72

sub_f693:
    mov a, 0xcc             ;f693  05 cc
    bne lab_f6a5            ;f695  fc 0e
    mov 0xcc, #0x01         ;f697  85 cc 01
    setb eic2:1             ;f69a  a9 25
    clrb cntr:3             ;f69c  a3 12
    mov comr, #0x96         ;f69e  85 13 96
    mov cntr, #0x19         ;f6a1  85 12 19
    ret                     ;f6a4  20

lab_f6a5:
    cmp a, #0x01            ;f6a5  14 01
    bne lab_f6b7            ;f6a7  fc 0e
    mov 0xcc, #0x02         ;f6a9  85 cc 02
    clrb eic2:1             ;f6ac  a1 25
    clrb cntr:3             ;f6ae  a3 12
    mov comr, #0x64         ;f6b0  85 13 64
    mov cntr, #0x19         ;f6b3  85 12 19
    ret                     ;f6b6  20

lab_f6b7:
    setb 0xcd:5             ;f6b7  ad cd
    setb 0xce:0             ;f6b9  a8 ce
    mov cntr, #0x10         ;f6bb  85 12 10
    clrb eic2:0             ;f6be  a0 25
    ret                     ;f6c0  20

sub_f6c1:
    mov a, 0xcc             ;f6c1  05 cc
    cmp a, #0x01            ;f6c3  14 01
    bne lab_f6d1            ;f6c5  fc 0a
    setb 0xcd:5             ;f6c7  ad cd
    setb 0xce:0             ;f6c9  a8 ce
    mov cntr, #0x10         ;f6cb  85 12 10
    clrb eic2:0             ;f6ce  a0 25
    ret                     ;f6d0  20

lab_f6d1:
    cmp a, #0x02            ;f6d1  14 02
    bne lab_f6de            ;f6d3  fc 09
    setb 0xcd:5             ;f6d5  ad cd
    clrb 0xce:0             ;f6d7  a0 ce
    mov cntr, #0x10         ;f6d9  85 12 10
    clrb eic2:0             ;f6dc  a0 25

lab_f6de:
    ret                     ;f6de  20


sub_f6df:
;TODO seems ADC related
    mov a, 0xd1             ;f6df  05 d1
    bne lab_f711            ;f6e1  fc 2e
    bbc 0x00cd:7, lab_f707  ;f6e3  b7 cd 21

lab_f6e6:
    mov 0xcf, #0x19         ;f6e6  85 cf 19
    clrb 0xcd:7             ;f6e9  a7 cd
    setb 0xcd:6             ;f6eb  ae cd
    mov adc2, #0x01         ;f6ed  85 21 01
    mov adc1, #0x71         ;f6f0  85 20 71

lab_f6f3:
    bbc adc1:3, lab_f6f3    ;f6f3  b3 20 fd
    mov a, adcd             ;f6f6  05 22
    cmp a, #0x0d            ;f6f8  14 0d
    blo lab_f70d            ;f6fa  f9 11
    setb 0xcd:1             ;f6fc  a9 cd
    clrb 0xcd:4             ;f6fe  a4 cd

lab_f700:
    call sub_f749           ;f700  31 f7 49
    call sub_f72d           ;f703  31 f7 2d
    ret                     ;f706  20

lab_f707:
    bbc 0x00cd:6, lab_f6e6  ;f707  b6 cd dc
    jmp lab_f700            ;f70a  21 f7 00

lab_f70d:
    cmp a, #0x02            ;f70d  14 02
    bhs lab_f718            ;f70f  f8 07

lab_f711:
    setb 0xcd:2             ;f711  aa cd
    clrb 0xcd:4             ;f713  a4 cd
    jmp lab_f700            ;f715  21 f7 00

lab_f718:
    bbs 0x00cd:4, lab_f700  ;f718  bc cd e5
    mov 0xcc, #0x00         ;f71b  85 cc 00
    clrb 0xcd:5             ;f71e  a5 cd
    clrb eic2:1             ;f720  a1 25
    clrb cntr:2             ;f722  a2 12
    clrb eic2:3             ;f724  a3 25
    setb 0xcd:4             ;f726  ac cd
    setb eic2:0             ;f728  a8 25
    jmp lab_f700            ;f72a  21 f7 00

sub_f72d:
    bbc 0x00cd:1, lab_f73a  ;f72d  b1 cd 0a
    clrb 0xcd:1             ;f730  a1 cd
    bbs 0x00cd:0, lab_f739  ;f732  b8 cd 04
    setb 0xcd:0             ;f735  a8 cd
    setb 0xcd:3             ;f737  ab cd

lab_f739:
    ret                     ;f739  20

lab_f73a:
    bbc 0x00cd:2, lab_f739  ;f73a  b2 cd fc
    clrb 0xcd:2             ;f73d  a2 cd
    bbc 0x00cd:0, lab_f739  ;f73f  b0 cd f7
    clrb 0xcd:0             ;f742  a0 cd
    setb 0xcd:3             ;f744  ab cd
    jmp lab_f739            ;f746  21 f7 39

sub_f749:
    bbc 0x00cd:4, lab_f760  ;f749  b4 cd 14
    bbc 0x00cd:5, lab_f766  ;f74c  b5 cd 17
    bbc 0x00ce:0, lab_f761  ;f74f  b0 ce 0f
    setb 0xcd:2             ;f752  aa cd

lab_f754:
    mov a, #0x0a            ;f754  04 0a
    mov 0xd0, a             ;f756  45 d0
    clrb 0xce:2             ;f758  a2 ce
    setb 0xce:1             ;f75a  a9 ce
    clrb 0xcd:5             ;f75c  a5 cd
    clrb 0xce:0             ;f75e  a0 ce

lab_f760:
    ret                     ;f760  20

lab_f761:
    setb 0xcd:1             ;f761  a9 cd
    jmp lab_f754            ;f763  21 f7 54

lab_f766:
    bbc 0x00ce:2, lab_f760  ;f766  b2 ce f7
    clrb 0xce:2             ;f769  a2 ce
    mov 0xcc, #0x00         ;f76b  85 cc 00
    clrb eic2:1             ;f76e  a1 25
    clrb cntr:2             ;f770  a2 12
    clrb eic2:3             ;f772  a3 25
    setb eic2:0             ;f774  a8 25
    jmp lab_f760            ;f776  21 f7 60

upd_read_key_data:
;Read key data from uPD16432B
;
    setb pdr0:2             ;f779  aa 00        UPD_STB = high (select uPD16432B)

    mov a, #0x44            ;f77b  04 44        Command byte = 0x44 (0b01000100)
                            ;                   Data Setting Command
                            ;                     4=Read key data
    call upd_send_byte      ;f77d  31 f9 db     Send byte in A to the uPD16432B

    mov ddr0, #0x0e         ;f780  85 01 0e
    setb pdr0:0             ;f783  a8 00        UPD_DATA = high
    setb pdr0:1             ;f785  a9 00        UPD_CLK = high
    movw a, #0x008f         ;f787  e4 00 8f     A = pointer to 4-byte buffer for key data
    movw 0x80, a            ;f78a  d5 80        Save pointer to buffer in 0x80
    mov 0x82, #0x04         ;f78c  85 82 04     4 bytes left to receive

lab_f78f:
    mov a, 0x82             ;f78f  05 82        A = number of bytes left to receive
    beq lab_f7bd            ;f791  fd 2a        Branch if no more bytes left
    decw a                  ;f793  d0           Decrement number of bytes left
    mov 0x82, a             ;f794  45 82        Save number of bytes left
    mov 0x84, #0x08         ;f796  85 84 08     8 bits left to receive

lab_f799:
;Receive a byte of key data from uPD16432B
;
    mov a, 0x84             ;f799  05 84        A = number of bits left to receive
    beq lab_f7b5            ;f79b  fd 18        Branch if no more bits left
    decw a                  ;f79d  d0
    mov 0x84, a             ;f79e  45 84
    clrb pdr0:1             ;f7a0  a1 00        UPD_CLK = low
    nop                     ;f7a2  00
    nop                     ;f7a3  00
    setb pdr0:1             ;f7a4  a9 00        UPD_CLK = high

    movw a, 0x80            ;f7a6  c5 80        A = pointer to 4-byte key data buffer
    movw ep, a              ;f7a8  e3           EP = A
    mov a, @ep              ;f7a9  07           Get current byte from buffer
    clrc                    ;f7aa  81
    rolc a                  ;f7ab  02           Rotate 0 into the byte
    mov @ep, a              ;f7ac  47           Store byte back in the buffer

    bbc pdr0:0, lab_f799    ;f7ad  b0 00 e9     Branch if UPD_DATA = low
    or a, #0x01             ;f7b0  74 01        Set bit 0 in the byte
    mov @ep, a              ;f7b2  47           Store byte back in the buffer

    bne lab_f799            ;f7b3  fc e4

lab_f7b5:
    movw a, 0x80            ;f7b5  c5 80        A = pointer to 4-byte key data buffer
    incw a                  ;f7b7  c0           Increment it
    movw 0x80, a            ;f7b8  d5 80        Store it
    jmp lab_f78f            ;f7ba  21 f7 8f

lab_f7bd:
;All 4 bytes of key data have been received from uPD16432B
;
    clrb pdr0:2             ;f7bd  a2 00        UPD_STB = low (deselect uPD16432B)

    movw ix, #0x008b        ;f7bf  e6 00 8b
    mov a, 0x8f             ;f7c2  05 8f        A = Byte 0 of 4-byte key data buffer
    xor a, @ix+0x00         ;f7c4  56 00
    mov a, 0x90             ;f7c6  05 90        A = Byte 1 of 4-byte key data buffer
    xor a, @ix+0x01         ;f7c8  56 01
    or a                    ;f7ca  72
    mov a, 0x91             ;f7cb  05 91        A = Byte 2 of 4-byte key data buffer
    xor a, @ix+0x02         ;f7cd  56 02
    or a                    ;f7cf  72
    mov a, 0x92             ;f7d0  05 92        A = Byte 3 of 4-byte key data buffer
    xor a, @ix+0x03         ;f7d2  56 03
    or a                    ;f7d4  72
    bne lab_f80e            ;f7d5  fc 37

    mov a, 0x0108           ;f7d7  60 01 08
    bne lab_f801            ;f7da  fc 25

    movw ix, #0x0093        ;f7dc  e6 00 93
    mov a, 0x8f             ;f7df  05 8f        A = Byte 0 of 4-byte key data buffer
    xor a, @ix+0x00         ;f7e1  56 00
    mov a, 0x90             ;f7e3  05 90        A = Byte 1 of 4-byte key data buffer
    xor a, @ix+0x01         ;f7e5  56 01
    or a                    ;f7e7  72
    mov a, 0x91             ;f7e8  05 91        A = Byte 2 of 4-byte key data buffer
    xor a, @ix+0x02         ;f7ea  56 02
    or a                    ;f7ec  72
    mov a, 0x92             ;f7ed  05 92        A = Byte 3 of 4-byte key data buffer
    xor a, @ix+0x03         ;f7ef  56 03
    or a                    ;f7f1  72
    beq lab_f81b            ;f7f2  fd 27

    movw a, 0x8f            ;f7f4  c5 8f        Copy 4-byte key data buffer
    movw 0x93, a            ;f7f6  d5 93          from 0x008f-0x0092
    movw a, 0x91            ;f7f8  c5 91          to   0x0093-0x0096
    movw 0x95, a            ;f7fa  d5 95

    setb 0x88:0             ;f7fc  a8 88        Set "key data ready" flag
    jmp lab_f81b            ;f7fe  21 f8 1b

lab_f801:
    movw a, #0x0000         ;f801  e4 00 00
    mov a, 0x0108           ;f804  60 01 08
    decw a                  ;f807  d0
    mov 0x0108, a           ;f808  61 01 08
    jmp lab_f81b            ;f80b  21 f8 1b

lab_f80e:
    movw a, 0x8f            ;f80e  c5 8f
    movw 0x8b, a            ;f810  d5 8b
    movw a, 0x91            ;f812  c5 91
    movw 0x8d, a            ;f814  d5 8d
    mov a, #0x02            ;f816  04 02
    mov 0x0108, a           ;f818  61 01 08

lab_f81b:
    ret                     ;f81b  20

parse_upd_key_data:
;Parse 4 bytes of key data from uPD16432B
    mov 0x85, #0x1c         ;f81c  85 85 1c
    mov 0x82, #0x00         ;f81f  85 82 00
    mov 0x83, #0x00         ;f822  85 83 00
    mov 0x84, #0x04         ;f825  85 84 04     Counter: 4 bytes of key data to process
    movw ep, #0x0093        ;f828  e7 00 93     EP = pointer to 4-byte key data buffer

lab_f82b:
    mov a, @ep              ;f82b  07           A = byte from key data buffer
    call parse_upd_key_bit  ;f82c  31 f8 bb
    call parse_upd_key_bit  ;f82f  31 f8 bb
    call parse_upd_key_bit  ;f832  31 f8 bb
    call parse_upd_key_bit  ;f835  31 f8 bb
    call parse_upd_key_bit  ;f838  31 f8 bb
    call parse_upd_key_bit  ;f83b  31 f8 bb
    call parse_upd_key_bit  ;f83e  31 f8 bb
    call parse_upd_key_bit  ;f841  31 f8 bb

    incw ep                 ;f844  c3           Move to next byte in key data buffer

    movw a, #0x0000         ;f845  e4 00 00     Decrement count of key data bytes available
    mov a, 0x84             ;f848  05 84
    decw a                  ;f84a  d0
    mov 0x84, a             ;f84b  45 84
    bne lab_f82b            ;f84d  fc dc        Keep going until 4 bytes have been processed

    mov a, 0x83             ;f84f  05 83
    bne lab_f86e            ;f851  fc 1b        TODO what is 0x0083?

    ;0x0083 = 0
    movw a, #0x0000         ;f853  e4 00 00     Clear 0x008b-0x0096:
    movw 0x8f, a            ;f856  d5 8f            Clear 0x008f-0x0090
    movw 0x91, a            ;f858  d5 91            Clear 0x0091-0x0092
    movw 0x8b, a            ;f85a  d5 8b            Clear 0x008b-0x008c
    movw 0x8d, a            ;f85c  d5 8d            Clear 0x008d-0x008e
    movw 0x93, a            ;f85e  d5 93            Clear 0x0093-0x0094
    movw 0x95, a            ;f860  d5 95            Clear 0x0095-0x0096

    clrb 0x89:0             ;f862  a0 89
    mov 0xd6, #0x00         ;f864  85 d6 00
    setb 0x88:1             ;f867  a9 88

lab_f869:
    mov a, #0x20            ;f869  04 20
    mov 0x8a, a             ;f86b  45 8a

lab_f86d:
    ret                     ;f86d  20

lab_f86e:
;A is from 0x0083, and A != 0
    cmp a, #0x01            ;f86e  14 01
    bne lab_f895            ;f870  fc 23
    bbs 0x0089:0, lab_f884  ;f872  b8 89 0f
    setb 0x89:0             ;f875  a8 89
    mov a, 0x85             ;f877  05 85

lab_f879:
    or a, #0x80             ;f879  74 80
    mov 0x8a, a             ;f87b  45 8a
    setb 0x88:1             ;f87d  a9 88
    clrb 0x89:7             ;f87f  a7 89
    jmp lab_f86d            ;f881  21 f8 6d

lab_f884:
    mov a, 0x85             ;f884  05 85
    mov a, 0x8a             ;f886  05 8a
    cmp a                   ;f888  12
    beq lab_f86d            ;f889  fd e2
    bbs 0x0089:7, lab_f86d  ;f88b  bf 89 df
    setb 0x88:1             ;f88e  a9 88

lab_f890:
    setb 0x89:7             ;f890  af 89
    jmp lab_f869            ;f892  21 f8 69

lab_f895:
;A is from 0x0083, A != 0, A != 1
    cmp a, #0x03            ;f895  14 03
    bne lab_f890            ;f897  fc f7
    cmp 0xd6, #0x07         ;f899  95 d6 07
    bne lab_f8a1            ;f89c  fc 03
    bbs 0x0089:0, lab_f890  ;f89e  b8 89 ef

lab_f8a1:
    mov a, 0xd3             ;f8a1  05 d3
    call sub_f939           ;f8a3  31 f9 39
    mov a, 0x86             ;f8a6  05 86
    call sub_f939           ;f8a8  31 f9 39
    mov a, 0x85             ;f8ab  05 85
    call sub_f939           ;f8ad  31 f9 39
    cmp 0xd6, #0x07         ;f8b0  95 d6 07
    bne lab_f890            ;f8b3  fc db
    setb 0x89:0             ;f8b5  a8 89
    mov a, #0x19            ;f8b7  04 19
    bne lab_f879            ;f8b9  fc be

parse_upd_key_bit:
    rolc a                  ;f8bb  02       Rotate left, store bit 7 in carry
    bnc lab_f8d8            ;f8bc  f8 1a    Branch if no carry

    mov a, 0x86             ;f8be  05 86
    mov 0xd3, a             ;f8c0  45 d3
    xch a, t                ;f8c2  42

    mov a, 0x85             ;f8c3  05 85
    mov 0x86, a             ;f8c5  45 86
    xch a, t                ;f8c7  42

    mov a, 0x82             ;f8c8  05 82
    mov 0x85, a             ;f8ca  45 85
    xch a, t                ;f8cc  42

    cmp 0x83, #0x04         ;f8cd  95 83 04
    bhs lab_f8d8            ;f8d0  f8 06

    mov a, 0x83             ;f8d2  05 83
    incw a                  ;f8d4  c0
    mov 0x83, a             ;f8d5  45 83
    xch a, t                ;f8d7  42

lab_f8d8:
    mov a, 0x82             ;f8d8  05 82
    incw a                  ;f8da  c0
    mov 0x82, a             ;f8db  45 82
    xch a, t                ;f8dd  42
    ret                     ;f8de  20

try_parse_mfsw:
    mov a, 0x0127           ;f8df  60 01 27     ;Get byte from MFSW
    cmp a, #0xff            ;f8e2  14 ff        ;Is it 0xFF (no MFSW key)?
    bne parse_mfsw_byte     ;f8e4  fc 19        ;  No: branch to handle MFSW key
    bbc 0x0089:3, lab_f8f3  ;f8e6  b3 89 0a
    clrb 0x89:3             ;f8e9  a3 89
    clrb 0x89:0             ;f8eb  a0 89

lab_f8ed:
    mov a, #0x20            ;f8ed  04 20
    mov 0x8a, a             ;f8ef  45 8a
    setb 0x88:1             ;f8f1  a9 88

lab_f8f3:
    ret                     ;f8f3  20

parse_mfsw_byte_good:
    or a, #0x80             ;f8f4  74 80
    mov 0x8a, a             ;f8f6  45 8a
    setb 0x88:1             ;f8f8  a9 88
    setb 0x89:3             ;f8fa  ab 89
    setb 0x89:0             ;f8fc  a8 89

parse_mfsw_byte_done:
    ret                     ;f8fe  20

parse_mfsw_byte:
;Parse MFSW key code in 0x0127
    bbs 0x0089:0, lab_f928  ;f8ff  b8 89 26
    mov a, 0x0127           ;f902  60 01 27
    mov 0x014c, a           ;f905  61 01 4c

    ;MFSW 0x00 -> Key Code 0x1c (vol down)
    cmp a, #0x00            ;f908  14 00        MSFW key = 0x00?
    bne parse_mfsw_try_01   ;f90a  fc 04        No: branch to try next MFSW key
    mov a, #0x1c            ;f90c  04 1c        A = key code for vol down
    bne parse_mfsw_byte_good ;f90e  fc e4       Branch always

parse_mfsw_try_01:
    ;MFSW 0x00 -> Key Code 0x1d (vol up)
    cmp a, #0x01            ;f910  14 01        MFSW key = 0x01?
    bne parse_mfsw_try_0a   ;f912  fc 04        No: branch to try next MFSW key
    mov a, #0x1d            ;f914  04 1d        A = key code for vol up
    bne parse_mfsw_byte_good ;f916  fc dc       Branch always

parse_mfsw_try_0a:
    ;MFSW 0x0a -> Key Code 0x1e (down)
    cmp a, #0x0a            ;f918  14 0a        MFSW key = 0x0a?
    bne parse_mfsw_try_0b   ;f91a  fc 04        No: branch to try next MFSW key
    mov a, #0x1e            ;f91c  04 1e        A = key code for down
    bne parse_mfsw_byte_good ;f91e  fc d4       Branch always

parse_mfsw_try_0b:
    ;MFSW 0x0b -> Key Code 0x1f (up)
    cmp a, #0x0b            ;f920  14 0b        MFSW key = 0x0b?
    bne parse_mfsw_byte_done ;f922  fc da       No: branch to done, no more MFSW keys to try
    mov a, #0x1f            ;f924  04 1f        A = key code for up
    bne parse_mfsw_byte_good ;f926  fc cc       Branch always

lab_f928:
    mov a, 0x0127           ;f928  60 01 27
    mov a, 0x014c           ;f92b  60 01 4c
    cmp a                   ;f92e  12
    beq parse_mfsw_byte_done ;f92f  fd cd       branch to return
    mov a, #0xfe            ;f931  04 fe
    mov 0x014c, a           ;f933  61 01 4c
    jmp lab_f8ed            ;f936  21 f8 ed     jmp to ret

sub_f939:
    cmp a, #0x18            ;f939  14 18
    bne lab_f940            ;f93b  fc 03
    setb 0xd6:0             ;f93d  a8 d6
    ret                     ;f93f  20

lab_f940:
    cmp a, #0x06            ;f940  14 06
    bne lab_f947            ;f942  fc 03
    setb 0xd6:1             ;f944  a9 d6
    ret                     ;f946  20

lab_f947:
    cmp a, #0x00            ;f947  14 00
    bne lab_f94d            ;f949  fc 02
    setb 0xd6:2             ;f94b  aa d6

lab_f94d:
    ret                     ;f94d  20

upd_send_all_data:
;Send uPD16432B characters and pictographs
;
;Reads 11 bytes of uPD16432B display data to 0x012f-0x139.  The faceplate LCD
;has the characters in reverse order so the buffer is read backwards.
;
;Reads 8 bytes of uPD16432B pictograph data to 0x00a1-0x00a8.
;
    pushw ix                ;f94e  41

    mov a, #0x40            ;f94f  04 40        Command byte = 0x40 (0b01000000)
                            ;                   Data Setting Command
                            ;                     0=Write to display RAM
                            ;                     Address increment mode: 0=increment
    call upd_send_cmd_byte  ;f951  31 f9 cd     Send single-byte command to uPD16432B

    movw ix, #0x012f+11     ;f954  e6 01 3a     IX = first byte of display data to send

    mov a, #0x82            ;f957  04 82        Command byte = 0x82 (0b10000010)
                            ;                     Address Setting Command
                            ;                     Address = 02

    setb pdr0:2             ;f959  aa 00        UPD_STB = high (select uPD16432B)
    nop                     ;f95b  00
    nop                     ;f95c  00

lab_f95d:
;Send 11 display data bytes
    call upd_send_byte      ;f95d  31 f9 db     Send byte in A to the uPD16432B

    movw a, ix              ;f960  f2
    movw a, #0x012f         ;f961  e4 01 2f
    cmpw a                  ;f964  13           Last byte of display data sent?
    beq lab_f96d            ;f965  fd 06        Yes: we're done, branch out

    decw ix                 ;f967  d2           Move pointer to next display data byte
    mov a, @ix+0x00         ;f968  06 00        A = display data byte to send

    jmp lab_f95d            ;f96a  21 f9 5d

lab_f96d:
    clrb pdr0:2             ;f96d  a2 00        UPD_STB = low (deselect uPD16432B)
    nop                     ;f96f  00
    nop                     ;f970  00

    mov a, #0x41            ;f971  04 41        Command byte = 0x41 (0b01000001)
                            ;                   Data Setting Command
                            ;                     1=Write to pictograph RAM
                            ;                     Address
    call upd_send_cmd_byte  ;f973  31 f9 cd     Send single-byte command to uPD16432B


    movw ix, #0x00a1-1      ;f976  e6 00 a0     IX = pointer to pictograph bytes - 1

    mov a, #0x80            ;f979  04 80        Command byte = 0x80 (0b10000000)
                            ;                   Address Setting Command
                            ;                     Address = 00

    setb pdr0:2             ;f97b  aa 00        UPD_STB = high (select uPD16432B)
    nop                     ;f97d  00
    nop                     ;f97e  00

lab_f97f:
;Send 8 pictograph bytes
    call upd_send_byte      ;f97f  31 f9 db     Send byte in A to the uPD16432B

    movw a, ix              ;f982  f2           A = pointer to pictographs buffer
    movw a, #0x00a8         ;f983  e4 00 a8     A = pointer to end of buffer + 1
    cmpw a                  ;f986  13           Reached the end of the buffer?
    beq lab_f98f            ;f987  fd 06        Yes: branch out

    incw ix                 ;f989  c2           Increment pointer to pictographs buffer
    mov a, @ix+0x00         ;f98a  06 00        A = pictograph byte from buffer

    jmp lab_f97f            ;f98c  21 f9 7f     Jump to send the byte

lab_f98f:
    clrb pdr0:2             ;f98f  a2 00        UPD_STB = low (deselect uPD16432B)
    popw ix                 ;f991  51
    ret                     ;f992  20

upd_init_and_clear:
;Initialize the uPD16432B and clear the display
;
    nop                     ;f993  00
    nop                     ;f994  00
    nop                     ;f995  00
    nop                     ;f996  00
    nop                     ;f997  00
    nop                     ;f998  00
    nop                     ;f999  00
    nop                     ;f99a  00

    mov a, #0x04            ;f99b  04 04        Command byte = 0x04 (0b00000100)
                            ;                   Display Setting Command
                            ;                     Duty setting: 0=1/8 duty
                            ;                     Master/slave setting: 0=master
                            ;                     Drive voltage supply method: 1=internal
    call upd_send_cmd_byte  ;f99d  31 f9 cd     Send single-byte command to uPD16432B

    mov a, #0xcf            ;f9a0  04 cf        Command byte = 0xcf (0b11001111)
                            ;                   Status command
                            ;                     Test mode setting: 0=Normal operation
                            ;                     Standby mode setting: 0=Normal operation
                            ;                     Key scan control: 1=Key scan operation
                            ;                     LED control: 1=Normal operation
                            ;                     LCD mode: 3=Normal operation (0b11)
    call upd_send_cmd_byte  ;f9a2  31 f9 cd     Send single-byte command to uPD16432B

    mov a, #0x20            ;f9a5  04 20        A = 0x2020 (two space characters)
    swap                    ;f9a7  10
    mov a, #0x20            ;f9a8  04 20
    movw ix, #0x012f        ;f9aa  e6 01 2f     IX = 0x012f (display buffer)
    movw @ix+0x00, a        ;f9ad  d6 00        Fill all 11 bytes of display buffer
    movw @ix+0x02, a        ;f9af  d6 02
    movw @ix+0x04, a        ;f9b1  d6 04
    movw @ix+0x06, a        ;f9b3  d6 06
    movw @ix+0x08, a        ;f9b5  d6 08
    mov @ix+0x0a, a         ;f9b7  46 0a

    movw a, #0x0000         ;f9b9  e4 00 00     A = 0 (two empty pictograph bytes)
    movw ix, #0x00a1        ;f9bc  e6 00 a1     IX = 0x00a1 (pictograph buffer)
    movw @ix+0x00, a        ;f9bf  d6 00        Fill all 8 bytes of pictograph buffer
    movw @ix+0x02, a        ;f9c1  d6 02
    movw @ix+0x04, a        ;f9c3  d6 04
    movw @ix+0x06, a        ;f9c5  d6 06

    call upd_send_all_data  ;f9c7  31 f9 4e     Send characters and pictographs to uPD16432B
    setb 0xa9:6             ;f9ca  ae a9
    ret                     ;f9cc  20

upd_send_cmd_byte:
;Send a single-byte command to the uPD16432B
;STB is activated before the byte and deactivated after.
;
    setb pdr0:2             ;f9cd  aa 00        UPD_STB = high (select uPD16432B)
    nop                     ;f9cf  00
    nop                     ;f9d0  00
    call upd_send_byte      ;f9d1  31 f9 db     Send byte in A to the uPD16432B
    nop                     ;f9d4  00
    nop                     ;f9d5  00
    clrb pdr0:2             ;f9d6  a2 00        UPD_STB = low (deselect uPD16432B)
    nop                     ;f9d8  00
    nop                     ;f9d9  00
    ret                     ;f9da  20

upd_send_byte:
;Send byte in A to uPD16432B
;STB is unaffected.
;
    mov ddr0, #0x0f         ;f9db  85 01 0f
    setb pdr0:1             ;f9de  a9 00        UPD_CLK = high
    mov r7, #0x08           ;f9e0  8f 08

lab_f9e2:
    rolc a                  ;f9e2  02
    bhs lab_f9e9            ;f9e3  f8 04
    setb pdr0:0             ;f9e5  a8 00        UPD_DATA = high
    blo lab_f9eb            ;f9e7  f9 02

lab_f9e9:
    clrb pdr0:0             ;f9e9  a0 00        UPD_DATA = low

lab_f9eb:
    clrb pdr0:1             ;f9eb  a1 00        UPD_CLK = low
    nop                     ;f9ed  00
    nop                     ;f9ee  00
    setb pdr0:1             ;f9ef  a9 00        UPD_CLK = high
    dec r7                  ;f9f1  df
    bne lab_f9e2            ;f9f2  fc ee
    ret                     ;f9f4  20

upd_init_and_write:
;Initialize uPD16432B and write all data
;
    bbc 0x0087:7, lab_fa08  ;f9f5  b7 87 10
    clrb 0x87:7             ;f9f8  a7 87

    mov a, #0x04            ;f9fa  04 04        Command byte = 0x04 (0b00000100)
                            ;                   Display Setting Command
                            ;                     Duty setting: 0=1/8 duty
                            ;                     Master/slave setting: 0=master
                            ;                     Drive voltage supply method: 1=internal
    call upd_send_cmd_byte  ;f9fc  31 f9 cd     Send single-byte command to uPD16432B

    mov a, #0xcf            ;f9ff  04 cf        Command byte = 0xcf (0b11001111)
                            ;                   Status command
                            ;                     Test mode setting: 0=Normal operation
                            ;                     Standby mode setting: 0=Normal operation
                            ;                     Key scan control: 1=Key scan operation
                            ;                     LED control: 1=Normal operation
                            ;                     LCD mode: 3=Normal operation (0b11)
    call upd_send_cmd_byte  ;fa01  31 f9 cd     Send single-byte command to uPD16432B

    call upd_send_all_data  ;fa04  31 f9 4e     Send characters and pictographs to uPD16432B
    ret                     ;fa07  20

lab_fa08:
    bbc 0x0087:2, lab_fa0f  ;fa08  b2 87 04
    clrb 0x87:2             ;fa0b  a2 87
    setb 0x87:7             ;fa0d  af 87

lab_fa0f:
    ret                     ;fa0f  20

sub_fa10:
    mov a, 0x0145           ;fa10  60 01 45
    beq lab_fa19            ;fa13  fd 04
    decw a                  ;fa15  d0
    mov 0x0145, a           ;fa16  61 01 45

lab_fa19:
    bbc 0x00cd:6, lab_fa2a  ;fa19  b6 cd 0e
    movw a, #0x0000         ;fa1c  e4 00 00
    mov a, 0xcf             ;fa1f  05 cf
    decw a                  ;fa21  d0
    mov 0xcf, a             ;fa22  45 cf
    bne lab_fa2a            ;fa24  fc 04
    clrb 0xcd:6             ;fa26  a6 cd
    setb 0xcd:7             ;fa28  af cd

lab_fa2a:
    bbc 0x00ce:1, lab_fa3b  ;fa2a  b1 ce 0e
    movw a, #0x0000         ;fa2d  e4 00 00
    mov a, 0xd0             ;fa30  05 d0
    decw a                  ;fa32  d0
    mov 0xd0, a             ;fa33  45 d0
    bne lab_fa3b            ;fa35  fc 04
    clrb 0xce:1             ;fa37  a1 ce
    setb 0xce:2             ;fa39  aa ce

lab_fa3b:
    mov a, 0x99             ;fa3b  05 99
    incw a                  ;fa3d  c0
    mov 0x99, a             ;fa3e  45 99
    cmp a, #0x0a            ;fa40  14 0a
    blo lab_fa58            ;fa42  f9 14
    mov 0x99, #0x00         ;fa44  85 99 00
    setb 0x97:0             ;fa47  a8 97
    movw a, #0x0000         ;fa49  e4 00 00
    mov a, 0x98             ;fa4c  05 98
    decw a                  ;fa4e  d0
    mov 0x98, a             ;fa4f  45 98
    bne lab_fa58            ;fa51  fc 05
    mov 0x98, #0x0a         ;fa53  85 98 0a
    setb 0x97:1             ;fa56  a9 97

lab_fa58:
    ret                     ;fa58  20

sub_fa59:
    bbc 0x0097:0, lab_fa61  ;fa59  b0 97 05
    clrb 0x97:0             ;fa5c  a0 97
    call sub_fa6a           ;fa5e  31 fa 6a

lab_fa61:
    bbc 0x0097:1, lab_fa69  ;fa61  b1 97 05
    clrb 0x97:1             ;fa64  a1 97
    call sub_fad2           ;fa66  31 fa d2

lab_fa69:
    ret                     ;fa69  20

sub_fa6a:
    bbc 0x00a9:6, lab_fa70  ;fa6a  b6 a9 03
    call upd_read_key_data  ;fa6d  31 f7 79     Read key data from uPD16432B

lab_fa70:
    bbc 0x00d2:2, lab_fa83  ;fa70  b2 d2 10
    movw a, #0x0000         ;fa73  e4 00 00
    mov a, 0x0149           ;fa76  60 01 49
    decw a                  ;fa79  d0
    mov 0x0149, a           ;fa7a  61 01 49
    bne lab_fa83            ;fa7d  fc 04
    clrb 0xd2:2             ;fa7f  a2 d2
    setb 0xd2:3             ;fa81  ab d2

lab_fa83:
    bbc 0x009a:1, lab_fa96  ;fa83  b1 9a 10
    movw a, #0x0000         ;fa86  e4 00 00
    mov a, 0x0121           ;fa89  60 01 21
    decw a                  ;fa8c  d0
    mov 0x0121, a           ;fa8d  61 01 21
    bne lab_fa96            ;fa90  fc 04
    clrb 0x9a:1             ;fa92  a1 9a
    setb 0x9a:2             ;fa94  aa 9a

lab_fa96:
    bbc 0x009b:6, lab_faa7  ;fa96  b6 9b 0e
    movw a, #0x0000         ;fa99  e4 00 00
    mov a, 0x9f             ;fa9c  05 9f
    decw a                  ;fa9e  d0
    mov 0x9f, a             ;fa9f  45 9f
    bne lab_faa7            ;faa1  fc 04
    clrb 0x9b:6             ;faa3  a6 9b
    setb 0x9b:7             ;faa5  af 9b

lab_faa7:
    mov a, 0x0123           ;faa7  60 01 23
    beq lab_fab0            ;faaa  fd 04
    decw a                  ;faac  d0
    mov 0x0123, a           ;faad  61 01 23

lab_fab0:
    bbc 0x009b:2, lab_fac1  ;fab0  b2 9b 0e
    movw a, #0x0000         ;fab3  e4 00 00
    mov a, 0x9d             ;fab6  05 9d
    decw a                  ;fab8  d0
    mov 0x9d, a             ;fab9  45 9d
    bne lab_fac1            ;fabb  fc 04
    clrb 0x9b:2             ;fabd  a2 9b
    setb 0x9b:3             ;fabf  ab 9b

lab_fac1:
    mov a, 0x013a           ;fac1  60 01 3a
    beq lab_faca            ;fac4  fd 04
    decw a                  ;fac6  d0
    mov 0x013a, a           ;fac7  61 01 3a

lab_faca:
    mov a, 0xcb             ;faca  05 cb
    beq lab_fad1            ;facc  fd 03
    decw a                  ;face  d0
    mov 0xcb, a             ;facf  45 cb

lab_fad1:
    ret                     ;fad1  20

sub_fad2:
    mov a, 0xc7             ;fad2  05 c7
    beq lab_fad9            ;fad4  fd 03
    decw a                  ;fad6  d0
    mov 0xc7, a             ;fad7  45 c7

lab_fad9:
    mov a, 0xc9             ;fad9  05 c9
    beq lab_fae0            ;fadb  fd 03
    decw a                  ;fadd  d0
    mov 0xc9, a             ;fade  45 c9

lab_fae0:
    mov a, 0xd1             ;fae0  05 d1
    beq lab_fae7            ;fae2  fd 03
    decw a                  ;fae4  d0
    mov 0xd1, a             ;fae5  45 d1

lab_fae7:
    ret                     ;fae7  20

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
