all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff gamma5.sha1 out.sha1

out.bin:
	cp -f gamma5.asm out.asm
	as740 -l -o out.asm
	rm -f out.asm
	aslink -i out
	srec_cat out.ihx -intel -offset -0x2000 -o out.bin -binary

clean:
	rm -f out.*
