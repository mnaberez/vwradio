all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff gamma5.sha1 out.sha1

out.bin:
	as740 -l -o+out gamma5.asm
	aslink -i out
	srec_cat out.hex -intel -offset -0x2000 -o out.bin -binary

clean:
	rm -f out.*
