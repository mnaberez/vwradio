all: clean out.bin

out.bin:
	cp -f remote.asm out.asm
	as78k0 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -fill 0xff 0xdc64 0xf000 -o out.bin -binary
	python ../disasm/checksum.py update out.bin

clean:
	rm -f out.*
