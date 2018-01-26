'''
Extract individual uPD78F831Y memory images from a logic analyzer CSV export.
Reads <file.csv> and writes individual binary images to <output directory>.

The optional <size> specifies the number of bytes to save from each image,
from the bottom of memory.  It defaults to 61440 (the entire flash area).

Format of the logic analyzer CSV export:
    Time[s],    D0, D1, D2, D3, D4, D5, D6, D7, /STROBE
    0.00000000,  1,  1,  0,  0,  0,  1,  1,  0, 1
    0.00001816,  1,  1,  0,  0,  0,  1,  1,  0, 0

Individual memory images are extracted by searching for the string "HELLO",
which must be present at address 0x0012 in each image.  Incomplete images
(less than the full 64K memory space) are ignored during extraction.

Usage: extract <file.csv> <output directory> [<size>]
'''

import csv
import os
import sys

def read_file(filename):
    '''Read logic analyzer CSV export and return a bytearray with all bytes'''
    data = bytearray()
    last_strobe = None
    with open(filename, 'r') as f:
        reader = csv.reader(f, skipinitialspace=True)
        next(reader, None) # skip header row
        for row in reader:
            strobe = int(row[9])
            if (last_strobe == 1) and (strobe == 0):
                data.append(int(''.join(reversed(row[1:9])), 2))
            last_strobe = strobe
    return data

def find_image_offsets(data):
    '''Find the starting offset of every 64K memory image in the data.'''

    hello = bytes(bytearray([
        0x13, 0x24, 0x00,           # EFE0 mov pm4, #0     ;port 4 = all bits output   (8 data bits)
        0x13, 0x25, 0x00,           # EFE3 mov pm5, #0     ;port 5 = all bits output   (/strobe on bit 0)
        0x0A, 0x05,                 # EFE6 set1 p5.0       ;/strobe = high
        0x87,                       # EFE8 mov a, [hl]     ;read byte from memory
        0x9B, 0x98, 0xB4,           # EFE9 br !0xb498      ;jump to "mov p4, a"; it jumps to next inst
        0x0B, 0x05,                 # EFEC clr1 p5.0       ;/strobe = low
        0x86,                       # EFEE incw hl         ;increment to next memory address
        0x9B, 0xaa, 0xB3,           # EFEF br !0xb3aa      ;jump to jump to loop
        ]))


    offsets = []
    index = 0
    while True:
        index = data.find(hello, index)
        if index == -1:
            break
        else:
            offset = index - 0xefe0  # subtract hello address to find address 0
            if offset >= 0:  # might be negative if start of capture
                offsets.append(offset)
            index += len(hello)
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
    '''Write the lower +size+ bytes of every image to files in the
       given directory.'''
    assert size in range(1, 0x10000+1), 'Bad size (must be 1-65536)'
    for i, image in enumerate(images):
        assert len(image) == 0x10000
        filename = os.path.join(directory, 'dump_%03d.bin' % (i))
        with open(filename, 'wb') as f:
            f.write(image[0:size])

def main():
    if len(sys.argv) < 3:
        sys.stderr.write("%s\n" % __doc__)
        sys.exit(1)

    csv_filename = sys.argv[1]
    output_directory = sys.argv[2]
    if len(sys.argv) == 4:
        size = int(sys.argv[3])
    else:
        size = 0xF000

    data = read_file(csv_filename)
    offsets = find_image_offsets(data)
    images = extract_64k_images(data, offsets)
    write_image_files(images, output_directory, size)

if __name__ == '__main__':
    main()
