    .area CODE1 (ABS)
    .org 0

rxb0_txs0 = 0xff18          ;Transmit shift register 0 / Receive buffer register 0
pm2 = 0xff22                ;Port mode register 2
asim0 = 0xffa0              ;Asynchronous serial interface mode register 0
asis0 = 0xffa1              ;Asynchronous serial interface status register 0
brgc0 = 0xffa2              ;Baud rate generator control register 0
if0h = 0xffe1               ;Interrupt request flag register 0H
mk0h = 0xffe5               ;Interrupt mask flag register 0H
pr0h = 0xffe9               ;Priority level specification flag register 0H
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
    .word irq_intser0       ;VECTOR INTSER0     UART0 receive error
    .word irq_intsr0        ;VECTOR INTSR0      UART0 receive complete
    .word irq_intst0        ;VECTOR INTST0      UART0 transmit complete
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

;UART0 receive error interrupt
irq_intser0:
    push ax

    mov a,asis0             ;32e3  f4 a1          A = UART0 status register when interrupt occurred
    mov x,a                 ;32e5  70             Save UART0 status register in X

    mov a,rxb0_txs0         ;32e6  f0 18          A = byte received
    clr1 if0h.2             ;32e8  71 2b e1       Clear receive complete interrupt flag

    ;Status register value is in X and could be interrogated here

    pop ax
    reti

;UART0 receive complete interrupt
irq_intsr0:
    push ax

    mov a,rxb0_txs0         ;A = byte received from UART
    mov rxb0_txs0,a         ;Blindly transmit it back, assumes not currently transmitting

    pop ax
    reti

;UART0 transmit complete interrupt
irq_intst0:
    reti

reset:
    di                      ;Disable interrupts
    mov pcc,#0              ;Processor clock = full speed
    mov wdtm,#0             ;Watchdog disabled
    mov ixs,#8              ;Expansion RAM size = 2K
    mov ims,#0xcf           ;High speed RAM size = 1K, ROM size = 60K
    movw sp,#0xfe1f         ;Initialize stack pointer
    mov asim0,#0            ;Disable UART
    mov brgc0,#0x1b         ;Set baud rate to 38400 bps

    clr1 if0h.1             ;Clear SERIF0 (UART0 receive error INTSER0) interrupt flag
    clr1 mk0h.1             ;Clear SERMK0 (enables INTSER0)
    set1 pr0h.1             ;Set SERPR0 (makes INTSER0 low priority)

    clr1 if0h.2             ;Clear SRIF0 (UART0 receive complete INTSR0) interrupt flag
    clr1 mk0h.2             ;Clear SRMK0 (enables INTSR0)
    set1 pr0h.2             ;Set SRPR0 (makes INTSR0 low priority)

    clr1 if0h.3             ;Clear STIF0 (UART0 transmit complete INTST0) interrupt flag
    clr1 mk0h.3             ;Clear STMK0 (enables INTST0)
    set1 pr0h.3             ;Set STPR0 (makes INTST0 low priority)

    ei                      ;Enable interrupts

    mov asim0,#0b11001010   ;Enable UART for tx/rx and 8-N-1
    clr1 pm2.5              ;PM25=output (TxD0)

loop:
    br loop
