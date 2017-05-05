rom.hex: rom.bin
	srec_cat rom.bin -binary -o rom.hex -intel -address-length=2 -line-length=44 -crlf

rom.bin: rom.rel
	python rel2bin.py rom.rel rom.bin

rom.rel: rom.asm
	asf2mc8 -l -o rom.asm
	rm -f rom.hlr

clean:
	rm -f rom.bin rom.hex rom.hlr rom.lst rom.rel

program:
	python dprom2.py /dev/tty.usbserial-FT0G8F41 rom.hex

all: clean rom.hex program
