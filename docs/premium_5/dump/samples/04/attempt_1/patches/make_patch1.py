with open('patch1.bin', 'wb') as f:
    i = 0
    while i < 0xB497:
        f.write(b'\xff')
        i += 1

    assert i == 0xB497, hex(i)
    data = bytearray([
        0xf2, 0x04,
        0x9b, 0xec, 0xef,
    ])
    f.write(data)
    i += len(data)

    assert i == 0xb49c, hex(i)
    while i < 0xB502:
        f.write(b'\x00')
        i += 1

    assert i == 0xb502
    data = bytearray([
        0x9b, 0xe0, 0xef,
    ])
    f.write(data)
    i += len(data)

    assert i == 0xb505
    while i < 0xefe0:
        f.write(b'\x00')
        i += 1

    assert i == 0xefe0
    data = bytearray([
        0x13, 0x24, 0x00,
        0x13, 0x25, 0x00,
        0x0a, 0x05,
        0x87,
        0x9b, 0x97, 0xb4,
        0x0b, 0x05,
        0x86,
        0x9b, 0x02, 0xb5
    ])
    f.write(data)
    i += len(data)

    assert i == 0xeff2
    while i < 0xf000:
        f.write(b'\xff')
        i += 1

    assert i == 0xf000
