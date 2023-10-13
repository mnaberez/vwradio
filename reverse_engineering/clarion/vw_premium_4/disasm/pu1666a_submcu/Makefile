all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff pu1666a_submcu.sha1 out.sha1

out.bin:
	asf2mc8 -l -o+out pu1666a_submcu.asm
	aslink -i out
	srec_cat out.hex -intel -offset -0xe000 -o out.bin -binary

clean:
	rm -f out.*
