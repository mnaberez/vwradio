	.F2MC8L
	.area CODE1 (ABS)
	.org 0xe000

start:
	mov a, 0x42
	jmp start

	.org 0xfffd			;mode byte
	.byte 0x01

	.org 0xfffe 		;reset vector
	.word start

