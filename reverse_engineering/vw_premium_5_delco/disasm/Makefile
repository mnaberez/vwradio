all: clean out.bin diff

diff: out.bin
	python checksum.py out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff software23.sha1 out.sha1

out.bin:
	cp -f software23.asm out.asm
	as78k0 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -o out.bin -binary

clean:
	rm -f out.*
