;F2MC-8L Dumper
;
;This program dumps every byte of the memory space (0x0000-0xFFFF) out on
;P30-P37, strobing P40 low after each byte.  It has been used to dump the
;internal ROM on the MB89623R, MB89625R, and MB89677AR.  P30-P37 are normal
;outputs.  P40 is open drain on the MB8962x and needs a 47K pull-up to Vcc.
;P40 is a normal output on MB89677AR.  Dumping wraps around memory and
;continues forever.  The string "RAMSTART" is written at the start of RAM
;(0x0080) to make it easy to separate the dumps.
;
;Load this program into an external ROM (MOD0=Vcc, MOD1=Vss) at 0xE000.  On
;reset, it will write the dumping code to RAM and then jump it.  While it is
;running, change MOD0 to Vss.  This selects the internal ROM mode.  The
;internal ROM will replace the external ROM in the memory map.  The dumping
;code running from RAM will dump the internal ROM.
;

sycc = 0x0007 				;System Clock Control Register (MB8967x only)
pdr3 = 0x000c 				;Port 3 Data Register
ddr3 = 0x000d 				;Port 3 Data Direction Register
pdr4 = 0x000e 				;Port 4 Data Register
ddr4 = 0x000f 				;Port 4 Data Direction Register (MB8967x only)
ram  = 0x0080				;Start address of RAM

	.define mb8967x  		;Comment this line out if MCU is not MB8967x

	.F2MC8L
	.area CODE1 (ABS)
	.org 0xe000

reset:
	;Initialize hardware registers

	.ifdef mb8967x
	mov sycc, #0x17 		;Set clock frequency to fastest
	mov ddr4, #0x01 		;Set P40 as output
	.endif

	mov ddr3, #0xff 		;Set P30-P37 as outputs

	;Write "RAMSTART" string at the start of RAM to make it easy to identify

	mov ram+0x00, #'R
	mov ram+0x01, #'A
	mov ram+0x02, #'M
	mov ram+0x03, #'S
	mov ram+0x04, #'T
	mov ram+0x05, #'A
	mov ram+0x06, #'R
	mov ram+0x07, #'T

	;Write code into RAM to dump all memory out P30-P37 with /STROBE on P40

	mov ram+0x08, #0x06		;06 00     mov a, @ix+0  ;A = byte at address IX
	mov ram+0x09, #0x00
	mov ram+0x0a, #0x45  	;45 0c	   mov pdr3, a 	 ;Put byte on P30-P37
	mov ram+0x0b, #0x0c
	mov ram+0x0c, #0x85 	;85 0e 00  mov pdr4, #0  ;P40 = Low (/STROBE)
	mov ram+0x0d, #0x0e
	mov ram+0x0e, #0x00
	mov ram+0x0f, #0x85 	;85 0e 01  mov pdr4, #1  ;P40 = High (/STROBE)
	mov ram+0x10, #0x0e
	mov ram+0x11, #0x01
	mov ram+0x12, #0xc2 	;c2 	   incw ix
	mov ram+0x13, #0x21 	;21 00 88  jmp ram+0x08
	mov ram+0x14, #0x00
	mov ram+0x15, #0x88

	;Start dumping

	movw ix, #0 			;IX = 0 (start address for dumping)
	jmp ram+0x08			;Jump to dumping code in RAM

	.ascii "EXTERNALROM"	;String to make the external ROM easy to identify

	.org 0xfffd
	.byte 0x01 				;Mode byte
	.word reset				;Reset vector
