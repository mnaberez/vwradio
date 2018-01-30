import os

with open('patch2.bin', 'wb') as f:
    for address in range(0xf000):
        if address < 0x02f0:
            f.write(b'\x00')
        else:
            f.write(b'\xff')

os.system('srec_cat patch2.bin -binary -o patch2.hex -intel -address-length=2 -line-length=44 -crlf')