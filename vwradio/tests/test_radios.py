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
            radio.process(display)
            self.assertEqual(radio.safe_code, safe_code)
            self.assertEqual(radio.safe_tries, safe_tries)
            self.assertEqual(radio.operation_mode, mode)
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
            # process display
            radio.process(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_VOLUME)

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
            # process display
            radio.process(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_BALANCE)
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
            # process display
            radio.process(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_FADE)
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
            # process display
            radio.process(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_BASS)
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
            # process display
            radio.process(display)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_TREBLE)
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
            # process display
            radio.process(display)
            self.assertEqual(radio.sound_midrange, mid)
            self.assertEqual(radio.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.ADJUSTING_MIDRANGE)

    def test_cd_playing(self):
        values = (
            ("CD 1 TR 01 ", 1, 1),
            ("CD 6 TR 99 ", 6, 99),
        )
        for display, disc, track in values:
            radio = Radio()
            radio.process(display)
            self.assertEqual(radio.cd_disc, disc)
            self.assertEqual(radio.cd_track, track)
            self.assertEqual(radio.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(radio.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_cueing(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 5
        radio.cd_track = 12
        # process display
        radio.process("CUE   122  ")
        self.assertEqual(radio.cd_disc, 5)
        self.assertEqual(radio.cd_track, 12)
        self.assertEqual(radio.cd_cue_pos, 122)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_CUEING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_cd_check_magazine(self):
        radio = Radio()
        # set up known values
        radio.operation_mode = OperationModes.CD_PLAYING
        radio.cd_disc = 1
        radio.cd_track = 3
        radio.cd_cue_pos = 99
        # process display
        radio.process("CHK MAGAZIN")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_cue_pos, 0)
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
        radio.cd_cue_pos = 99
        # process display
        radio.process("CD 2 NO CD ") # space in "CD 2"
        self.assertEqual(radio.cd_disc, 2)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_cue_pos, 0)
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
        radio.cd_cue_pos = 99
        # process display
        radio.process("CD1 CD ERR ") # no space in "CD1"
        self.assertEqual(radio.cd_disc, 1)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_cue_pos, 0)
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
        radio.cd_cue_pos = 99
        # process display
        radio.process("    NO DISC")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_cue_pos, 0)
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
        radio.cd_cue_pos = 99
        # process display
        radio.process("NO  CHANGER")
        self.assertEqual(radio.cd_disc, 0)
        self.assertEqual(radio.cd_track, 0)
        self.assertEqual(radio.cd_cue_pos, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.CD_NO_CHANGER)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_load_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("TAPE LOAD  ")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_LOAD)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_metal_premium_5(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("TAPE METAL ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_METAL)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_a(self):
        radio = Radio()
        radio.process("TAPE PLAY A")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_play_b(self):
        radio = Radio()
        radio.process("TAPE PLAY B")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_ff(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("TAPE  FF   ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_FF)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_mss_ff(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        # process display
        radio.process("TAPEMSS FF ")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_MSS_FF)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_rew(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("TAPE  REW  ")
        self.assertEqual(radio.tape_side, 1)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_REW)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_mss_rew(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 2
        # process display
        radio.process("TAPEMSS REW")
        self.assertEqual(radio.tape_side, 2)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_MSS_REW)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_error(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("TAPE ERROR ")
        self.assertEqual(radio.tape_side, 0)
        self.assertEqual(radio.operation_mode,
            OperationModes.TAPE_ERROR)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_no_tape(self):
        radio = Radio()
        # set up known values
        radio.tape_side = 1
        # process display
        radio.process("    NO TAPE")
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
            radio.process(display)
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
        # process display
        radio.process("SCAN 879MHZ")
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
        # process display
        radio.process("SCAN1035MHZ")
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
        radio.process("SCAN 879MHZ")
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
            radio.process(display)
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
            radio.process(display)
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
        # process display
        radio.process(" " * 11)
        self.assertEqual(radio.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(radio.display_mode,
            DisplayModes.SHOWING_OPERATION)
