'''
Extract MB89623R internal ROM images from a logic analyzer dump.

Usage: extract <file.csv> <output directory>
'''

import os
import sys

def read_file(filename):
    '''Read logic analyzer CSV export and return a bytearray with all bytes'''
    with open(sys.argv[1]) as f:
        lines = f.readlines()
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
    return data

def find_image_offsets(data):
    '''Find the starting offset of every 64K memory image in the data.'''
    ramstart = b'RAMSTART'
    offsets = []
    index = 0
    while True:
        index = data.find(ramstart, index)
        if index == -1:
            break
        else:
            offset = index - 0x80  # ram is address 0x80, image starts from 0
            if offset >= 0:  # might be negative if start of capture
                offsets.append(offset)
                index = index + len(ramstart)
    return offsets

def extract_images(data, offsets):
    '''Extract a bytearray for each 64K memory image at the given offsets'''
    images = []
    for offset in offsets:
        image = data[offset:offset+0x10000]
        if len(image) == 0x10000:  # might be less than 64k if end of capture
            images.append(image)
    return images

def write_8k_rom_files(images, directory):
    '''Write the 8K rom area (0xE000-0xFFFF) from every image to disk'''
    for i, image in enumerate(images):
        filename = os.path.join(sys.argv[2], 'rom_%03d.bin' % i)
        with open(filename, 'wb') as f:
            f.write(image[0xe000:])

def main():
    if len(sys.argv) != 3:
        sys.stderr.write("%s\n" % __doc__)
        sys.exit(1)
    data = read_file(sys.argv[1])
    offsets = find_image_offsets(data)
    images = extract_images(data, offsets)
    write_8k_rom_files(images, sys.argv[2])

if __name__ == '__main__':
    main()
