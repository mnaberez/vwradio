PROJECT=kwp1281
SOURCES=$(wildcard *.c)
MMCU=atmega1284
F_CPU=20000000
ISPFLAGS=-c atmelice
CFLAGS=-mmcu=$(MMCU) -g -Wall -Os -std=c99 -DF_CPU=$(F_CPU)

$(PROJECT).hex: $(PROJECT).elf
	avr-objcopy -j .text -j .data -O ihex $(PROJECT).elf $(PROJECT).hex

$(PROJECT).elf: $(SOURCES)
	avr-gcc $(CFLAGS) -I. -o $(PROJECT).elf $(SOURCES)

program: $(PROJECT).hex
	avrdude $(ISPFLAGS) -p $(MMCU) -U lfuse:w:0xF7:m -U hfuse:w:0x92:m -U efuse:w:0xFF:m
	avrdude $(ISPFLAGS) -p $(MMCU) -U flash:w:$(PROJECT).hex

size: $(PROJECT).elf
	avr-size --mcu=$(MMCU) --format=avr $(PROJECT).elf

dump: $(PROJECT).elf
	avr-objdump -h -S -I. $(PROJECT).elf

clean:
	find . -depth -name '*.elf' -print -delete
	find . -depth -name '*.hex' -print -delete
	find . -depth -name '*.o'   -print -delete
	find . -depth -name '*.pyc' -print -delete

all: clean $(PROJECT).hex program
