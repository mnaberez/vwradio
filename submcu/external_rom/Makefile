rom.hex: rom.bin
	srec_cat rom.bin -binary -o rom.hex -intel -address-length=2 -line-length=44 -crlf

rom.bin: rom.lst
	python lst2bin.py rom.lst rom.bin

rom.lst: rom.asm
	asf2mc8 -l rom.asm

clean:
	rm -f *.bin
	rm -f *.hex
	rm -f *.lst

program:
	python dprom2.py /dev/tty.usbserial-FT0G8F41 rom.hex

all: clean rom.hex program
