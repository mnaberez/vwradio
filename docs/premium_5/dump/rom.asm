    cpu 78070       ;actually 78f0831y but not supported by assembler

p2  equ 0ff02h      ;port register 2
p4  equ 0ff04h      ;port register 4
pm2 equ 0ff22h      ;port mode register 2 (0=output, 1=input)
pm4 equ 0ff24h      ;port mode register 4 (0=output, 1=input)

    org 0

    nop             ;these two nops are also the reset vector
    nop

    mov pm2, #0     ;port 2 = all bits output   (8 data bits)
    clr1 pm4.0      ;port 4 bit 0 = output      (/strobe)

loop:
    set1 p4.0       ;/strobe = high
    mov a, [hl]     ;read byte from memory
    mov p2, a       ;write it to the port
    clr1 p4.0       ;/strobe = low
    incw hl         ;increment to next memory address
    br loop         ;loop forever
