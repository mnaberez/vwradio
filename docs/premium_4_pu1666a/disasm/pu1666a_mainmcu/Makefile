diff: out.bin
	diff out.bin pu1666a_mainmcu.bin

out.bin: out.lst
	python ../lst2bin.py out.lst out.bin

out.lst: pu1666a_mainmcu.asm
	asf2mc8 -l pu1666a_mainmcu.asm
	mv pu1666a_mainmcu.lst out.lst
	rm -f out.hlr

clean:
	rm -f out.*

all: clean out.bin diff

