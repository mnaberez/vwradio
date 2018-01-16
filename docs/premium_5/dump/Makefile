rom.hex: rom.bin
	srec_cat rom.bin -binary -o rom.hex -intel -address-length=2 -line-length=44 -crlf

rom.bin: rom.p
	p2bin rom.p
	python3 pad0xff.py rom.bin 60

rom.p: rom.asm
	asw -L rom.asm
	plist rom.p

clean:
	rm -f rom.p rom.bin rom.hex rom.lst

all: clean rom.hex
