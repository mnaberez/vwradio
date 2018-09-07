diff: out.bin
	openssl sha1 out.bin | cut -d ' ' -f 2 > out.sha1
	diff rhapsody.sha1 out.sha1

out.bin: out.lst
	python lst2bin.py out.lst out.bin

out.lst: rhapsody.asm
	as740 -l rhapsody.asm
	mv rhapsody.lst out.lst
	rm -f out.hlr

clean:
	rm -f out.*

all: clean out.bin diff
