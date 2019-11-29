    .area CODE1 (ABS)
    .org 0

rxb0_txs0 = 0xff18          ;Transmit shift register 0 / Receive buffer register 0
pm2 = 0xff22                ;Port mode register 2
asim0 = 0xffa0              ;Asynchronous serial interface mode register 0
asis0 = 0xffa1              ;Asynchronous serial interface status register 0
brgc0 = 0xffa2              ;Baud rate generator control register 0
if0h = 0xffe1               ;Interrupt request flag register 0H
ims = 0xfff0                ;Memory size switching register
ixs = 0xfff4                ;Internal expansion RAM size switching register
wdtm = 0xfff9               ;Watchdog timer mode register
pcc = 0xfffb                ;Processor clock control register

    .word reset         ;VECTOR RST
    .word forever       ;VECTOR (unused)
    .word forever       ;VECTOR INTWDT
    .word forever       ;VECTOR INTP0
    .word forever       ;VECTOR INTP1
    .word forever       ;VECTOR INTP2
    .word forever       ;VECTOR INTP3
    .word forever       ;VECTOR INTP4
    .word forever       ;VECTOR INTP5
    .word forever       ;VECTOR INTP6
    .word forever       ;VECTOR INTP7
    .word forever       ;VECTOR INTSER0
    .word forever       ;VECTOR INTSR0
    .word forever       ;VECTOR INTST0
    .word forever       ;VECTOR INTCSI30
    .word forever       ;VECTOR INTCSI31
    .word forever       ;VECTOR INTIIC0
    .word forever       ;VECTOR INTC2
    .word forever       ;VECTOR INTWTNI0
    .word forever       ;VECTOR INTTM000
    .word forever       ;VECTOR INTTM010
    .word forever       ;VECTOR INTTM001
    .word forever       ;VECTOR INTTM011
    .word forever       ;VECTOR INTAD00
    .word forever       ;VECTOR INTAD01
    .word forever       ;VECTOR (unused)
    .word forever       ;VECTOR INTWTN0
    .word forever       ;VECTOR INTKR
    .word forever       ;VECTOR (unused)
    .word forever       ;VECTOR (unused)
    .word forever       ;VECTOR (unused)
    .word forever       ;VECTOR BRK_I
    .word forever       ;VECTOR CALLT #0
    .word forever       ;VECTOR CALLT #1
    .word forever       ;VECTOR CALLT #2
    .word forever       ;VECTOR CALLT #3
    .word forever       ;VECTOR CALLT #4
    .word forever       ;VECTOR CALLT #5
    .word forever       ;VECTOR CALLT #6
    .word forever       ;VECTOR CALLT #7
    .word forever       ;VECTOR CALLT #8
    .word forever       ;VECTOR CALLT #9
    .word forever       ;VECTOR CALLT #10
    .word forever       ;VECTOR CALLT #11
    .word forever       ;VECTOR CALLT #12
    .word forever       ;VECTOR CALLT #13
    .word forever       ;VECTOR CALLT #14
    .word forever       ;VECTOR CALLT #15
    .word forever       ;VECTOR CALLT #16
    .word forever       ;VECTOR CALLT #17
    .word forever       ;VECTOR CALLT #18
    .word forever       ;VECTOR CALLT #19
    .word forever       ;VECTOR CALLT #20
    .word forever       ;VECTOR CALLT #21
    .word forever       ;VECTOR CALLT #22
    .word forever       ;VECTOR CALLT #23
    .word forever       ;VECTOR CALLT #24
    .word forever       ;VECTOR CALLT #25
    .word forever       ;VECTOR CALLT #26
    .word forever       ;VECTOR CALLT #27
    .word forever       ;VECTOR CALLT #28
    .word forever       ;VECTOR CALLT #29
    .word forever       ;VECTOR CALLT #30
    .word forever       ;VECTOR CALLT #31

forever:
    br forever

reset:
    di                      ;Disable interrupts
    mov pcc,#0              ;Processor clock = full speed
    mov wdtm,#0             ;Watchdog disabled
    mov ixs,#8              ;Expansion RAM size = 2K
    mov ims,#0xcf           ;High speed RAM size = 1K, ROM size = 60K
    movw sp,#0xfe1f         ;Initialize stack pointer
    mov asim0,#0            ;Disable UART
    mov brgc0,#0x1b         ;Set baud rate to 38400 bps
    clr1 if0h.2             ;Clear receive complete interrupt flag
    clr1 if0h.3             ;Clear transmit complete interrupt flag
    mov asim0,#0b11001010   ;Enable UART for tx/rx and 8-N-1
    clr1 pm2.5              ;PM25=output (TxD0)

loop:
    call recv_byte          ;Wait for a byte from UART0, store it in A
    call send_byte          ;Send byte in A on UART0
    br loop

recv_byte:
    bf if0h.2, recv_byte   ;Wait until IF0H.2=1 (receive complete)
    clr1 if0h.2            ;Clear receive complete interrupt flag
    mov a,rxb0_txs0        ;A = byte received
    ret

send_byte:
    mov rxb0_txs0,a        ;Send byte in A
send_wait:
    bf if0h.3, send_wait   ;Wait until IF0H.3=1 (transmit complete)
    clr1 if0h.3            ;Clear transmit complete interrupt flag
    ret
