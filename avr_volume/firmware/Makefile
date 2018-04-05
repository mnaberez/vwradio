PROJECT=vwvolume
MMCU=atmega1284
ISPFLAGS=-c atmelice

$(PROJECT).hex: main.asm
	# requires patched avra for atmega1284 support
	# https://github.com/mnaberez/avra
	avra -l $(PROJECT).lst main.asm
	mv main.hex $(PROJECT).hex
	rm -f *.cof
	rm -f *.obj
	rm -f *.eep.hex

program: $(PROJECT).hex
	avrdude $(ISPFLAGS) -p $(MMCU) -U lfuse:w:0xF7:m -U hfuse:w:0x92:m -U efuse:w:0xFC:m
	avrdude $(ISPFLAGS) -p $(MMCU) -U flash:w:$(PROJECT).hex

clean:
	rm -f *.hex
	rm -f *.lst

all: clean $(PROJECT).hex program
