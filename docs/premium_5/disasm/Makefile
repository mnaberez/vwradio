all: clean out.bin diff

diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff software23.sha1 out.sha1

out.bin: out.hex
	srec_cat out.hex -intel -o out.bin -binary

out.hex: out.lmf
	oc78k0 out.lmf

out.lmf: out.prn
	lk78k0 out.rel

out.prn:
	ra78k0 -cf0831y -oout.rel -pout.prn software23.asm

list: out.prn
	cat out.prn

clean:
	rm -f out.*
