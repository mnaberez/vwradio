import sys

msgs = []
with open('combined.bin', 'rb') as f:
    f.read(0x63AC)
    assert f.tell() == 0x63ac
    while 1:
        pos = f.tell()

        if pos == 0x6535:
            f.seek(0x6587)
            pos = f.tell()

        if pos >= 0x67be:
            break

        c = f.read(1)
        if pos == 0x6743:
            size = 12
        elif pos == 0x63be:
            size = 12
        elif pos == 0x674e:
            size = 13
        else:
            size = bytearray(c)[0]
        data = f.read(size)
        msgs.append(data.decode('utf-8'))
        #print("%04x: %r" % (pos, data))

i = 0
for msg in msgs:
    s = repr(msg).ljust(20)
    sys.stdout.write(s)
    i += 1
    if i == 4:
        sys.stdout.write('\n')
        i = 0
sys.stdout.write('\n')

