	.F2MC8L
	.area CODE1 (ABS)
	.org 0xe000

pdr3 = 0x0c 			;Port 3 Data Register
ddr3 = 0x0d 			;Port 3 Data Direction Register (0=input, 1=output)
pdr4 = 0x0e 			;Port 4 Data Register
ram = 0x80 				;Start address of RAM

start:
	mov ddr3, #0x0ff 	;DDR3 = all outputs

	;Put a string at the start of RAM to make it easy to identify

	mov ram+0x00, #0x52 	;"RAMSTART"
	mov ram+0x01, #0x41
	mov ram+0x02, #0x4d
	mov ram+0x03, #0x53
	mov ram+0x04, #0x54
	mov ram+0x05, #0x41
	mov ram+0x06, #0x52
	mov ram+0x07, #0x54

	;Load RAM with a program to dump all memory out P30-P37, strobe on P40

	mov ram+0x08, #0x07		;0080 07 	   mov a, @ep 	;A = data at address EP

	mov ram+0x09, #0x45 	;0081 45 0C    mov pdr3, a  ;Put it on Port 3
	mov ram+0x0a, #0x0c

	mov ram+0x0b, #0x85 	;0083 85 0E 00 mov pdr4, #0
	mov ram+0x0c, #0x0e
	mov ram+0x0d, #0

	mov ram+0x0e, #0x85 	;0086 85 0E 01 mov pdr4, #1
	mov ram+0x0f, #0x0e
	mov ram+0x10, #1

	mov ram+0x11, #0xf7 	;0089 F7       xchw a, ep 	;A=EP

	mov ram+0x12, #0xc0 	;0090 C0       incw a 		;Increment A, set Z

	mov ram+0x13, #0xf7 	;0091 F7       xchw a, ep 	;EP=A

	mov ram+0x14, #0x21  	;0092 21 00 88 jmp 0x88
	mov ram+0x15, #0x00
	mov ram+0x16, #0x88

	;Run the dumping code in RAM

	movw a, #0
    xchw a, ep 			   ;EP = 0 (start address for dumping)
	jmp ram

	;String to make the external ROM easy to identify
	.byte 0x45, 0x58, 0x54, 0x52, 0x4f, 0x4d  ;"EXTROM"

	.org 0xfffd
	.byte 0x01 			;mode byte
	.word start			;reset vector
