#!/bin/bash
set -e
avr-gcc -g -Os -mmcu=atmega1284p -c main.c
avr-gcc -g -mmcu=atmega1284p -o main.elf main.o
avr-objcopy -j .text -j .data -O ihex main.elf main.hex
