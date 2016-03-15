import unittest
from vwradio.radios import Radio
from vwradio.constants import OperationModes, DisplayModes, TunerBands

class TestRadio(unittest.TestCase):
    def test_safe_mode(self):
        values = (
            # Premium 4
            ("     0000  ",    0, 0, OperationModes.SAFE_ENTRY),
            ("1    1234  ", 1234, 1, OperationModes.SAFE_ENTRY),
            ("2    5678  ", 5678, 2, OperationModes.SAFE_ENTRY),
            ("9    9999  ", 9999, 9, OperationModes.SAFE_ENTRY),
            ("    NO CODE",    0, 0, OperationModes.SAFE_NO_CODE),
            # Premium 5
            ("    0000   ",    0, 0, OperationModes.SAFE_ENTRY),
            ("1   1234   ", 1234, 1, OperationModes.SAFE_ENTRY),
            ("2   5678   ", 5678, 2, OperationModes.SAFE_ENTRY),
            ("9   9999   ", 9999, 9, OperationModes.SAFE_ENTRY),
            # Premium 4 and 5
            ("     SAFE  ", 1000, 0, OperationModes.SAFE_LOCKED),
            ("1    SAFE  ", 1000, 1, OperationModes.SAFE_LOCKED),
            ("2    SAFE  ", 1000, 2, OperationModes.SAFE_LOCKED),
            ("9    SAFE  ", 1000, 9, OperationModes.SAFE_LOCKED),
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
        radio.parse("    INITIAL")
        self.assertEqual(radio.operation_mode,
            OperationModes.INITIALIZING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_diag(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.TUNER_PLAYING
        radio.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME
        # parse display
        radio.parse("     DIAG  ")
        self.assertEqual(radio.operation_mode,
            OperationModes.DIAGNOSTICS)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_sound_volume(self):
        displays = (
            "AM    MIN  ",
            "AM    MAX  ",
            "FM1   MIN  ",
            "FM1   MAX  ",
            "FM2   MIN  ",
            "FM2   MAX  ",
            "CD    MIN  ",
            "CD    MAX  ",
            "TAP   MIN  ",
            "TAP   MAX  ",
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
            ("BAL LEFT  9", -9),
            ("BAL LEFT  1", -1),
            ("BAL CENTER ", 0),
            ("BAL RIGHT 1", 1),
            ("BAL RIGHT 9", 9),
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
            ("FADEREAR  9", -9),
            ("FADEREAR  1", -1),
            ("FADECENTER ", 0),
            ("FADEFRONT 1", 1),
            ("FADEFRONT 9", 9),
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
            ("BASS  - 9  ", -9),
            ("BASS  - 1  ", -1),
            ("BASS    0  ", 0),
            ("BASS  + 1  ", 1),
            ("BASS  + 9  ", 9),
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
            ("TREB  - 9  ", -9),
            ("TREB  - 1  ", -1),
            ("TREB    0  ", 0),
            ("TREB  + 1  ", 1),
            ("TREB  + 9  ", 9),
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
            ("MID   - 9  ", -9),
            ("MID   - 1  ", -1),
            ("MID     0  ", 0),
            ("MID   + 1  ", 1),
            ("MID   + 9  ", 9),
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
            ("SET ONVOL 0", 0),
            ("SET ONVOL 1", 1),
            ("SET ONVOL02", 2),
            ("SET ONVOL13", 13),
            ("SET ONVOL63", 63),
            ("SET ONVOL99", 99),
        )
        for display, on_vol in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_on_vol, on_vol)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SETTING_OPTION_ON_VOL)

    def test_set_option_cd_mix(self):
        values = (
            ("SET CD MIX1", 1),
            ("SET CD MIX6", 6),
        )
        for display, cd_mix in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_cd_mix, cd_mix)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SETTING_OPTION_CD_MIX)

    def test_set_option_tape_skip(self):
        values = (
            ("TAPE SKIP N", 0),
            ("TAPE SKIP Y", 1),
        )
        for display, tape_skip in values:
            radio = Radio()
            # set up known values
            radio.operation_mode = OperationModes.TUNER_PLAYING
            radio.display_mode = DisplayModes.SHOWING_OPERATION
            # parse display
            radio.parse(display)
            self.assertEqual(radio.option_tape_skip, tape_skip)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SETTING_OPTION_TAPE_SKIP)

    def test_cd_playing(self):
        values = (
            ("CD 1 TR 01 ", 1, 1),
            ("CD 6 TR 99 ", 6, 99),
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
            ("CUE   000  ", OperationModes.CD_CUE, 5, (0*60)+0),
            ("CUE   001  ", OperationModes.CD_CUE, 5, (0*60)+1),
            ("CUE   012  ", OperationModes.CD_CUE, 5, (0*60)+12),
            ("CUE   123  ", OperationModes.CD_CUE, 5, (1*60)+23),
            ("CUE  1234  ", OperationModes.CD_CUE, 5, (12*60)+34),
            ("CUE  9999  ", OperationModes.CD_CUE, 5, (99*60)+99),
            ("CUE  -002  ", OperationModes.CD_CUE, 5, 0),
            ("CUE -1234  ", OperationModes.CD_CUE, 5, 0),

            ("REV   000  ", OperationModes.CD_REV, 5, (0*60)+0),
            ("REV   001  ", OperationModes.CD_REV, 5, (0*60)+1),
            ("REV   012  ", OperationModes.CD_REV, 5, (0*60)+12),
            ("REV   123  ", OperationModes.CD_REV, 5, (1*60)+23),
            ("REV  1234  ", OperationModes.CD_REV, 5, (12*60)+34),
            ("REV  9999  ", OperationModes.CD_REV, 5, (99*60)+99),
            ("REV  -002  ", OperationModes.CD_REV, 5, 0),
            ("REV -1234  ", OperationModes.CD_REV, 5, 0),

            ("CD 2  000  ", OperationModes.CD_PLAYING, 2, (0*60)+0),
            ("CD 2  001  ", OperationModes.CD_PLAYING, 2, (0*60)+1),
            ("CD 2  012  ", OperationModes.CD_PLAYING, 2, (0*60)+12),
            ("CD 2  123  ", OperationModes.CD_PLAYING, 2, (1*60)+23),
            ("CD 2 1234  ", OperationModes.CD_PLAYING, 2, (12*60)+34),
            ("CD 2 9999  ", OperationModes.CD_PLAYING, 2, (99*60)+99),
            ("CD 2 -002  ", OperationModes.CD_PLAYING, 2, 0),
            ("CD 2-1234  ", OperationModes.CD_PLAYING, 2, 0),
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

    def test_cd_check_magazine(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse("CHK MAGAZIN")
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
        radio.parse("CD 2 NO CD ") # space in "CD 2"
        self.assertEqual(radio.cd_disc, 2)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_CDX_NO_CD)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_cdx_cd_err(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 3
        radio.cd_track_pos = 99
        # parse display
        radio.parse("CD1 CD ERR ") # no space in "CD1"
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
        radio.parse("    NO DISC")
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
        radio.parse("NO  CHANGER")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_track_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_NO_CHANGER)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_load_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse("TAPE LOAD  ")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_LOAD)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_metal_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse("TAPE METAL ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_METAL)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_a(self):
        radio = Radio()
        radio.parse("TAPE PLAY A")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_b(self):
        radio = Radio()
        radio.parse("TAPE PLAY B")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_ff(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # parse display
        radio.parse("TAPE  FF   ")
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
        radio.parse("TAPEMSS FF ")
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
        radio.parse("TAPE  REW  ")
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
        radio.parse("TAPEMSS REW")
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
        radio.parse("TAPE ERROR ")
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
        radio.parse("    NO TAPE")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_NO_TAPE)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_fm_scan_off(self):
        values = (
            ("FM1  887MHz",  887, TunerBands.FM1, 0),
            ("FM1  887MHZ",  887, TunerBands.FM1, 0),
            ("FM1 1023MHZ", 1023, TunerBands.FM1, 0),
            ("FM11 915MHZ",  915, TunerBands.FM1, 1),
            ("FM161079MHZ", 1079, TunerBands.FM1, 6),
            ("FM2  887MHZ",  887, TunerBands.FM2, 0),
            ("FM2 1023MHZ", 1023, TunerBands.FM2, 0),
            ("FM21 915MHZ",  915, TunerBands.FM2, 1),
            ("FM261079MHZ", 1079, TunerBands.FM2, 6),
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
        radio.parse("SCAN 879MHZ")
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
        radio.parse("SCAN1035MHZ")
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
        radio.parse("SCAN 879MHZ")
        self.assertEqual(radio.tuner_freq, 879)
        self.assertEqual(radio.tuner_preset, 0)
        self.assertEqual(radio.tuner_band, TunerBands.FM1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tuner_am_scan_off(self):
        values = (
            ("AM   670kHz",  670, 0),
            ("AM   670KHZ",  670, 0),
            ("AM  1540KHZ", 1540, 0),
            ("AM 1 670KHZ",  670, 1),
            ("AM 61540KHZ", 1540, 6),
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
            ("SCAN 530kHz",  530),
            ("SCAN1710KHZ", 1710),
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
        radio.parse(" " * 11)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)
