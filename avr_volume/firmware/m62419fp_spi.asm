;M62419FP Interrupt-Driven SPI Receiver
;
;The M62419FP uses a 14-bit SPI command.  Since 14 is not a multiple of 8, it
;can't be received by the hardware SPI.  This code uses bit-banging: a pin
;change interrupt fires for the clock edges and the ISR accumulates the bits.
;
;There are 3 buffers used in this code.  The ISR uses packet_isr_buf to
;accumulate SPI bits received.  When a complete packet is received, it moves
;the packet into packet_rx_buf.  The main loop waits for a new packet in
;packet_rx_buf and then transfers it into packet_work_buf.  The work buffer is
;used by all code in the main loop.  This allows receiving a new command while
;the main loop is still processing the last one.  The main loop should call
;spi_get_packet (below) and then operate only on packet_work_buf.
;
;Registers reserved for the ISR that may not be used by any other code:
;  R21, R22


spi_init:
;Set up for receiving M62419FP commands on interrupt.
;Destroy R16.
;
    ;Set PIN1, PINA0 as input
    in r16, DDRA
    andi r16, ~((1 << PINA1) | (1 << PINA0))
    out DDRA, r16

    ;Set pin change enable mask 0 for PA1 (PCINT1) only
    ldi r16, (1 << PCINT1)
    sts PCMSK0, r16

    ;Enable interrupts from pin change group 0 only
    ldi r16, (1 << PCIE0)
    sts PCICR, r16

    ;Clear locations used by ISR to collect SPI bits
    ldi r16, 14                 ;Set initial count = 14 bits to receive
    sts packet_bitcount, r16
    clr r16
    sts packet_isr_buf, r16     ;Clear low data byte
    sts packet_isr_buf+1, r16   ;Clear high data byte

    ;Clear latest packet received (ISR writes complete packet to this buffer)
    clr r16
    sts packet_rx_buf, r16
    sts packet_rx_buf+1, r16
    ret


spi_isr_pcint0:
;PCINT0 Pin Change Group 0 Interrupt Service Routine
;Fires for any change on PCINT1 (M62419FP CLK).
;R21 and R22 are destroyed by this ISR.
;
    in r21, PINA                ;Read port immediately (SREG unaffected)
    in r22, SREG                ;Preserve SREG

    sbrs r21, PINA1             ;Skip next instruction if CLK=1
    rjmp spi_isr_done           ;Nothing to do; it was a falling edge.

    ;This is a rising edge and the DAT bit is valid.

    asr r21                     ;Shift DAT bit (PINA0) into the carry

    lds r21, packet_isr_buf     ;Shift carry into low byte
    rol r21
    sts packet_isr_buf, r21

    lds r21, packet_isr_buf+1   ;Shift carry into high byte
    rol r21
    sts packet_isr_buf+1, r21

    ;Check if a complete packet has been received.

    lds r21, packet_bitcount    ;Decrement number of bits remaining
    dec r21
    sts packet_bitcount, r21
    brne spi_isr_done           ;More bits?  Nothing more to do this time.

    ;A complete packet has been received.
    ;Transfer packet_isr_buf -> packet_rx_buf

    lds r21, packet_isr_buf
    sts packet_rx_buf, r21      ;Save low byte

    lds r21, packet_isr_buf+1
    ori r21, 0b10000000         ;Set unused bit to indicate packet complete
    sts packet_rx_buf+1, r21    ;Save high byte

    ;Set up for next time.

    ldi r21, 14                 ;Set initial count = 14 bits to receive
    sts packet_bitcount, r21
    clr r21
    sts packet_isr_buf, r21     ;Clear low data byte
    sts packet_isr_buf+1, r21   ;Clear high data byte

spi_isr_done:
    out SREG, r22               ;Restore SREG
    reti


spi_get_packet:
;Check if a new packet has been received by the ISR, if so then move
;it into the work buffer.  Destroys R16, R17, R18.
;
;Stores the packet at Y-pointer (if a packet is available).
;Carry set = packet ready, Carry clear = no packet.
;
    ;Check for a new packet
    lds r16, packet_rx_buf+1    ;Load high byte
    clc                         ;Carry clear = no packet
    sbrs r16, 7                 ;Skip next if bit 7 indicates packet complete
    ret                         ;No packet yet

    ;A packet is available in packet_rx_buf
    ;Read it into R16+R17 and then clear packet_rx_buf for the next packet
    ;Interrupts disabled to prevent race if a new byte is received during copy
    clr r18
    cli
    lds r16, packet_rx_buf
    lds r17, packet_rx_buf+1
    sts packet_rx_buf, r18
    sts packet_rx_buf+1, r18
    sei

    ;Copy the received 14-bit packet into the work buffer at Y
    st Y, r16                   ;Copy low byte
    andi r17, 0b00111111        ;Zero out non-data bits of high byte
    std Y+1, r17                ;Copy high byte

    sec                         ;Carry set = packet received
    ret
