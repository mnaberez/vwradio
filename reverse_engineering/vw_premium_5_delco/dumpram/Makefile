all: clean out.bin

out.bin:
	cp -f dumpram23.asm out.asm
	as78k0 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -o out.bin -binary

clean:
	rm -f out.*
