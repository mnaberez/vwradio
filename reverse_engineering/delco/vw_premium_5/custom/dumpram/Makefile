PYTHON=python3

all: clean out.hex

out.hex: out.bin
	srec_cat out.bin -binary -o out.hex -intel -address-length=2 -line-length=76 -crlf

out.bin:
	as78k0 -l -o+out dumpram23.asm
	aslink -i out
	srec_cat out.hex -intel -fill 0xff 0x0000 0xf000 -o out.bin -binary
	$(PYTHON) ../../disasm/checksum.py update out.bin
	rm out.hlr out.rel

clean:
	rm -f out.*
