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

att1_to_db = {0b10101: 0,
              0b00101: -4,
              0b11001: -8,
              0b01001: -12,
              0b10001: -16,
              0b00001: -20,
              0b11110: -24,
              0b01110: -28,
              0b10110: -32,
              0b00110: -36,
              0b11010: -40,
              0b01010: -44,
              0b10010: -48,
              0b00010: -52,
              0b11100: -56,
              0b01100: -60,
              0b10100: -64,
              0b00100: -68,
              0b11000: -72,
              0b01000: -76,
              0b10000: -80,
              0b00000: -9999} # infinity

att2_to_db = {0b11:  0,
              0b01: -1,
              0b10: -2,
              0b00: -3}

input_to_name = {0b11: 'A (AM)',
                 0b01: 'B (FM)',
                 0b10: 'C (TAPE?)',
                 0b00: 'D (CD)'}

fadesel_to_name = {0: 'FRNT',
                   1: 'REAR'}

fade_to_db = {0b1111: 0,
              0b0111: -1,
              0b1011: -2,
              0b0011: -3,
              0b1101: -4,
              0b0101: -6,
              0b1001: -8,
              0b0001: -10,
              0b1110: -12,
              0b0110: -14,
              0b1010: -16,
              0b0010: -20,
              0b1100: -30,
              0b0100: -45,
              0b1000: -60,
              0b0000: -9999} # infinity

tone_to_db = {0b1111: 12,
              0b0111: 10,
              0b1011: 8,
              0b0011: 6,
              0b1101: 4,
              0b0101: 2,
              0b1001: 0,
              0b0001: -2,
              0b1110: -4,
              0b0110: -6,
              0b1010: -8,
              0b0010: -10,
              0b1100: -12}

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
        chan = int(b[0])

        att1_code = int(b[2:7], 2)
        att1_db = att1_to_db[att1_code]

        att2_code = int(b[7:9], 2)
        att2_db = att2_to_db[int(b[7:9], 2)]

        att_sum_db = att1_db + att2_db

        fmt = ("SEL:VOL/LOUD/INP\tCH%s\t"
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
