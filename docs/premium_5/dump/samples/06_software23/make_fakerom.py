import os

with open('fakerom.bin', 'wb') as f:
    i = 0
    while i < 0x2a38:
        f.write(b'\x00')
        i += 1

    assert i == 0x2a38
    f.write(b'\xff\xf1\xf0')
    i += 3

    assert i == 0x2a3b
    while i < 0xb497:
        f.write(b'\x00')
        i += 1

    assert i == 0xb497
    while i < 0xb49f:
        f.write(b'\xff')
        i += 1

    assert i == 0xb49f
    while i < 0xb502:
        f.write(b'\x00')
        i += 1

    assert i == 0xb502
    while i < 0xb506:
        f.write(b'\xff')
        i += 1

    assert i == 0xb506
    while i < 0xefe0:
        f.write(b'\x00')
        i += 1

    assert i == 0xefe0
    while i < 0xeffd:
        f.write(b'\xbf')
        i += 1

    assert i == 0xeffd
    f.write(b'\x00\x00\x00')
    i += 3

    assert i == 0xf000

os.system('srec_cat fakerom.bin -binary -o fakerom.hex -intel -address-length=2 -line-length=44 -crlf')
