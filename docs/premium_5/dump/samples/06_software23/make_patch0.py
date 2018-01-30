import os

with open('patch0.bin', 'wb') as f:
    i = 0
    while i < 0x0d00:
        f.write(b'\xff')
        i += 1

    assert i == 0x0d00
    while i < 0x2a38:
        f.write(b'\x00')
        i += 1

    # 2a38            9B      (FF -> 9B)
    # 2a39            F1      (F1 unchanged)
    # 2a3a            E0      (F0 -> E0)        Becomes BR 0xE0F1
    assert i == 0x2a38
    data = bytearray([0x9b, 0xf1, 0xe0])
    f.write(data)
    i += len(data)

    # 2a3b - B496     FF
    assert i == 0x2a3b
    while i < 0xb497:
        f.write(b'\xff')
        i += 1

    assert i == 0xb497
    data = bytearray([0x7b, 0x1e,           # B497   di
                      0xf2, 0x04,           # B499   mov p4, a
                      0x9b, 0xec, 0xef,     # B49B   br !0efech
                     ])
    f.write(data)
    i += len(data)

    while i < 0xb502:
        f.write(b'\x00')
        i += 1

    assert i == 0xb502
    data = bytearray([0x9b, 0xe0, 0xef])    # B502   br !0xefe0
    f.write(data)
    i += len(data)

    assert i == 0xb505
    while i < 0xe000:
        f.write(b'\xff')
        i += 1

    assert i == 0xe000
    while i < 0xefe0:
        f.write(b'\x00')
        i += 1

    assert i == 0xefe0, hex(i)
    data = [
        0x13, 0x24, 0x00,           # EFE0 mov pm4, #0     ;port 4 = all bits output   (8 data bits)
        0x13, 0x25, 0x00,           # EFE3 mov pm5, #0     ;port 5 = all bits output   (/strobe on bit 0)
        0x0A, 0x05,                 # EFE6 set1 p5.0       ;/strobe = high
        0x87,                       # EFE8 mov a, [hl]     ;read byte from memory
        0x9B, 0x97, 0xB4,           # EFE9 br !0xb497      ;jump to "mov p4, a"; it jumps to next inst
        0x0B, 0x05,                 # EFEC clr1 p5.0       ;/strobe = low
        0x86,                       # EFEE incw hl         ;increment to next memory address
        0x9B, 0x02, 0xB5,           # EFEF br !0xb502      ;jump to jump to loop
        ]
    f.write(bytearray(data))
    i += len(data)

    assert i == 0xeff2, hex(i)

os.system('srec_cat patch0.bin -binary -o patch0.hex -intel -address-length=2 -line-length=44 -crlf')
