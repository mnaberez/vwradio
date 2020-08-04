all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff pu1666a_mainmcu.sha1 out.sha1

out.bin:
	cp -f pu1666a_mainmcu.asm out.asm
	asf2mc8 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -offset -0x8000 -o out.bin -binary

clean:
	rm -f out.*
