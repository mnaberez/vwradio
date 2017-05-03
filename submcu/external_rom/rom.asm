;MB89623R Dumper
;
;This program dumps every byte of the MB89623R memory space (0x0000-0xFFFF) out
;on P30-P37, strobing P40 low after each byte.  P30-P37 are normal outputs but
;P40 is open drain and needs a 47K pull-up to Vcc.  Dumping wraps around memory
;and continues forever.  The string "RAMSTART" is written at the start of RAM
;(0x0080) to make it easy to separate the dumps.
;
;Load this program into an external ROM (MOD0=Vcc, MOD1=Vss).  On reset, it
;will write the dumping code to RAM and then jump it.  While it is running,
;change MOD0 to Vss.  This selects the internal ROM mode.  The internal ROM
;will replace the external ROM in the memory map (0xE000-0xFFFF).  The dumping
;code running from RAM will dump the internal ROM.
;

pdr3 = 0x000c 				;Port 3 Data Register
ddr3 = 0x000d 				;Port 3 Data Direction Register (0=input, 1=output)
pdr4 = 0x000e 				;Port 4 Data Register (no DDR for Port 4)
ram  = 0x0080				;Start address of RAM

	.F2MC8L
	.area CODE1 (ABS)
	.org 0xe000

reset:
	;Put a string at the start of RAM to make it easy to identify

	mov ram+0x00, #0x52		;"RAMSTART"
	mov ram+0x01, #0x41
	mov ram+0x02, #0x4d
	mov ram+0x03, #0x53
	mov ram+0x04, #0x54
	mov ram+0x05, #0x41
	mov ram+0x06, #0x52
	mov ram+0x07, #0x54

	;Load RAM with code to dump all memory out on P30-P37, with /STROBE on P40

	mov ram+0x08, #0x07		;07 	  mov a, @ep	;A = byte at address EP
	mov ram+0x09, #0x45 	;45 0c    mov pdr3, a  	;Put byte on P30-P37
	mov ram+0x0a, #0x0c
	mov ram+0x0b, #0x85 	;85 0e 00 mov pdr4, #0  ;P40 = Low (/STROBE)
	mov ram+0x0c, #0x0e
	mov ram+0x0d, #0x00
	mov ram+0x0e, #0x85 	;85 0e 01 mov pdr4, #1 	;P40 = High (/STROBE)
	mov ram+0x0f, #0x0e
	mov ram+0x10, #0x01
	mov ram+0x11, #0xf7 	;f7       xchw a, ep 	;A=EP
	mov ram+0x12, #0xc0 	;c0       incw a 		;Increment A, set Z
	mov ram+0x13, #0xf7 	;f7       xchw a, ep 	;EP=A
	mov ram+0x14, #0x21  	;21 00 88 jmp 0x0088
	mov ram+0x15, #0x00
	mov ram+0x16, #0x88

	;Run the dumping code in RAM

	mov ddr3, #0xff 		;P30-P37 = all outputs (no setup needed for P40)
	movw a, #0
    xchw a, ep 			    ;EP = 0 (start address for dumping)
	jmp ram

	.ascii "EXTROM" 		;String to make the external ROM easy to identify

	.org 0xfffd
	.byte 0x01 				;mode byte
	.word reset				;reset vector
