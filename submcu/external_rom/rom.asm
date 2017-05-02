	.F2MC8L
	.area CODE1 (ABS)
	.org 0xe000

pdr2 = 0x04 			;Port 2 Data Register (port is output only)
pdr3 = 0x0c 			;Port 3 Data Register
ddr3 = 0x0d 			;Port 3 Data Direction Register (0=input, 1=output)
ram = 0x80 				;Start address of RAM

start:
	mov ddr3, #0xff 	;DDR3 = all outputs

	mov a, #0
    xchw a, ep 			;EP = 0

	;Load RAM with a program to dump memory out Port 3
	mov ram+0x00, #0x07		;0080 07 	   mov a, @ep 	;A = data at address EP
	mov ram+0x01, #0x45 	;0081 45 0C    mov pdr3, a  ;Put it on Port 3
	mov ram+0x02, #0x0c
	mov ram+0x03, #0xf7 	;0083 F7       xchw a, ep 	;A=EP
	mov ram+0x04, #0xc0 	;0084 C0       incw a 		;Increment A, set Z
	mov ram+0x05, #0xf7 	;0085 F7       xchw a, ep 	;EP=A
	mov ram+0x06, #0x21  	;0086 21 00 80 jmp 0x80
	mov ram+0x07, #0x00
	mov ram+0x08, #0x80

	;Jump to the code we just wrote into RAM
	jmp ram

	;Something easy to spot if dumping the external ROM
	.byte 77, 73, 75, 69 	;"MIKE"

	.org 0xfffd
	.byte 0x01 			;mode byte
	.word start			;reset vector
