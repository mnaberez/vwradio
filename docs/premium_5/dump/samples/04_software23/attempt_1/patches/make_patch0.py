with open('patch0.bin', 'wb') as f:
    i = 0
    while i < 0x02f0:
        f.write('\xff')
        i += 1

    while i < 0x98Dc:
        f.write('\x00')
        i += 1

    assert i == 0x98dc
    f.write('\x9b')
