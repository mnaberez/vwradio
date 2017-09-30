#!/usr/bin/env python3
'''
M62419FP Logic Analyzer Capture Decoder

Reads a CSV export from a logic analyzer containing SPI clock and data,
decodes it into 14-bit packets, then parses the packets into human-readable
descriptions of M62419FP commands.

Usage: %s <file.csv|file.csv.gz>
'''

import csv
import gzip
import sys

att1_to_db = (-100,  -20, -52, None, -68,   -4, -36, None,  # -100 = infinity
               -76,  -12, -44, None, -60, None, -28, None,  # None = undefined
               -80,  -16, -48, None, -64,    0, -32, None,
               -72,   -8, -40, None, -56, None, -24, None)

att2_to_db = (-3, -1, -2, 0)

input_to_name = ('D (CD)', 'B (FM)', 'C (TAPE)', 'A (AM)')

fadesel_to_name = ('FRNT', 'REAR')

tone_to_db = (None, -2, -10, 6, None, 2, -6, 10,  # None = undefined
              None,  0,  -8, 8,  -12, 4, -4, 12)

fade_to_db = (-100, -10, -20, -3, -45, -6, -14, -1,  # -100 = infinity
               -60,  -8, -16, -2, -30, -4, -12,  0)

def read_file(filename):
    opener = gzip.open if filename.endswith('.gz') else open
    with opener(filename, 'r') as f:
        headings = [ col.strip() for col in f.next().split(',') ]
        reader = csv.DictReader(f, headings)

        command, bit = 0, 0
        last_clock = None
        for row in reader:
            data, clock = int(row['DAT']), int(row['CLK'])

            if (last_clock == 0) and (clock == 1):
                command = command << 1
                command = command | data
                bit += 1
                if bit == 14:
                    display_command(command)
                    command, bit = 0, 0
            last_clock = clock

def display_command(command):
    b = bin(command)[2:] # skip "0b" prefix
    b = b.rjust(16, '0') # pad leading zeros
    b = b[2:]            # only 14 bits, not 16
    print('DATA 0x%04x %s' % (command, b))

    data_select = int(b[13])
    if data_select == 0:  # volume/loudness/input selector
        if int(b[1]) == 1: # single channel
            chnum = int(b[0])
            chan = "CH%d/%s" % (chnum, ('R', 'L')[chnum])
        else: # both channels
            chan = "BOTH"

        att1_code = int(b[2:7], 2)
        att1_db = att1_to_db[att1_code]

        att2_code = int(b[7:9], 2)
        att2_db = att2_to_db[att2_code]

        att_sum_db = att1_db + att2_db

        fmt = ("SEL:VOL/LOUD/INP\t%s\t"
               "ATT1 = %d dB\tATT2 = %d dB\tSUM = %d dB")
        print(fmt % (chan, att1_db, att2_db, att_sum_db))

        loudness = int(b[9])
        print("\t\t\t\tLOUDNESS = %d" % loudness)

        input_selected = input_to_name[int(b[10:12], 2)]
        print("\t\t\t\tINPUT = %s" % input_selected)
    else:  # bass/treble/fade
        fadesel = fadesel_to_name[int(b[12])] # 0=front, 1=rear

        fade_code = int(b[8:12], 2)
        fade_db = fade_to_db[fade_code]

        bass_code = int(b[0:4], 2)
        bass_db = tone_to_db[bass_code]

        treb_code = int(b[4:8], 2)
        treb_db = tone_to_db[treb_code]

        fmt = ("SEL:BAS/TREB/FAD\tFADESEL = %s\tFADE = %s dB\t"
               "BASS = %s dB\tTREB = %s dB")
        print(fmt % (fadesel, fade_db, bass_db, treb_db))
    print('')

if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write((__doc__.strip() + '\n') % sys.argv[0])
        sys.exit(1)
    read_file(sys.argv[1])
