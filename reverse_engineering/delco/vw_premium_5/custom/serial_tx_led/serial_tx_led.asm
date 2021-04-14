    .area CODE1 (ABS)
    .org 0

rxb0_txs0 = 0xff18          ;Transmit shift register 0 / Receive buffer register 0
p3 = 0xff03                 ;Port 3
pm2 = 0xff22                ;Port mode register 2
pm3 = 0xff23                ;Port mode register 3
asim0 = 0xffa0              ;Asynchronous serial interface mode register 0
asis0 = 0xffa1              ;Asynchronous serial interface status register 0
brgc0 = 0xffa2              ;Baud rate generator control register 0
if0h = 0xffe1               ;Interrupt request flag register 0H
ims = 0xfff0                ;Memory size switching register
ixs = 0xfff4                ;Internal expansion RAM size switching register
wdtm = 0xfff9               ;Watchdog timer mode register
pcc = 0xfffb                ;Processor clock control register

    .word reset             ;VECTOR RST
    .word irq_unexpected    ;VECTOR (unused)
    .word irq_unexpected    ;VECTOR INTWDT
    .word irq_unexpected    ;VECTOR INTP0
    .word irq_unexpected    ;VECTOR INTP1
    .word irq_unexpected    ;VECTOR INTP2
    .word irq_unexpected    ;VECTOR INTP3
    .word irq_unexpected    ;VECTOR INTP4
    .word irq_unexpected    ;VECTOR INTP5
    .word irq_unexpected    ;VECTOR INTP6
    .word irq_unexpected    ;VECTOR INTP7
    .word irq_unexpected    ;VECTOR INTSER0
    .word irq_unexpected    ;VECTOR INTSR0
    .word irq_unexpected    ;VECTOR INTST0
    .word irq_unexpected    ;VECTOR INTCSI30
    .word irq_unexpected    ;VECTOR INTCSI31
    .word irq_unexpected    ;VECTOR INTIIC0
    .word irq_unexpected    ;VECTOR INTC2
    .word irq_unexpected    ;VECTOR INTWTNI0
    .word irq_unexpected    ;VECTOR INTTM000
    .word irq_unexpected    ;VECTOR INTTM010
    .word irq_unexpected    ;VECTOR INTTM001
    .word irq_unexpected    ;VECTOR INTTM011
    .word irq_unexpected    ;VECTOR INTAD00
    .word irq_unexpected    ;VECTOR INTAD01
    .word irq_unexpected    ;VECTOR (unused)
    .word irq_unexpected    ;VECTOR INTWTN0
    .word irq_unexpected    ;VECTOR INTKR
    .word irq_unexpected    ;VECTOR (unused)
    .word irq_unexpected    ;VECTOR (unused)
    .word irq_unexpected    ;VECTOR (unused)
    .word irq_unexpected    ;VECTOR BRK_I
    .word irq_unexpected    ;VECTOR CALLT #0
    .word irq_unexpected    ;VECTOR CALLT #1
    .word irq_unexpected    ;VECTOR CALLT #2
    .word irq_unexpected    ;VECTOR CALLT #3
    .word irq_unexpected    ;VECTOR CALLT #4
    .word irq_unexpected    ;VECTOR CALLT #5
    .word irq_unexpected    ;VECTOR CALLT #6
    .word irq_unexpected    ;VECTOR CALLT #7
    .word irq_unexpected    ;VECTOR CALLT #8
    .word irq_unexpected    ;VECTOR CALLT #9
    .word irq_unexpected    ;VECTOR CALLT #10
    .word irq_unexpected    ;VECTOR CALLT #11
    .word irq_unexpected    ;VECTOR CALLT #12
    .word irq_unexpected    ;VECTOR CALLT #13
    .word irq_unexpected    ;VECTOR CALLT #14
    .word irq_unexpected    ;VECTOR CALLT #15
    .word irq_unexpected    ;VECTOR CALLT #16
    .word irq_unexpected    ;VECTOR CALLT #17
    .word irq_unexpected    ;VECTOR CALLT #18
    .word irq_unexpected    ;VECTOR CALLT #19
    .word irq_unexpected    ;VECTOR CALLT #20
    .word irq_unexpected    ;VECTOR CALLT #21
    .word irq_unexpected    ;VECTOR CALLT #22
    .word irq_unexpected    ;VECTOR CALLT #23
    .word irq_unexpected    ;VECTOR CALLT #24
    .word irq_unexpected    ;VECTOR CALLT #25
    .word irq_unexpected    ;VECTOR CALLT #26
    .word irq_unexpected    ;VECTOR CALLT #27
    .word irq_unexpected    ;VECTOR CALLT #28
    .word irq_unexpected    ;VECTOR CALLT #29
    .word irq_unexpected    ;VECTOR CALLT #30
    .word irq_unexpected    ;VECTOR CALLT #31

irq_unexpected:
    br irq_unexpected

reset:
    di                      ;Disable interrupts
    mov pcc,#0              ;Processor clock = full speed
    mov wdtm,#0             ;Watchdog disabled
    mov ixs,#8              ;Expansion RAM size = 2K
    mov ims,#0xcf           ;High speed RAM size = 1K, ROM size = 60K
    movw sp,#0xfe1f         ;Initialize stack pointer
    mov asim0,#0            ;Disable UART
    mov brgc0,#0x3b         ;Set baud rate to 9600 bps
    clr1 if0h.2             ;Clear receive complete interrupt flag
    clr1 if0h.3             ;Clear transmit complete interrupt flag
    mov asim0,#0b10001010   ;Enable UART for TX only and 8-N-1
    clr1 pm2.5              ;PM25=output (TxD0)
    clr1 pm3.3              ;PM33=output (Alarm LED)

;Every ~250ms, toggle the LED and send "Hello World"
;out the UART at 9600-N-8-1.
loop:
    mov1 cy,p3.3            ;Invert the LED
    not1 cy
    mov1 p3.3,cy

    movw hl,#hello          ;Send "Hello World"
1$:
    mov a,[hl]
    cmp a,#0
    bz 2$
    call send_byte
    incw hl
    br 1$
2$:
    call delay              ;Wait 250ms
    br loop

send_byte:
    mov rxb0_txs0,a        ;Send byte in A
1$:
    bf if0h.3, 1$          ;Wait until IF0H.3=1 (transmit complete)
    clr1 if0h.3            ;Clear transmit complete interrupt flag
    ret

delay:
    movw ax,#0xffff
1$:
    cmpw ax,#0
    decw ax
    bnz 1$
    ret

hello:
    .ascii "Hello World"
    .byte 0x0d,0x0a,0
