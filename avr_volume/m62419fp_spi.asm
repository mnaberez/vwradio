;M62419FP Interrupt-Driven SPI Receiver
;
;The M62419FP uses a 14-bit SPI command.  Since 14 is not a multiple of 8, it
;can't be received by the hardware SPI.  This code uses bit-banging: a pin
;change interrupt fires for the clock edges and the ISR accumulates the bits.
;
;There are two buffers used in this code.  The receive buffer, packet_rx_buf,
;is used by the ISR.  The work buffer, packet_work_buf, is used by code in
;the main loop.  This allows receiving a new command while the main loop is
;still processing the last one.  The main loop should call spi_get_packet
;(below) and then operate only on packet_work_buf.
;

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

	;Clear registers used by ISR
	ldi r20, 14 				;Set initial count = 14 bits to receive
	clr r22 					;Clear low data byte
	clr r23 					;Clear high data byte

	;Clear latest packet received (ISR writes to this buffer)
	ldi r16, 0
	sts packet_rx_buf, r16
	sts packet_rx_buf+1, r16
    ret


spi_isr_pcint0:
;PCINT0 Pin Change Group 0 Interrupt Service Routine
;Fires for any change on PCINT1 (M62419FP CLK).
;
;Registers r21-r24 can only be used by this ISR.
;  r20: counts down number of bits remaining in this packet (14, 13, ...)
;  r21: byte read from PINA (contains CLK and DAT)
;  r22: low byte of current packet
;  r23: high byte of current packet
;  r24: used to preserve SREG
;
	in r21, PINA 				;Sample port immediately (SREG unaffected)
	in r24, SREG 				;Save SREG

	sbrs r21, PINA1 			;Skip next instruction if CLK=1
	rjmp spi_isr_done			;Nothing to do; it was a falling edge.

	;This is a rising edge and the DAT bit is valid.

	asr r21 					;Shift DAT bit into the carry
	rol r22 					;  then shift carry into low byte
	rol r23 					;  then shift carry into high byte

	dec r20 					;Decrement number of bits remaining
	brne spi_isr_done 			;More bits?  Nothing more to do this time.

	;A complete packet has been received.

	sts packet_rx_buf, r22 		;Save low byte
	sts packet_rx_buf+1, r23 	;Save high byte

	;Set up for next time

	ldi r20, 14 				;Set initial count = 14 bits to receive
	clr r22 					;Clear low data byte
	clr r23 					;Clear high data byte

spi_isr_done:
	out SREG, r24 				;Restore SREG
	reti


spi_get_packet:
;Check if a new packet has been received by the ISR, if so then move
;it into the work buffer.  Destroys R16, R17, R18.
;
;Stores the packet in packet_work_buf if one is ready.
;Carry set = packet ready, Carry clear = no packet.
;
	;Check for a new packet
	;(ignores a packet of all zeroes but that's never been seen)
	lds r16, packet_rx_buf
    lds r17, packet_rx_buf+1
    or r16, r17
    breq sgp_none

	;A packet is available in packet_rx_buf
	;Read it into R16+R17 then clear packet_rx_buf for the next packet
	;Interrupts disabled to prevent race if a new byte is received during copy
	clr r18
	cli
    lds r16, packet_rx_buf
	lds r17, packet_rx_buf+1
	sts packet_rx_buf, r18
	sts packet_rx_buf+1, r18
	sei

	;Copy the received packet into the work buffer
	sts packet_work_buf, r16
	sts packet_work_buf+1, r17

    sec                             ;Carry set = packet received
    ret
sgp_none:
    clc                             ;Carry clear = no packet
    ret
