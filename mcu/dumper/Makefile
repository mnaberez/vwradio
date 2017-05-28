rom.hex: rom.bin
	srec_cat rom.bin -binary -o rom.hex -intel -address-length=2 -line-length=44 -crlf

rom.bin: rom.lst
	python ../scripts/lst2bin.py rom.lst rom.bin

rom.lst: rom.asm
	asf2mc8 -l rom.asm
	rm -f rom.hlr

clean:
	rm -f rom.bin rom.hex rom.hlr rom.lst rom.lst

program:
	dprom /dev/tty.usbserial-FT0G8F41 rom.hex

all: clean rom.hex program
