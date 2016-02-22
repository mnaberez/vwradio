PROJECT=main
SOURCES=$(PROJECT).c
MMCU=atmega1284p
ISP=avrisp2

CFLAGS=-mmcu=$(MMCU) -Wall -Os -std=c99

$(PROJECT).hex: $(PROJECT).elf
	avr-objcopy -j .text -j .data -O ihex $(PROJECT).elf $(PROJECT).hex

$(PROJECT).elf: $(SOURCES)
	avr-gcc $(CFLAGS) -I./ -o $(PROJECT).elf $(SOURCES)

program: $(PROJECT).hex
	avrdude -c $(ISP) -p $(MMCU) -U flash:w:$(PROJECT).hex

dump: $(PROJECT).elf
	avr-objdump -h -S $(PROJECT).elf

clean:
	rm -f *.elf
	rm -f *.hex
	rm -f *.o

test:
	python scripts/serialtest.py

_sleep:
	sleep 0.5

all: clean $(PROJECT).hex program _sleep test
