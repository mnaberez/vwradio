from vwradio.constants import OperationModes, DisplayModes, TunerBands

class Radio(object):
    def __init__(self):
        self.operation_mode = OperationModes.UNKNOWN
        self.display_mode = DisplayModes.UNKNOWN
        self.safe_code = 1000
        self.safe_tries = 0
        self.sound_balance = 0 # left -9, center 0, right +9
        self.sound_fade = 0 # rear -9, center 0, front +9
        self.sound_bass = 0 # -9 to 9
        self.sound_treble = 0 # -9 to 9
        self.sound_midrange = 0 # Premium 5 only, -9 to 9
        self.tuner_band = TunerBands.UNKNOWN
        self.tuner_freq = 0 # 883=88.3 MHz, 5400=540.0 KHz
        self.tuner_preset = 0 # 0=none, am/fm1/fm2 preset 1-6
        self.cd_disc = 0 # 0=none, disc 1-6
        self.cd_track = 0 # 0=none, track 1-99
        self.cd_track_pos = 0 # position on track during cue/rev, in seconds
        self.tape_side = 0 # 0=none, 1=side a, 2=side b
        self.option_on_vol = 0 # 13-63 on Premium 4, 8-45 on Premium 5
        self.option_cd_mix = 1 # 1 or 6
        self.option_tape_skip = 0 # 0=no, 1=yes
        self.test_fern = 0 # 0=off, 1=on
        self.test_rad = b" " * 7 # 7 bytes like b"3CP T7 "
        self.test_ver = b" " * 7 # 7 bytes like b" 0702  "
        self.test_signal_freq = 0 # Premium 5 only, 977=97.7 Mhz, 540=540 KHz
        self.test_signal_strength = 0 # Premium 5 only, 0 to 0xFFFF

    def parse(self, display):
        if display == b' ' * 11:
            pass # blank
        elif display == b"     DIAG  ":
            self._parse_diag(display)
        elif display[6:9] in (b"MIN", b"MAX"):
            self._parse_volume(display)
        elif display[0:1].isdigit() and display[1:2] == b" ":
            self._parse_safe(display)
        elif display[0:4] == b"    " and display[9:11] == b"  ":
            self._parse_safe(display)
        elif display == b"    NO CODE":
            self._parse_safe(display)
        elif display == b"    INITIAL":
            self._parse_initial(display)
        elif display == b"    MONSOON":
            self._parse_monsoon(display)
        elif display[0:3] == b"BAS":
            self._parse_sound_bass(display)
        elif display[0:3] == b"TRE":
            self._parse_sound_treble(display)
        elif display[0:3] == b"MID":
            self._parse_sound_midrange(display)
        elif display[0:3] == b"BAL":
            self._parse_sound_balance(display)
        elif display[0:3] == b"FAD":
            self._parse_sound_fade(display)
        elif display[0:3] == b"SET" or display[0:9] == b"TAPE SKIP":
            self._parse_set(display)
        elif display[0:3] in (b"FER", b"RAD", b"VER", b"Ver"):
            self._parse_test(display)
        elif display[1:4].isdigit():
            self._parse_test(display)
        elif display[0:3] == b"TAP" or display == b"    NO TAPE":
            self._parse_tape(display)
        elif display[0:2] == b"CD" or display[4:6] == b"CD":
            self._parse_cd(display)
        elif display[0:3] in (b"CHK", b"CUE", b"REV"):
            self._parse_cd(display)
        elif display in (b"NO  CHANGER", b"NO  MAGAZIN", b"    NO DISC"):
            self._parse_cd(display)
        elif display[8:11] in (b"MHZ", b"MHz"):
            self._parse_tuner_fm(display)
        elif display[8:11] in (b"KHZ", b"kHz"):
            self._parse_tuner_am(display)
        else:
            self._parse_unknown(display)

    def _parse_safe(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        if display[0:1].isdigit():
            self.safe_tries = int(display[0:1])
        else:
            self.safe_tries = 0

        if display == b"    NO CODE":
            self.operation_mode = OperationModes.SAFE_NO_CODE
            self.safe_code = 0
        elif display[5:9] == b"SAFE":
            self.operation_mode = OperationModes.SAFE_LOCKED
            self.safe_code = 1000
        elif display[4:5].isdigit() and display[4:8].isdigit(): # Premium 5
            self.operation_mode = OperationModes.SAFE_ENTRY
            self.safe_code = int(display[4:8])
        elif display[5:6].isdigit() and display[5:9].isdigit(): # Premium 4
            self.operation_mode = OperationModes.SAFE_ENTRY
            self.safe_code = int(display[5:9])
        else:
            self._parse_unknown(display)

    def _parse_initial(self, display):
        if display == b"    INITIAL":
            self.display_mode = DisplayModes.SHOWING_OPERATION
            self.operation_mode = OperationModes.INITIALIZING
        else:
            self._parse_unknown(display)

    def _parse_monsoon(self, display):
        if display == b"    MONSOON":
            self.display_mode = DisplayModes.SHOWING_OPERATION
            self.operation_mode = OperationModes.MONSOON
        else:
            self._parse_unknown(display)

    def _parse_diag(self, display):
        if display == b"     DIAG  ":
            self.display_mode = DisplayModes.SHOWING_OPERATION
            self.operation_mode = OperationModes.DIAGNOSTICS
        else:
            self._parse_unknown(display)

    def _parse_set(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if display[0:9] == b"SET ONVOL":
            self.operation_mode = OperationModes.SETTING_ON_VOL
            self.option_on_vol = int(display[9:11])
        elif display[0:10] == b"SET CD MIX":
            self.operation_mode = OperationModes.SETTING_CD_MIX
            self.option_cd_mix = int(display[10:11]) # 1 or 6
        elif display[0:9] == b"TAPE SKIP":
            self.operation_mode = OperationModes.SETTING_TAPE_SKIP
            if display[10:11] == b"Y":
                self.option_tape_skip = 1
            else: # 'N'
                self.option_tape_skip = 0
        else:
            self._parse_unknown(display)

    def _parse_test(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if display[0:4] == b"FERN":
            self.operation_mode = OperationModes.TESTING_FERN
            if display[8:9] == b"F": # b"OFF"
                self.test_fern = 0
            else: # b"ON"
                self.test_fern = 1
        elif display[0:4] == b"Vers": # Premium 5
            self.operation_mode = OperationModes.TESTING_VER
            self.test_ver = display[4:11]
        elif display[0:3] == b"VER": # Premium 4
            self.operation_mode = OperationModes.TESTING_VER
            self.test_ver = display[4:11]
        elif display[0:3] == b"RAD":
            self.operation_mode = OperationModes.TESTING_RAD
            self.test_rad = display[4:11]
        elif display[1:4].isdigit(): # Premium 5
            self.operation_mode = OperationModes.TESTING_SIGNAL

            freq = display[0:4]
            if freq[0:1] == b" ": # b' 530A 2 6 F'
                freq = b"0" + freq[1:]
            self.test_signal_freq = int(freq) # 97.7MHz=977, 540KHz=540

            # b' 530A 2 6 F' = 0xA26F
            self.test_signal_strength = int(display[4:].replace(b' ', b''), 16)
        else:
            self._parse_unknown(display)

    def _parse_tuner_fm(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        freq = display[4:8]
        if freq[0:1] == b" ": # b" 881"
            freq = b"0" + freq[1:]
        self.tuner_freq = int(freq) # 102.3 MHz = 1023

        if display[0:4] == b"SCAN":
            self.operation_mode = OperationModes.TUNER_SCANNING
            self.tuner_preset = 0
            if self.tuner_band not in (TunerBands.FM1, TunerBands.FM2):
                self.tuner_band = TunerBands.FM1
        elif display[0:3] in (b"FM1", b"FM2"):
            self.operation_mode = OperationModes.TUNER_PLAYING
            if display[2:3] == b"1":
                self.tuner_band = TunerBands.FM1
            else: # b"2"
                self.tuner_band = TunerBands.FM2

            if display[3:4].isdigit():
                self.tuner_preset = int(display[3:4])
            else: # " " no preset
                self.tuner_preset = 0
        else:
            self._parse_unknown(display)

    def _parse_tuner_am(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        freq = display[4:8]
        if freq[0:1] == b" ": # " 540"
            freq = b"0" + freq[1:]
        if freq.isdigit():
            self.tuner_freq = int(freq) # 1640 kHz = 1640

        self.tuner_band = TunerBands.AM

        if display[0:4] == b"SCAN":
            self.operation_mode = OperationModes.TUNER_SCANNING
            self.tuner_preset = 0
        else:
            self.operation_mode = OperationModes.TUNER_PLAYING
            if display[3:4].isdigit():
                self.tuner_preset = int(display[3:4])
            else: # no preset
                self.tuner_preset = 0

    def _parse_cd(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if display == b"CHK MAGAZIN":
            self.operation_mode = OperationModes.CD_CHECK_MAGAZINE
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif display == b"NO  CHANGER":
            self.operation_mode = OperationModes.CD_NO_CHANGER
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif display == b"NO  MAGAZIN":
            self.operation_mode = OperationModes.CD_NO_MAGAZINE
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif display == b"    NO DISC":
            self.operation_mode = OperationModes.CD_NO_DISC
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif display[0:4] == b"SCAN": # "SCANCD1TR04"
            self.operation_mode = OperationModes.CD_SCANNING
            self.cd_disc = int(display[6:7])
            self.cd_track = int(display[9:11])
            self.cd_track_pos = 0
        elif display[0:3] == b"CD ": # "CD 1"... to "CD 6"...
            self.cd_disc = int(display[3:4])
            self.cd_track_pos = 0
            if display[4:10] == b"CD ERR": # "CD 1CD ERR " (Premium 5)
                self.operation_mode = OperationModes.CD_CDX_CD_ERR
                self.cd_track = 0
            elif display[5:10] == b"NO CD": # "CD 1 NO CD "
                self.operation_mode = OperationModes.CD_CDX_NO_CD
                self.cd_track = 0
            elif display[5:7] == b"TR": # "CD 1 TR 03 "
                self.operation_mode = OperationModes.CD_PLAYING
                self.cd_track = int(display[8:10])
            elif display[8:9].isdigit(): # "CD 1  047  "
                self.operation_mode = OperationModes.CD_PLAYING
                self._parse_cd_track_pos(display)
            else:
                self._parse_unknown(display)
        elif display[0:2] == b"CD": # "CD1"... to "CD6"...
            self.cd_disc = int(display[2:3])
            self.cd_track_pos = 0
            if display[4:10] == b"CD ERR": # "CD1 CD ERR " (Premium 4)
                self.operation_mode = OperationModes.CD_CDX_CD_ERR
                self.cd_track = 0
            else:
                self._parse_unknown(display)
        elif display[0:3] == b"CUE": # "CUE   034  "
            self.operation_mode = OperationModes.CD_CUE
            self._parse_cd_track_pos(display)

        elif display[0:3] == b"REV": # "REV   209  "
            self.operation_mode = OperationModes.CD_REV
            self._parse_cd_track_pos(display)
        else:
            self._parse_unknown(display)

    def _parse_cd_track_pos(self, display):
        if display[4:5] == b'-' or display[5:6] == b'-':
            self.cd_track_pos = 0
        else:
            minutes = 0
            if display[5:6].isdigit():
                minutes += int(display[5:6]) * 10
            if display[6:7].isdigit():
                minutes += int(display[6:7])

            seconds = 0
            if display[7:8].isdigit():
                seconds += int(display[7:8]) * 10
            if display[8:9].isdigit():
                seconds += int(display[8:9])

            self.cd_track_pos = (minutes * 60) + seconds

    def _parse_tape(self, display):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if display in (b"TAPE PLAY A", b"TAPE PLAY B"):
            self.operation_mode = OperationModes.TAPE_PLAYING
            if display[10:11] == b"A":
                self.tape_side = 1
            else: # "B"
                self.tape_side = 2
        elif display in (b"TAPE SCAN A", b"TAPE SCAN B"):
            self.operation_mode = OperationModes.TAPE_SCANNING
            if display[10:11] == b"A":
                self.tape_side = 1
            else: # "B"
                self.tape_side = 2
        elif display in (b"TAPE  FF   ", b"TAPE  REW  "):
            if display[6:9] == b"REW":
                self.operation_mode = OperationModes.TAPE_REW
            else: # "FF "
                self.operation_mode = OperationModes.TAPE_FF
        elif display in (b"TAPEMSS FF ", b"TAPEMSS REW"):
            if display[8:11] == b"REW":
                self.operation_mode = OperationModes.TAPE_MSS_REW
            else: # "FF "
                self.operation_mode = OperationModes.TAPE_MSS_FF
        elif display == b"TAPE  BLS  ":
            self.operation_mode = OperationModes.TAPE_BLS
        elif display == b"TAPE METAL ":
            self.operation_mode = OperationModes.TAPE_METAL
        elif display == b"    NO TAPE":
            self.operation_mode = OperationModes.TAPE_NO_TAPE
            self.tape_side = 0
        elif display == b"TAPE ERROR ":
            self.operation_mode = OperationModes.TAPE_ERROR
            self.tape_side = 0
        elif display == b"TAPE LOAD  ":
            self.operation_mode = OperationModes.TAPE_LOAD
            self.tape_side = 0
        else:
            self._parse_unknown(display)

    def _parse_volume(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME

    def _parse_sound_balance(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_BALANCE
        if display[4:5] == b"C":
            self.sound_balance = 0  # Center
        elif display[4:5] == b"R" and display[10:11].isdigit():
            self.sound_balance = int(display[10:11])  # Right
        elif display[4:5] == b"L" and display[10:11].isdigit():
            self.sound_balance = -int(display[10:11])  # Left
        else:
            self._parse_unknown(display)

    def _parse_sound_fade(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_FADE
        if display[4:5] == b"C":
            self.sound_fade = 0  # Center
        elif display[4:5] == b"F" and display[10:11].isdigit():
            self.sound_fade = int(display[10:11])  # Front
        elif display[4:5] == b"R" and display[10:11].isdigit():
            self.sound_fade = -int(display[10:11])  # Rear
        else:
            self._parse_unknown(display)

    def _parse_sound_bass(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_BASS
        if display[8:9].isdigit():
            self.sound_bass = int(display[8:9])
            if display[6:7] == b"-":
                self.sound_bass = self.sound_bass * -1
        else:
            self._parse_unknown(display)

    def _parse_sound_treble(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_TREBLE
        if display[8:9].isdigit():
            self.sound_treble = int(display[8:9])
            if display[6:7] == b"-":
                self.sound_treble = self.sound_treble * -1
        else:
            self._parse_unknown(display)

    def _parse_sound_midrange(self, display):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_MIDRANGE
        if display[8:9].isdigit():
            self.sound_midrange = int(display[8:9])
            if display[6:7] == b"-":
                self.sound_midrange = self.sound_midrange * -1
        else:
            self._parse_unknown(display)

    def _parse_unknown(self, display):
        raise ValueError("Unrecognized: %r" % display)
