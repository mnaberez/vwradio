all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff rhapsody.sha1 out.sha1

out.bin:
	as740 -l -o+out rhapsody.asm
	aslink -i out
	srec_cat out.hex -intel -offset -0x4000 -o out.bin -binary

clean:
	rm -f out.*
