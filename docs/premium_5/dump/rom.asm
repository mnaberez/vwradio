    cpu 78070       ;actually 78f0831y but not supported by assembler

p4  equ 0ff04h      ;port register 4
p5  equ 0ff05h      ;port register 5
pm4 equ 0ff24h      ;port mode register 4 (0=output, 1=input)
pm5 equ 0ff25h      ;port mode register 5 (0=output, 1=input)

    org 0

    nop             ;these two nops are also the reset vector
    nop

    mov pm4, #0     ;port 4 = all bits output   (8 data bits)
    clr1 pm5.0      ;port 5 bit 0 = output      (/strobe)

loop:
    set1 p5.0       ;/strobe = high
    mov a, [hl]     ;read byte from memory
    mov p4, a       ;write it to the port
    clr1 p5.0       ;/strobe = low
    incw hl         ;increment to next memory address
    br loop         ;loop forever
