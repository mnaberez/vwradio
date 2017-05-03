import os
import sys

with open(sys.argv[1]) as f:
    lines = f.readlines()

# make a bytearray with all the bytes collected by the analyzer
data = bytearray()
last_line_cols = []
for i, line in enumerate(lines):
    if i == 0:  # ignore header line
        continue
    cols = [s.strip() for s in line.split(', ')]
    if (i > 1) and (last_line_cols[-1] == '1') and (cols[-1] == '0'):
        binstring = ''.join(reversed(cols[1:9]))
        value = int(binstring, 2)
        data.append(value)
    last_line_cols = cols

# find the start index of every 64K image in the bytearray
start_indexes = []
index = 0
while True:
    index = data.find(b'RAMSTART', index)
    if index == -1:
        break
    else:
        start_index = index - 0x80  # ram is address 0x80, start from 0
        if start_index >= 0:  # might be negative if start of capture
            start_indexes.append(start_index)
            index = index + len(b'RAMSTART')

# extract the data for every 64K image
images = []
for start_index in start_indexes:
    image = data[start_index:start_index+0x10000]
    if len(image) == 0x10000:  # might be less than 64k if end of capture
        images.append(image)

# write the 8K rom area (0xE000-0xFFFF) from every image to disk
for i, image in enumerate(images):
    filename = os.path.join(sys.argv[2], 'rom_%03d.bin' % i)
    with open(filename, 'wb') as f:
        f.write(image[0xe000:])
