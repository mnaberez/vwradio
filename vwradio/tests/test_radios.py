import unittest
from vwradio.radios import Radio
from vwradio.constants import OperationModes, DisplayModes, TunerBands

class TestRadio(unittest.TestCase):
    def test_safe_mode(self):
        values = (
            # Premium 4
            (b"     0000  ",    0, 0, OperationModes.SAFE_ENTRY),
            (b"1    1234  ", 1234, 1, OperationModes.SAFE_ENTRY),
            (b"2    5678  ", 5678, 2, OperationModes.SAFE_ENTRY),
            (b"9    9999  ", 9999, 9, OperationModes.SAFE_ENTRY),
            (b"    NO CODE",    0, 0, OperationModes.SAFE_NO_CODE),
            # Premium 5
            (b"    0000   ",    0, 0, OperationModes.SAFE_ENTRY),
            (b"1   1234   ", 1234, 1, OperationModes.SAFE_ENTRY),
            (b"2   5678   ", 5678, 2, OperationModes.SAFE_ENTRY),
            (b"9   9999   ", 9999, 9, OperationModes.SAFE_ENTRY),
            # Premium 4 and 5
            (b"     SAFE  ", 1000, 0, OperationModes.SAFE_LOCKED),
            (b"1    SAFE  ", 1000, 1, OperationModes.SAFE_LOCKED),
            (b"2    SAFE  ", 1000, 2, OperationModes.SAFE_LOCKED),
            (b"9    SAFE  ", 1000, 9, OperationModes.SAFE_LOCKED),
        )
        for display, safe_code, safe_tries, mode in values:
            radio = Radio()
            radio.parse(display)
            self.assertEqual(radio.safe_code, safe_code)
            self.assertEqual(radio.safe_tries, safe_tries)
            self.assertEqual(radio.operation_mode, mode)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_initial(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.TUNER_PLAYING
        radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
        # parse display
        radio.parse(b"    INITIAL")
        self.assertEqual(radio.operation_mode,
            OperationModes.INITIALIZING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_monsoon_premium_5(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.TUNER_PLAYING
        radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
        # parse display
        radio.parse(b"    MONSOON")
        self.assertEqual(radio.operation_mode,
            OperationModes.MONSOON)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_diag(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.TUNER_PLAYING
        radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
        # parse display
        radio.parse(b"     DIAG  ")
        self.assertEqual(radio.operation_mode,
            OperationModes.DIAGNOSTICS)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_sound_volume(self):
        displays = (
            b"AM    MIN  ",
            b"AM    MAX  ",
            b"FM1   MIN  ",
            b"FM1   MAX  ",
            b"FM2   MIN  ",
            b"FM2   MAX  ",
            b"CD    MIN  ",
            b"CD    MAX  ",
            b"TAP   MIN  ",
            b"TAP   MAX  ",
        )
        for display in displays:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)

    def test_sound_balance(self):
        values = (
            (b"BAL LEFT  9", -9),
            (b"BAL LEFT  1", -1),
            (b"BAL CENTER ", 0),
            (b"BAL RIGHT 1", 1),
            (b"BAL RIGHT 9", 9),
        )
        for display, balance in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_BALANCE)
            self.assertEqual(radio.sound_balance, balance)

    def test_sound_fade(self):
        values = (
            (b"FADEREAR  9", -9),
            (b"FADEREAR  1", -1),
            (b"FADECENTER ", 0),
            (b"FADEFRONT 1", 1),
            (b"FADEFRONT 9", 9),
        )
        for display, fade in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_FADE)
            self.assertEqual(radio.sound_fade, fade)

    def test_sound_bass(self):
        values = (
            (b"BASS  - 9  ", -9),
            (b"BASS  - 1  ", -1),
            (b"BASS    0  ", 0),
            (b"BASS  + 1  ", 1),
            (b"BASS  + 9  ", 9),
        )
        for display, bass in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_BASS)
            self.assertEqual(radio.sound_bass, bass)

    def test_sound_treble(self):
        values = (
            (b"TREB  - 9  ", -9),
            (b"TREB  - 1  ", -1),
            (b"TREB    0  ", 0),
            (b"TREB  + 1  ", 1),
            (b"TREB  + 9  ", 9),
        )
        for display, treble in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_TREBLE)
            self.assertEqual(radio.sound_treble, treble)

    def test_sound_midrange_premium_5(self):
        values = (
            (b"MID   - 9  ", -9),
            (b"MID   - 1  ", -1),
            (b"MID     0  ", 0),
            (b"MID   + 1  ", 1),
            (b"MID   + 9  ", 9),
        )
        for display, mid in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.sound_midrange, mid)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_SOUND_MIDRANGE)

    def test_set_option_on_vol(self):
        values = (
            (b"SET ONVOL 0", 0),
            (b"SET ONVOL 1", 1),
            (b"SET ONVOL02", 2),
            (b"SET ONVOL13", 13),
            (b"SET ONVOL63", 63),
            (b"SET ONVOL99", 99),
        )
        for display, on_vol in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_on_vol, on_vol)
            self.assertEqual(radio.operation_mode,
                OperationModes.SETTING_ON_VOL)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_set_option_cd_mix(self):
        values = (
            (b"SET CD MIX1", 1),
            (b"SET CD MIX6", 6),
        )
        for display, cd_mix in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_cd_mix, cd_mix)
            self.assertEqual(radio.operation_mode,
                OperationModes.SETTING_CD_MIX)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_set_option_tape_skip(self):
        values = (
            (b"TAPE SKIP N", 0),
            (b"TAPE SKIP Y", 1),
        )
        for display, tape_skip in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_tape_skip, tape_skip)
            self.assertEqual(radio.operation_mode,
                OperationModes.SETTING_TAPE_SKIP)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_fern(self):
        values = (
            (b"FERN   OFF ", 0),
            (b"FERN   ON  ", 1),
        )
        for display, fern in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.test_fern, fern)
            self.assertEqual(radio.operation_mode,
                OperationModes.TESTING_FERN)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_rad(self):
        values = (
            (b"RAD 3CP T7 ", b"3CP T7 "), # Premium 4
            (b"RAD   DE2  ", b"  DE2  "), # Premium 5
            (b"RAD 0123456", b"0123456"),
        )
        for display, rad in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.test_rad, rad)
            self.assertEqual(radio.operation_mode,
                OperationModes.TESTING_RAD)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_ver(self):
        values = (
            (b"VER  0702  ", b" 0702  "), # Premium 4
            (b"VersA99CZ23", b"A99CZ23"), # Premium 5
            (b"VER ABCDEFG", b"ABCDEFG"),
        )
        for display, ver in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.test_ver, ver)
            self.assertEqual(radio.operation_mode,
                OperationModes.TESTING_VER)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_signal_premium5(self):
        values = (
            (b" 5300 2 6 F",  530, 0x026F), # AM 530 KHz
            (b"17100 1 2 3", 1710, 0x0123), # AM 1710 KHz
            (b" 8770 5 3 0",  877, 0x0530), # FM 87.7 MHz
            (b"10770 6 4 0", 1077, 0x0640), # FM 107.7 MHz
            (b"1077A B C D", 1077, 0xABCD),
            (b"1077E F 1 2", 1077, 0xEF12),
            (b"10770 0 0 0", 1077, 0x0000),
            (b"1077F F F F", 1077, 0xFFFF),
        )
        for display, freq, strength in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
            # parse display
            radio.parse(display)
            self.assertEqual(radio.test_signal_freq, freq)
            self.assertEqual(radio.test_signal_strength, strength)
            self.assertEqual(radio.operation_mode,
                OperationModes.TESTING_SIGNAL)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_playing(self):
        values = (
            (b"CD 1 TR 01 ", 1, 1),
            (b"CD 6 TR 99 ", 6, 99),
        )
        for display, disc, track in values:
            radio = Radio()
            radio.parse(display)
            self.assertEqual(radio.cd_disc, disc)
            self.assertEqual(radio.cd_track, track)
            self.assertEqual(radio.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_cue_rev_pos(self):
        values = (
            (b"CUE   000  ", OperationModes.CD_CUE, 5, (0*60)+0),
            (b"CUE   001  ", OperationModes.CD_CUE, 5, (0*60)+1),
            (b"CUE   012  ", OperationModes.CD_CUE, 5, (0*60)+12),
            (b"CUE   123  ", OperationModes.CD_CUE, 5, (1*60)+23),
            (b"CUE  1234  ", OperationModes.CD_CUE, 5, (12*60)+34),
            (b"CUE  9999  ", OperationModes.CD_CUE, 5, (99*60)+99),
            (b"CUE  -002  ", OperationModes.CD_CUE, 5, 0),
            (b"CUE -1234  ", OperationModes.CD_CUE, 5, 0),

            (b"REV   000  ", OperationModes.CD_REV, 5, (0*60)+0),
            (b"REV   001  ", OperationModes.CD_REV, 5, (0*60)+1),
            (b"REV   012  ", OperationModes.CD_REV, 5, (0*60)+12),
            (b"REV   123  ", OperationModes.CD_REV, 5, (1*60)+23),
            (b"REV  1234  ", OperationModes.CD_REV, 5, (12*60)+34),
            (b"REV  9999  ", OperationModes.CD_REV, 5, (99*60)+99),
            (b"REV  -002  ", OperationModes.CD_REV, 5, 0),
            (b"REV -1234  ", OperationModes.CD_REV, 5, 0),

            (b"CD 2  000  ", OperationModes.CD_PLAYING, 2, (0*60)+0),
            (b"CD 2  001  ", OperationModes.CD_PLAYING, 2, (0*60)+1),
            (b"CD 2  012  ", OperationModes.CD_PLAYING, 2, (0*60)+12),
            (b"CD 2  123  ", OperationModes.CD_PLAYING, 2, (1*60)+23),
            (b"CD 2 1234  ", OperationModes.CD_PLAYING, 2, (12*60)+34),
            (b"CD 2 9999  ", OperationModes.CD_PLAYING, 2, (99*60)+99),
            (b"CD 2 -002  ", OperationModes.CD_PLAYING, 2, 0),
            (b"CD 2-1234  ", OperationModes.CD_PLAYING, 2, 0),
        )
        for display, operation_mode, cd_disc, cd_track_pos in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.CD_PLAYING
            radio.cd_disc = 5
            radio.cd_track = 12
            # parse display
            radio.parse(display)
            self.assertEqual(radio.cd_disc, cd_disc)
            self.assertEqual(radio.cd_track, 12)
            self.assertEqual(radio.cd_track_pos, cd_track_pos)
            self.assertEqual(radio.operation_mode,
                operation_mode)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_scanning(self):
        values = (
            (b"SCANCD1TR04", 1, 4),
            (b"SCANCD3TR15", 3, 15),
        )
        for display, disc, track in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.CD_PLAYING
            radio.cd_disc = 5
            radio.cd_track = 12
            radio.cd_track_pos = 42
            # parse display
            radio.parse(display)
            self.assertEqual(radio.cd_disc, disc)
            self.assertEqual(radio.cd_track, track)
            self.assertEqual(radio.cd_track_pos, 0)
            self.assertEqual(radio.operation_mode,
                OperationModes.CD_SCANNING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_check_magazine(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse(b"CHK MAGAZIN")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_CHECK_MAGAZINE)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_cdx_no_cd(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse(b"CD 2 NO CD ") # space in "CD 2"
        self.assertEqual(radio.cd_disc, 2)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_CDX_NO_CD)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_cdx_cd_err(self):
        displays = (
            b"CD1 CD ERR ", # Premium 4
            b"CD 1CD ERR ", # Premium 5
        )
        for display in displays:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.CD_PLAYING
            radio.cd_disc = 5
            radio.cd_track = 3
            radio.cd_track_pos = 99
            # parse display
            radio.parse(display)
            self.assertEqual(radio.cd_disc, 1)
            self.assertEqual(radio.cd_track, 0)
            self.assertEqual(radio.cd_track_pos, 0)
            self.assertEqual(radio.operation_mode,
                OperationModes.CD_CDX_CD_ERR)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_no_disc(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse(b"    NO DISC")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_NO_DISC)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_no_changer(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse(b"NO  CHANGER")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_NO_CHANGER)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_no_magazine(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse(b"NO  MAGAZIN")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_NO_MAGAZINE)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_load_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse(b"TAPE LOAD  ")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_LOAD)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_metal_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        radio.operation_mode = OperationModes.TAPE_PLAYING
        # parse display
        radio.parse(b"TAPE METAL ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_METAL)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_bls(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        radio.operation_mode = OperationModes.TAPE_PLAYING
        # parse display
        radio.parse(b"TAPE  BLS  ")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_BLS)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_a(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        radio.operation_mode = OperationModes.TUNER_PLAYING
        # parse display
        radio.parse(b"TAPE PLAY A")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_b(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        radio.operation_mode = OperationModes.TUNER_PLAYING
        # parse display
        radio.parse(b"TAPE PLAY B")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_scan_a(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        radio.operation_mode = OperationModes.TUNER_PLAYING
        # parse display
        radio.parse(b"TAPE SCAN A")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_scan_b(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        radio.operation_mode = OperationModes.TUNER_PLAYING
        # parse display
        radio.parse(b"TAPE SCAN B")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_ff(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse(b"TAPE  FF   ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_FF)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_mss_ff(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        # parse display
        radio.parse(b"TAPEMSS FF ")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_MSS_FF)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_rew(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse(b"TAPE  REW  ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_REW)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_mss_rew(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        # parse display
        radio.parse(b"TAPEMSS REW")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_MSS_REW)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_error(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse(b"TAPE ERROR ")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_ERROR)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_no_tape(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse(b"    NO TAPE")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_NO_TAPE)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_fm_scan_off(self):
        values = (
            (b"FM1  887MHz",  887, TunerBands.FM1, 0),
            (b"FM1  887MHZ",  887, TunerBands.FM1, 0),
            (b"FM1 1023MHZ", 1023, TunerBands.FM1, 0),
            (b"FM11 915MHZ",  915, TunerBands.FM1, 1),
            (b"FM161079MHZ", 1079, TunerBands.FM1, 6),
            (b"FM2  887MHZ",  887, TunerBands.FM2, 0),
            (b"FM2 1023MHZ", 1023, TunerBands.FM2, 0),
            (b"FM21 915MHZ",  915, TunerBands.FM2, 1),
            (b"FM261079MHZ", 1079, TunerBands.FM2, 6),
            )
        for display, freq, band, preset in values:
            radio = Radio()
            radio.parse(display)
            self.assertEqual(radio.tuner_band, band)
            self.assertEqual(radio.tuner_freq, freq)
            self.assertEqual(radio.tuner_preset, preset)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_tuner_fm_scan_on_fm1_band(self):
        radio = Radio()
        # set up known values
        radio.tuner_band = TunerBands.FM1
        radio.tuner_freq = 915
        radio.tuner_preset = 1
        # parse display
        radio.parse(b"SCAN 879MHZ")
        self.assertEqual(radio.tuner_freq, 879)
        self.assertEqual(radio.tuner_preset, 0)
        self.assertEqual(radio.tuner_band, TunerBands.FM1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_fm_scan_on_fm2_band(self):
        radio = Radio()
        # set up known values
        radio.tuner_band = TunerBands.FM2
        radio.tuner_freq = 915
        radio.tuner_preset = 1
        # parse display
        radio.parse(b"SCAN1035MHZ")
        self.assertEqual(radio.tuner_freq, 1035)
        self.assertEqual(radio.tuner_preset, 0)
        self.assertEqual(radio.tuner_band, TunerBands.FM2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_fm_scan_on_unknown_band_sets_fm1(self):
        radio = Radio()
        self.assertEqual(radio.tuner_band, TunerBands.UNKNOWN)
        radio.parse(b"SCAN 879MHZ")
        self.assertEqual(radio.tuner_freq, 879)
        self.assertEqual(radio.tuner_preset, 0)
        self.assertEqual(radio.tuner_band, TunerBands.FM1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_am_scan_off(self):
        values = (
            (b"AM   670kHz",  670, 0),
            (b"AM   670KHZ",  670, 0),
            (b"AM  1540KHZ", 1540, 0),
            (b"AM 1 670KHZ",  670, 1),
            (b"AM 61540KHZ", 1540, 6),
            )
        for display, freq, preset in values:
            radio = Radio()
            radio.parse(display)
            self.assertEqual(radio.tuner_freq, freq)
            self.assertEqual(radio.tuner_preset, preset)
            self.assertEqual(radio.tuner_band, TunerBands.AM)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_tuner_am_scan_on(self):
        values = (
            (b"SCAN 530kHz",  530),
            (b"SCAN1710KHZ", 1710),
        )
        for display, freq in values:
            radio = Radio()
            radio.tuner_band = TunerBands.AM
            radio.parse(display)
            self.assertEqual(radio.tuner_freq, freq)
            self.assertEqual(radio.tuner_band, TunerBands.AM)
            self.assertEqual(radio.tuner_preset, 0)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_SCANNING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_ignores_blank(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.TUNER_PLAYING
        radio.display_mode = DisplayModes.SHOWING_OPERATION
        # parse display
        radio.parse(b" " * 11)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)
