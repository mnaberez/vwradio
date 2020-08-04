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
