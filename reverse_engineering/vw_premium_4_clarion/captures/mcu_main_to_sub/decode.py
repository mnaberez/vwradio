import csv
import gzip
import struct
import sys

signed_char = lambda x: struct.unpack('b', x)[0]

class SubMCU(object):
    def __init__(self):
        pass

    # cmd, pict, screen, param 0, param 1, param 2
    def process(self, packet):
        sys.stdout.write(hexdump(packet) + " -> ")
        self.packet = packet
        self.screen_num = packet[2]
        self.message = bytearray(self.messages[self.screen_num])
        self._dispatch()
        sys.stdout.write(self.message.decode('utf-8'))
        sys.stdout.write("\n")

    def _dispatch(self):
        prefix = '_msg_%02x_' % self.screen_num
        for funcname in dir(self):
            if funcname.startswith(prefix):
                f = getattr(self, funcname)
                f()
                return
        raise NotImplementedError("0x%02x" % self.screen_num)

    def _msg_01_cd_tr(self):
        # Buffer:  'CD...TR....'
        # Example: 'CD 1 TR 03 '
        #
        # Param 0 High Nibble = Unused
        # Param 1 Low Nibble  = CD number
        # Param 1 Byte        = Track number
        # Param 2 Byte        = Unused
        pass

        # TODO finish me

        # 0x01: 'CD...TR....',
        # 0x02: 'CUE........',
        # 0x03: 'REV........',
        # 0x04: 'SCANCD.TR..',
        # 0x05: 'NO..CHANGER',
        # 0x06: 'NO..MAGAZIN',
        # 0x07: '....NO.DISC',
        # 0x08: 'CD...ERROR.',
        # 0x09: 'CD.........',
        # 0x0a: 'CD....MAX..',
        # 0x0b: 'CD....MIN..',
        # 0x0c: 'CHK.MAGAZIN',
        # 0x0d: 'CD..CD.ERR.',
        # 0x0e: 'CD...ERROR.',
        # 0x0f: 'CD...NO.CD.',

    def _msg_10_set_onvol_y(self):
        # Buffer:  'SET.ONVOL.Y'
        # Example: 'SET ONVOL Y'
        #
        # No params
        pass

    def _msg_11_set_onvol_n(self):
        # Buffer:  'SET.ONVOL.N'
        # Example: 'SET ONVOL N'
        #
        # No params
        pass

    def msg_12_set_onvol_(self):
        # TODO
        # 0x12: 'SET.ONVOL..',
        pass

    def msg_13_set_cdmix1(self):
        # Buffer:  'SET.CD.MIX1'
        # Example: 'SET CD MIX1'
        #
        # No params
        pass

    def msg_14_set_cdmix6(self):
        # Buffer:  'SET.CD.MIX6'
        # Example: 'SET CD MIX6'
        #
        # No params
        pass

    def msg_15_tape_skip_y(self):
        # Buffer:  'TAPE.SKIP.Y'
        # Example: 'TAPE SKIP Y'
        #
        # No params
        pass

    def msg_16_tape_skip_n(self):
        # Buffer:  'TAPE.SKIP.N'
        # Example: 'TAPE SKIP N'
        #
        # No params
        pass

    def _msg_40_fm_mhz(self):
        # Buffer:  'FM......MHZ'
        # Example: 'FM261389MHZ'
        #
        # Param 0 High Nibble = FM mode number (1, 2 for FM1, FM2)
        # Param 0 Low Nibble  = Preset number (0=none, 1-6)
        # Param 1 Byte        = FM Frequency Index (0=87.9 MHz, 0xFF=138.9 MHz)
        # Param 2 Byte        = Unused
        fm_mode = (self.packet[3] & 0xf0) >> 8
        self.message[2] = fm_mode + 0x30

        preset = self.packet[3] & 0x0f
        self.message[3] = preset + 0x30

        freq_index = self.packet[4]
        freq_str = str(879 + (2 * freq_index)).rjust(4, "0")
        for i, digit in enumerate(freq_str):
            if (i == 0) and digit == '0':
                continue
            self.message[4 + i] = digit

    def _msg_41_am_khz(self):
        # Buffer:  'AM......KHZ'
        # Example: 'AM 2 540KHZ'
        #
        # Param 0 High Nibble = Unused
        # Param 0 Low Nibble  = Preset number (0=none, 1-6)
        # Param 1 Byte        = AM Frequency Index (0=540 kHz, 3080 kHz)
        # Param 2 Byte        = Unused
        preset = self.packet[3] & 0x0f
        self.message[3] = preset + 0x30

        freq_index = self.packet[4]
        freq_str = str(530 + (10 * freq_index)).rjust(4, "0")
        for i, digit in enumerate(freq_str):
            if (i == 0) and digit == '0':
                continue
            self.message[4 + i] = digit

    def _msg_42_fm_mhz(self):
        # 'SCAN....MHZ'
        freq_index = self.packet[4]
        freq_str = str(879 + (2 * freq_index)).rjust(4, "0")
        for i, digit in enumerate(freq_str):
            if (i == 0) and digit == '0':
                continue
            self.message[4 + i] = digit

    def _msg_43_scan_khz(self):
        # Buffer:  'AM......KHZ'
        # Example: 'AM 2 540KHZ'
        #
        # Param 0 High Nibble = Unused
        # Param 0 Low Nibble  = Preset number (0=none, 1-6)
        # Param 1 Byte        = AM Frequency Index (0=540 kHz, 3080 kHz)
        # Param 2 Byte        = Unused
        freq_index = self.packet[4]
        freq_str = str(530 + (10 * freq_index)).rjust(4, "0")
        for i, digit in enumerate(freq_str):
            if (i == 0) and digit == '0':
                continue
            self.message[4 + i] = digit

    def _msg_44_fm_max(self):
        # 'FM....MAX..'
        pass

    def _msg_45_fm_min(self):
        # 'FM....MIN..'
        pass

    def _msg_46_am_max(self):
        # 'AM....MAX..'
        pass

    def _msg_47_am_min(self):
        # 'AM....MIN..'
        pass

    def _msg_50_tape_play_a(self):
        # Buffer:  'TAPE.PLAY.A'
        # Example: 'TAPE PLAY A'
        #
        # No params
        pass

    def _msg_51_tape_play_b(self):
        # Buffer:  'TAPE.PLAY.B'
        # Example: 'TAPE PLAY B'
        #
        # No params
        pass

    def _msg_52_tape_ff(self):
        # Buffer:  'TAPE..FF...'
        # Example: 'TAPE  FF   '
        #
        # No params
        pass

    def _msg_53_tape_rew(self):
        # Buffer:  'TAPE..REW..'
        # Example: 'TAPE  REW  '
        #
        # No params
        pass

    def _msg_54_tape_mss_ff(self):
        # Buffer:  'TAPEMSS.FF.'
        # Example: 'TAPEMSS FF '
        #
        # No params
        pass

    def _msg_55_tape_mss_rew(self):
        # Buffer:  'TAPEMSS.REW'
        # Example: 'TAPEMSS REW'
        #
        # No params
        pass

    def _msg_56_tape_scan_a(self):
        # Buffer:  'TAPE.SCAN.A'
        # Example: 'TAPE SCAN A'
        #
        # No params
        pass

    def _msg_57_tape_scan_b(self):
        # Buffer:  'TAPE.SCAN.B'
        # Example: 'TAPE SCAN B'
        #
        # No params
        pass

    def _msg_58_tape_metal(self):
        # Buffer:  'TAPE.METAL.'
        # Example: 'TAPE METAL '
        #
        # No params
        pass

    def _msg_59_tape_bls(self):
        # Buffer:  'TAPE..BLS..'
        # Example: 'TAPE  BLS  '
        #
        # No params
        pass

    def _msg_5a_no_tape(self):
        # Buffer:  '....NO.TAPE'
        # Example: '    NO TAPE'
        #
        # No params
        pass

    def _msg_5b_tape_error(self):
        # Buffer:  'TAPE.ERROR.'
        # Example: 'TAPE ERROR '
        #
        # No params
        pass

    def _msg_5c_tape_max(self):
        # Buffer:  'TAPE..MAX..'
        # Example: 'TAPE  MAX  '
        #
        # No params
        pass

    def _msg_5d_tape_min(self):
        # Buffer:  'TAPE..MIN..'
        # Example: 'TAPE  MIN  '
        #
        # No params
        pass

    def _msg_60_max(self):
        # '.....MAX...'
        pass

    def _msg_61_min(self):
        # '.....MIN...'
        pass

    def _msg_62_bass(self):
        # Buffer:  'BASS.......'
        # Example: 'BASS  0    '
        # Example: 'BASS  +9   '
        # Example: 'BASS  -9   '
        #
        # Param 0 Byte = Signed binary number
        # Param 1 Byte = Unused
        # Param 2 Byte = Unused
        level = signed_char(self.packet[3:3+1])
        if level < 0:
            self.message[6] = '-'
        elif level > 0:
            self.message[6] = '+'
        self.message[7] = abs(level) + 0x30

    def _msg_63_treb(self):
        # Buffer:  'TREB.......'
        # Example: 'TREB  0    '
        # Example: 'TREB  +9   '
        # Example: 'TREB  -9   '
        #
        # Param 0 Byte = Signed binary number
        # Param 1 Byte = Unused
        # Param 2 Byte = Unused
        self._msg_62_bass()

    def _msg_64_bal_left(self):
        # Buffer:  'BAL.LEFT...'
        # Example: 'BAL LEFT  9'
        # Example: 'BAL LEFT  1'
        #
        # Param 0 Byte = Signed binary number (always positive)
        # Param 1 Byte = Unused
        # Param 2 Byte = Unused
        level = abs(signed_char(self.packet[3:3+1]))
        self.message[10] = level + 0x30

    def _msg_65_bal_right(self):
        # Buffer:  'BAL.RIGHT..'
        # Example: 'BAL RIGHT 9'
        # Example: 'BAL RIGHT 1'
        #
        # Param 0 Byte = Signed binary number (always negative)
        # Param 1 Byte = Unused
        # Param 2 Byte = Unused
        level = abs(signed_char(self.packet[3:3+1]))
        self.message[10] = level + 0x30

    def _msg_66_bal_center(self):
        pass

    def _msg_67_fadefront(self):
        level = abs(signed_char(self.packet[3:3+1]))
        self.message[10] = level + 0x30

    def _msg_68_faderear(self):
        level = abs(signed_char(self.packet[3:3+1]))
        self.message[10] = level + 0x30

    def _msg_69_fade_center(self):
        pass

    def _msg_80_no_code(self):
        # Buffer:  '....NO.CODE'
        # Example: '    NO CODE'
        #
        # No params
        pass

    def _msg_81_code(self):
        # Buffer:  '.....CODE..'
        # Example: '     CODE  '
        #
        # No params
        pass

    def _msg_82_code_entry(self):
        # cmd, pict, screen, param 0, param 1, param 2
        # Buffer:  '...........'
        # Example: '2    1234  '
        #
        # Param 0 High Nibble = Unused
        # Param 0 Low Nibble  = Attempt number
        # Param 1 Byte        = Safe code high byte (BCD)
        # Param 2 Byte        = Safe code low byte (BCD)
        attempt = self.packet[3] & 0x0f
        if attempt != 0:
            self.message[0] = attempt + 0x30
        self.message[5] = ((self.packet[4] >> 4) & 0x0f) + 0x30
        self.message[6] = (self.packet[4] & 0x0f) + 0x30
        self.message[7] = ((self.packet[5] >> 4) & 0x0f) + 0x30
        self.message[8] = (self.packet[5] & 0x0f) + 0x30

    def _msg_83_safe(self):
        # Buffer:  '.....SAFE..'
        # Example: '2....SAFE..'
        #
        # Param 0 High Nibble = Unused
        # Param 0 Low Nibble  = Attempt number
        # Param 1 Byte        = Unused
        # Param 2 Byte        = Unused
        attempt = self.packet[3] & 0x0f
        self.message[0] = attempt + 0x30

    def _msg_84_initial(self):
        # Buffer:  '....INITIAL'
        # Example: '    INITIAL'
        #
        # No params
        pass

    def _msg_85_no_code(self):
        # Buffer:  '....NO.CODE'
        # Example: '    NO CODE'
        #
        # No params
        pass

    def _msg_87_clear(self):
        # Buffer:  '....CLEAR..'
        # Example: '    CLEAR  '
        #
        # No params
        pass

    def _msg_b0_diag(self):
        # Buffer:  '.....DIAG..'
        # Example: '     DIAG  '
        #
        # No params
        pass

    def _msg_b1_testdisplay(self):
        # Buffer:  'TESTDISPLAY'
        # Example: 'TESTDISPLAY'
        #
        # No params
        pass

    def _msg_c0_bose(self):
        # Buffer:  '.....BOSE..'
        # Example: '     BOSE  '
        #
        # No params
        pass

    def _msg_c1_(self):
        # Buffer:  '...........'
        # Example: '           '
        #
        # No params
        pass

    messages = {
        0x01: b'CD...TR....',
        0x02: b'CUE........',
        0x03: b'REV........',
        0x04: b'SCANCD.TR..',
        0x05: b'NO..CHANGER',
        0x06: b'NO..MAGAZIN',
        0x07: b'....NO.DISC',
        0x08: b'CD...ERROR.',
        0x09: b'CD.........',
        0x0a: b'CD....MAX..',
        0x0b: b'CD....MIN..',
        0x0c: b'CHK.MAGAZIN',
        0x0d: b'CD..CD.ERR.',
        0x0e: b'CD...ERROR.',
        0x0f: b'CD...NO.CD.',

        0x10: b'SET.ONVOL.Y', #
        0x11: b'SET.ONVOL.N', #
        0x12: b'SET.ONVOL..', #
        0x13: b'SET.CD.MIX1', #
        0x14: b'SET.CD.MIX6', #
        0x15: b'TAPE.SKIP.Y', #
        0x16: b'TAPE.SKIP.N', #

        0x40: b'FM......MHZ', #
        0x41: b'AM......KHZ', #
        0x42: b'SCAN....MHZ', #
        0x43: b'SCAN....KHZ', #
        0x44: b'FM....MAX..', #
        0x45: b'FM....MIN..', #
        0x46: b'AM....MAX..', #
        0x47: b'AM....MIN..', #

        0x50: b'TAPE.PLAY.A', #
        0x51: b'TAPE.PLAY.B', #
        0x52: b'TAPE..FF...', #
        0x53: b'TAPE..REW..', #
        0x54: b'TAPEMSS.FF.', #
        0x55: b'TAPEMSS.REW', #
        0x56: b'TAPE.SCAN.A', #
        0x57: b'TAPE.SCAN.B', #
        0x58: b'TAPE.METAL.', #
        0x59: b'TAPE..BLS..', #
        0x5a: b'....NO.TAPE', #
        0x5b: b'TAPE.ERROR.', #
        0x5c: b'TAPE..MAX..', #
        0x5d: b'TAPE..MIN..', #

        0x60: b'.....MAX...', #
        0x61: b'.....MIN...', #
        0x62: b'BASS.......', #
        0x63: b'TREB.......', #
        0x64: b'BAL.LEFT...', #
        0x65: b'BAL.RIGHT..', #
        0x66: b'BAL.CENTER.', #
        0x67: b'FADEFRONT..', #
        0x68: b'FADEREAR...', #
        0x69: b'FADECENTER.', #

        0x80: b'....NO.CODE', #
        0x81: b'.....CODE..', #
        0x82: b'...........', #
        0x83: b'.....SAFE..', #
        0x84: b'....INITIAL', #
        0x85: b'....NO.CODE', #
        0x86: b'.....SAFE..',
        0x87: b'....CLEAR..', #

        0xb0: b'.....DIAG..', #
        0xb1: b'TESTDISPLAY', #

        0xc0: b'.....BOSE..',
        0xc1: b'...........',
        }



def hexdump(list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])


def parse_analyzer_file(filename):
    submcu = SubMCU()
    spi_command = bytearray()
    byte = 0
    bit = 0

    old_ena = 0
    old_clk = 0

    opener = gzip.open if filename.endswith('.gz') else open
    with opener(filename, 'rt') as f:
        headings = [ col.strip() for col in f.readline().split(',') ]
        reader = csv.DictReader(f, headings)

        for row in reader:
            ena = int(row['Enable'])
            dat = int(row['Data'])
            clk = int(row['Clock'])

            # enable high->low starts packet
            if (old_ena == 1) and (ena == 0):
                spi_command = bytearray()
                byte = 0
                bit = 7

            # clock low->high latches data bit
            if (old_clk == 0) and (clk == 1):
                if dat == 1:
                    byte += (2 ** bit)

                bit -= 1
                if bit < 0: # got all bits of byte
                    spi_command.append(byte)
                    byte = 0
                    bit = 7

            # enable low->high ends packet
            if (old_ena == 0) and (ena == 1):
                # process command
                if len(spi_command) == 6:
                    submcu.process(spi_command)
                # prepare for next comnand
                spi_command = bytearray()
                byte = 0
                bit = 7

            old_ena = ena
            old_clk = clk


def main():
    if len(sys.argv) != 2:
        sys.stderr.write("Usage: %s <filename>\n" % sys.argv[0])
        sys.exit(1)

    filename = sys.argv[1]
    parse_analyzer_file(filename)


if __name__ == '__main__':
    main()
