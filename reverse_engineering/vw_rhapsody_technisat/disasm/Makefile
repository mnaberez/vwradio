all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff rhapsody.sha1 out.sha1

out.bin:
	cp -f rhapsody.asm out.asm
	as740 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -offset -0x4000 -o out.bin -binary

clean:
	rm -f out.*
