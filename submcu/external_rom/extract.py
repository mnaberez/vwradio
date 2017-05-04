'''
Extract individual MB89623R memory images from a logic analyzer dump.
Reads <file.csv> and writes individual binary images to <output directory>.

The optional <size> specifies the number of bytes to save from each image,
from the top of memory.  It defaults to 65536 (the entire 64K of memory).  To
extract only the 8K ROM at 0xE000-0xFFFF, give a size of 8192.

Usage: extract <file.csv> <output directory> [<size>]
'''

import os
import sys

def read_file(filename):
    '''Read logic analyzer CSV export and return a bytearray with all bytes'''
    with open(filename) as f:
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

def extract_64k_images(data, offsets):
    '''Extract a bytearray for each 64K memory image at the given offsets'''
    images = []
    for offset in offsets:
        image = data[offset:offset+0x10000]
        if len(image) == 0x10000:  # might be less than 64k if end of capture
            images.append(image)
    return images

def write_image_files(images, directory, size):
    '''Write the upper +size+ bytes of every image to files in the
       given directory.'''
    assert size in range(1, 0x10000+1), 'Bad size (must be 1-65536)'
    offset = 0x10000 - size
    for i, image in enumerate(images):
        assert len(image) == 0x10000
        filename = os.path.join(directory, 'dump_%04x_%03d.bin' % (offset, i))
        with open(filename, 'wb') as f:
            f.write(image[offset:])

def main():
    if len(sys.argv) < 3:
        sys.stderr.write("%s\n" % __doc__)
        sys.exit(1)

    csv_filename = sys.argv[1]
    output_directory = sys.argv[2]
    if len(sys.argv) == 4:
        size = int(sys.argv[3])
    else:
        size = 0x10000

    data = read_file(csv_filename)
    offsets = find_image_offsets(data)
    images = extract_64k_images(data, offsets)
    write_image_files(images, output_directory, size)

if __name__ == '__main__':
    main()
