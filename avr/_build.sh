#!/bin/bash
set -e
avr-gcc -g -Os -mmcu=atmega1284p -c led.c
avr-gcc -g -mmcu=atmega1284p -o led.elf led.o
avr-objcopy -j .text -j .data -O ihex led.elf led.hex
