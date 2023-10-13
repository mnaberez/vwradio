PROJECT=vwvolume
MMCU=atmega1284
ISPFLAGS=-c atmelice

$(PROJECT).hex: main.asm
	asavr -l -o+$(PROJECT) main.asm
	aslink -i $(PROJECT)
	srec_cat $(PROJECT).hex -intel -o $(PROJECT).bin -binary
	rm $(PROJECT).hlr $(PROJECT).rel

program: $(PROJECT).hex
	avrdude $(ISPFLAGS) -p $(MMCU) -U lfuse:w:0xF7:m -U hfuse:w:0x92:m -U efuse:w:0xFC:m
	avrdude $(ISPFLAGS) -p $(MMCU) -U flash:w:$(PROJECT).hex

clean:
	rm -f *.hex
	rm -f *.lst

all: clean $(PROJECT).hex program
