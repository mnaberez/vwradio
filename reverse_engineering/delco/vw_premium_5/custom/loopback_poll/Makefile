all: clean out.hex

out.hex: out.bin
	srec_cat out.bin -binary -o out.hex -intel -address-length=2 -line-length=76 -crlf

out.bin:
	cp -f loopback_poll.asm out.asm
	as78k0 -l -o out.asm
	rm -f out.asm
	aslink out -i
	srec_cat out.ihx -intel -fill 0xff 0x0000 0xf000 -o out.bin -binary
	rm out.hlr out.ihx out.rel

clean:
	rm -f out.*
