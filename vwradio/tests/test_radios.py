import sys
import unittest
from vwradio.radios import Radio, RadioModes

class TestRadio(unittest.TestCase):
    def test_safe_mode(self):
        values = (
            ('     0000  ',    0, 0, RadioModes.SAFE_ENTRY),
            ('1    1234  ', 1234, 1, RadioModes.SAFE_ENTRY),
            ('2    5678  ', 5678, 2, RadioModes.SAFE_ENTRY),
            ('9    9999  ', 9999, 9, RadioModes.SAFE_ENTRY),
            ('     SAFE  ', 1000, 0, RadioModes.SAFE_LOCKED),
            ('1    SAFE  ', 1000, 1, RadioModes.SAFE_LOCKED),
            ('2    SAFE  ', 1000, 2, RadioModes.SAFE_LOCKED),
            ('9    SAFE  ', 1000, 9, RadioModes.SAFE_LOCKED),
        )
        for text, safe_code, safe_tries, mode in values:
            radio = Radio()
            radio.process(text)
            self.assertEqual(radio.safe_code, safe_code)
            self.assertEqual(radio.safe_tries, safe_tries)
            self.assertEqual(radio.mode, mode)

    def test_balance(self):
        values = (
            ('BAL CENTER ', 0),
            ('BAL LEFT  7', 7),
            ('BAL RIGHT 3', -3),
        )
        for text, balance in values:
            radio = Radio()
            radio.sound_balance = 99
            radio.process(text)
            self.assertEqual(radio.sound_balance, balance)

    def test_fade(self):
        values = (
            ('FADECENTER ', 0),
            ('FADEREAR  5', -5),
            ('FADEFRONT 7', 7) # TODO Verify on radio
        )
        for text, fade in values:
            radio = Radio()
            radio.sound_fade = 99
            radio.process(text)
            self.assertEqual(radio.sound_fade, fade)

    def test_bass(self):
        values = (
            ('BASS    0  ', 0),
            ('BASS  + 7  ', 7),
            ('BASS  - 5  ', -5),
        )
        for text, bass in values:
            radio = Radio()
            radio.sound_bass = 99
            radio.process(text)
            self.assertEqual(radio.sound_bass, bass)

    def test_treble(self):
        values = (
            ('TREB    0  ', 0),
            ('TREB  + 7  ', 7),
            ('TREB  - 5  ', -5),
        )
        for text, treble in values:
            radio = Radio()
            radio.sound_treble = 99
            radio.process(text)
            self.assertEqual(radio.sound_treble, treble)

    def test_fm_scan_off(self):
        values = (
            ('FM1  887MHz',  887, RadioModes.RADIO_FM1, 0),
            ('FM1  887MHZ',  887, RadioModes.RADIO_FM1, 0),
            ('FM1 1023MHZ', 1023, RadioModes.RADIO_FM1, 0),
            ('FM11 915MHZ',  915, RadioModes.RADIO_FM1, 1),
            ('FM161079MHZ', 1079, RadioModes.RADIO_FM1, 6),
            ('FM2  887MHZ',  887, RadioModes.RADIO_FM2, 0),
            ('FM2 1023MHZ', 1023, RadioModes.RADIO_FM2, 0),
            ('FM21 915MHZ',  915, RadioModes.RADIO_FM2, 1),
            ('FM261079MHZ', 1079, RadioModes.RADIO_FM2, 6),
            )
        for text, freq, mode, preset in values:
            radio = Radio()
            radio.process(text)
            self.assertFalse(radio.radio_scanning)
            self.assertEqual(radio.mode, mode)
            self.assertEqual(radio.radio_freq, freq)
            self.assertEqual(radio.radio_preset, preset)

    def test_fm_scan_on(self):
        values = (
            ('SCAN 879MHz',  879, RadioModes.RADIO_FM1),
            ('SCAN 879MHZ',  879, RadioModes.RADIO_FM1),
            ('SCAN1035MHZ', 1035, RadioModes.RADIO_FM2),
        )
        for text, freq, mode in values:
            radio = Radio()
            radio.mode = mode
            radio.process(text)
            self.assertEqual(radio.radio_freq, freq)
            self.assertEqual(radio.radio_preset, 0)
            self.assertTrue(radio.radio_scanning)

    def test_am_scan_off(self):
        values = (
            ('AM   670kHz',  6700, 0),
            ('AM   670KHZ',  6700, 0),
            ('AM  1540KHZ', 15400, 0),
            ('AM 1 670KHZ',  6700, 1),
            ('AM 61540KHZ', 15400, 6),
            )
        for text, freq, preset in values:
            radio = Radio()
            radio.mode = RadioModes.UNKNOWN
            radio.process(text)
            self.assertEqual(radio.radio_freq, freq)
            self.assertEqual(radio.mode, RadioModes.RADIO_AM)
            self.assertEqual(radio.radio_preset, preset)

    def test_am_scan_on(self):
        values = (
            ('SCAN 530kHz',  5300),
            ('SCAN 530KHZ',  5300),
            ('SCAN1710KHZ', 17100),
        )
        for text, freq in values:
            radio = Radio()
            radio.mode = RadioModes.RADIO_AM
            radio.process(text)
            self.assertEqual(radio.radio_freq, freq)
            self.assertEqual(radio.mode, RadioModes.RADIO_AM)
            self.assertEqual(radio.radio_preset, 0)
            self.assertTrue(radio.radio_scanning)

    def test_cd_playing(self):
        values = (
            ('CD 1 TR 01 ', 1, 1),
            ('CD 6 TR 99 ', 6, 99),
        )
        for text, disc, track in values:
            radio = Radio()
            radio.mode = RadioModes.UNKNOWN
            radio.process(text)
            self.assertEqual(radio.mode, RadioModes.CD_PLAYING)
            self.assertEqual(radio.cd_disc, disc)
            self.assertEqual(radio.cd_track, track)

    def test_cd_no_cd(self):
        radio = Radio()
        radio.mode = RadioModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.process('CD 2 NO CD ')
        self.assertEqual(radio.mode, RadioModes.CD_NO_CD)
        self.assertEqual(radio.cd_disc, 2)
        self.assertEqual(radio.cd_track, 0)

    def test_cd_cueing(self):
        radio = Radio()
        radio.mode = RadioModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 12
        radio.process('CUE   122  ')
        self.assertEqual(radio.mode, RadioModes.CD_CUEING)
        self.assertEqual(radio.cd_disc, 5)
        self.assertEqual(radio.cd_track, 12)

    def test_cd_check_magazine(self):
        radio = Radio()
        radio.mode = RadioModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.process('CHK MAGAZIN')
        self.assertEqual(radio.mode, RadioModes.CD_CHECK_MAGAZINE)
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)

    def test_cd_no_disc(self):
        radio = Radio()
        radio.mode = RadioModes.CD_PLAYING
        radio.cd_disc = 7
        radio.cd_track = 9
        radio.process('    NO DISC')
        self.assertEqual(radio.mode, RadioModes.CD_NO_DISC)
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)

    def test_cd_no_changer(self):
        radio = Radio()
        radio.mode = RadioModes.CD_PLAYING
        radio.cd_disc = 7
        radio.cd_track = 9
        radio.process('NO  CHANGER')
        self.assertEqual(radio.mode, RadioModes.CD_NO_CHANGER)
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)

    def test_tape_play_a(self):
        radio = Radio()
        radio.process('TAPE PLAY A')
        self.assertEqual(radio.mode, RadioModes.TAPE_PLAYING)
        self.assertEqual(radio.tape_side, 1)

    def test_tape_play_b(self):
        radio = Radio()
        radio.process('TAPE PLAY B')
        self.assertEqual(radio.mode, RadioModes.TAPE_PLAYING)
        self.assertEqual(radio.tape_side, 2)

    def test_tape_mss_ff(self):
        radio = Radio()
        radio.process('TAPEMSS FF ')
        radio.tape_side = 1
        self.assertEqual(radio.mode, RadioModes.TAPE_MSS_FF)
        self.assertEqual(radio.tape_side, 1)

    def test_tape_mss_rew(self):
        radio = Radio()
        radio.tape_side = 2
        radio.process('TAPEMSS REW')
        self.assertEqual(radio.mode, RadioModes.TAPE_MSS_REW)
        self.assertEqual(radio.tape_side, 2)

    def test_tape_error(self):
        radio = Radio()
        radio.tape_side = 1
        radio.process('TAPE ERROR ')
        self.assertEqual(radio.mode, RadioModes.TAPE_ERROR)
        self.assertEqual(radio.tape_side, 0)

    def test_ignores_blank(self):
        radio = Radio()
        radio.mode = RadioModes.RADIO_FM1
        radio.process(' ' * 11)
        self.assertEqual(radio.mode, RadioModes.RADIO_FM1)

    def test_ignores_volume_min_max(self):
        texts = (
            'AM    MIN  ',
            'AM    MAX  ',
            'FM1   MIN  ',
            'FM1   MAX  ',
            'FM2   MIN  ',
            'FM2   MAX  ',
            'CD    MIN  ',
            'CD    MAX  ',
            'TAP   MIN  ',
            'TAP   MAX  ',
        )
        for text in texts:
            radio = Radio()
            radio.mode = RadioModes.SAFE_LOCKED
            radio.process(text)
            self.assertEqual(radio.mode, RadioModes.SAFE_LOCKED)

def test_suite():
    return unittest.findTestCases(sys.modules[__name__])

if __name__ == '__main__':
    unittest.main(defaultTest='test_suite')
