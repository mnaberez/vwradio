PYTHON=python3

all: clean out.hex diff

diff: out.bin
	$(PYTHON) checksum.py compare out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff software23.sha1 out.sha1

out.hex: out.bin
	srec_cat out.bin -binary -o out.hex -intel -address-length=2 -line-length=76 -crlf

out.bin:
	as78k0 -l -o+out software23.asm
	aslink -i out
	srec_cat out.hex -intel -fill 0xff 0x0000 0xf000 -o out.bin -binary
	rm out.hlr out.rel

clean:
	rm -f out.*
