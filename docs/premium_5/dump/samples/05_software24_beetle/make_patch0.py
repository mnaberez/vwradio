import os

with open('patch0.bin', 'wb') as f:
    i = 0
    while i < 0x300:
        f.write(b'\xff')
        i +=1

    assert i == 0x300
    while i < 0xb3aa:
        f.write(b'\x00')
        i += 1

    assert i == 0xb3aa
    data = [0x9b, 0xe0, 0xef]       # B3AA br !EFE0
    f.write(bytearray(data))
    i += len(data)

    assert i == 0xb3ad
    while i < 0xb498:
        f.write(b'\x00')
        i += 1

    assert i == 0xb498
    data = [0x7B, 0x1E,             # B498 di
            0xF2, 0x04,             # B49A mov p4, a
            0x9B, 0xEC, 0xEF        # B49C br !0xEFEC
            ]
    f.write(bytearray(data))
    i += len(data)

    while i < 0xefe0:
        f.write(b'\x00')
        i += 1

    assert i == 0xefe0, hex(i)
    data = [
        0x13, 0x24, 0x00,           # EFE0 mov pm4, #0     ;port 4 = all bits output   (8 data bits)
        0x13, 0x25, 0x00,           # EFE3 mov pm5, #0     ;port 5 = all bits output   (/strobe on bit 0)
        0x0A, 0x05,                 # EFE6 set1 p5.0       ;/strobe = high
        0x87,                       # EFE8 mov a, [hl]     ;read byte from memory
        0x9B, 0x98, 0xB4,           # EFE9 br !0xb498      ;jump to "mov p4, a"; it jumps to next inst
        0x0B, 0x05,                 # EFEC clr1 p5.0       ;/strobe = low
        0x86,                       # EFEE incw hl         ;increment to next memory address
        0x9B, 0xaa, 0xB3,           # EFEF br !0xb3aa      ;jump to jump to loop
        ]
    f.write(bytearray(data))
    i += len(data)

    assert i == 0xeff2, hex(i)

os.system('srec_cat patch0.bin -binary -o patch0.hex -intel -address-length=2 -line-length=44 -crlf')
