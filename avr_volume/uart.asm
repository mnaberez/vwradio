;UART Routines
;

uart_init:
;Configure the UART for 115200 bps, N-8-1, transmit only.
;
    ;115200 bps @ 20 MHz
	clr r16
    sts	UBRR0H, r16
    ldi	r16, 0x0a
    sts	UBRR0L, r16
    lds	r16, UCSR0A
    andi r16, ~(1 << U2X0)
	sts UCSR0A, r16

	;N-8-1
    ldi	r16, (1 << UCSZ01) | (1 << UCSZ00)
    sts	UCSR0C, r16

	;Enable TX only
	ldi r16, (1 << TXEN0)
	sts UCSR0B, r16
	ret

uart_send_byte:
;Send the byte in R16 out the UART.
;If the UART is busy transmitting, this routine blocks until it is ready.
;Destroys R17.
;
    ;Wait for transmit buffer to be empty.
    lds  r17, UCSR0A
    sbrs r17, UDRE0
    rjmp uart_send_byte

    ;Send the data byte.
    sts UDR0, r16
	ret
