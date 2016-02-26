PROJECT=vwradio
SOURCES=cmd.c faceplate.c leds.c main.c radio_spi.c radio_state.c uart.c updemu.c
MMCU=atmega1284p
ISP=avrisp2

CFLAGS=-mmcu=$(MMCU) -g -Wall -Os -std=c99

$(PROJECT).hex: $(PROJECT).elf
	avr-objcopy -j .text -j .data -O ihex $(PROJECT).elf $(PROJECT).hex

$(PROJECT).elf: $(SOURCES)
	avr-gcc $(CFLAGS) -I. -o $(PROJECT).elf $(SOURCES)

program: $(PROJECT).hex
	avrdude -c $(ISP) -p $(MMCU) -U flash:w:$(PROJECT).hex

size: $(PROJECT).elf
	avr-size --mcu=$(MMCU) --format=avr $(PROJECT).elf

dump: $(PROJECT).elf
	avr-objdump -h -S -I. $(PROJECT).elf

clean:
	find . -depth -name '*.elf' -print -delete
	find . -depth -name '*.hex' -print -delete
	find . -depth -name '*.o'   -print -delete
	find . -depth -name '*.pyc' -print -delete

test:
	python scripts/serialtest.py

_sleep:
	sleep 0.5

all: clean $(PROJECT).hex program _sleep test
