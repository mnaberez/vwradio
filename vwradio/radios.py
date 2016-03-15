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
        self.option_on_vol = 0 # 13-63 on Premium 4
        self.option_cd_mix = 1 # 1 or 6
        self.option_tape_skip = 0 # 0=no, 1=yes

    def parse(self, text):
        if text == ' ' * 11:
            pass # blank
        elif text == "     DIAG  ":
            self._parse_diag(text)
        elif text[6:9] in ("MIN", "MAX"):
            self._parse_volume(text)
        elif str.isdigit(text[0]) and text[1] == " ":
            self._parse_safe(text)
        elif text[0:4] == "    " and text[9:11] == "  ":
            self._parse_safe(text)
        elif text == "    NO CODE":
            self._parse_safe(text)
        elif text == "    INITIAL":
            self._parse_initial(text)
        elif text[0:3] == "BAS":
            self._parse_sound_bass(text)
        elif text[0:3] == "TRE":
            self._parse_sound_treble(text)
        elif text[0:3] == "MID":
            self._parse_sound_midrange(text)
        elif text[0:3] == "BAL":
            self._parse_sound_balance(text)
        elif text[0:3] == "FAD":
            self._parse_sound_fade(text)
        elif text[0:3] == "SET" or text[0:9] == 'TAPE SKIP':
            self._parse_set(text)
        elif text[0:3] == "TAP" or text == "    NO TAPE":
            self._parse_tape(text)
        elif text[0:2] == "CD" or text[0:3] in ("CHK", "CUE", "REV"):
            self._parse_cd(text)
        elif text in ("NO  CHANGER", "    NO DISC"):
            self._parse_cd(text)
        elif text[8:11] in ("MHZ", "MHz"):
            self._parse_tuner_fm(text)
        elif text[8:11] in ("KHZ", "kHz"):
            self._parse_tuner_am(text)
        else:
            self._parse_unknown(text)

    def _parse_safe(self, text):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        if str.isdigit(text[0]):
            self.safe_tries = int(text[0])
        else:
            self.safe_tries = 0

        if text == "    NO CODE":
            self.operation_mode = OperationModes.SAFE_NO_CODE
            self.safe_code = 0
        elif text[5:9] == "SAFE":
            self.operation_mode = OperationModes.SAFE_LOCKED
            self.safe_code = 1000
        elif str.isdigit(text[4]) and str.isdigit(text[4:8]): # Premium 5
            self.operation_mode = OperationModes.SAFE_ENTRY
            self.safe_code = int(text[4:8])
        elif str.isdigit(text[5]) and str.isdigit(text[5:9]): # Premium 4
            self.operation_mode = OperationModes.SAFE_ENTRY
            self.safe_code = int(text[5:9])
        else:
            self._parse_unknown(text)

    def _parse_initial(self, text):
        if text == "    INITIAL":
            self.display_mode = DisplayModes.SHOWING_OPERATION
            self.operation_mode = OperationModes.INITIALIZING
        else:
            self._parse_unknown(text)

    def _parse_diag(self, text):
        if text == "     DIAG  ":
            self.display_mode = DisplayModes.SHOWING_OPERATION
            self.operation_mode = OperationModes.DIAGNOSTICS
        else:
            self._parse_unknown(text)

    def _parse_set(self, text):
        if text[0:9] == "SET ONVOL":
            self.display_mode = DisplayModes.SETTING_OPTION_ON_VOL
            self.option_on_vol = int(text[9:11])
        elif text[0:10] == "SET CD MIX":
            self.display_mode = DisplayModes.SETTING_OPTION_CD_MIX
            self.option_cd_mix = int(text[10]) # 1 or 6
        elif text[0:9] == "TAPE SKIP":
            self.display_mode = DisplayModes.SETTING_OPTION_TAPE_SKIP
            if text[10] == "Y":
                self.option_tape_skip = 1
            else: # 'N'
                self.option_tape_skip = 0
        else:
            self._parse_unknown(text)

    def _parse_tuner_fm(self, text):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        freq = text[4:8]
        if freq[0] == " ": # " 881"
            freq = "0" + freq[1:]
        if str.isdigit(freq):
            self.tuner_freq = int(freq) # 102.3 MHz = 1023

        if text[0:4] == "SCAN":
            self.operation_mode = OperationModes.TUNER_SCANNING
            self.tuner_preset = 0
            if self.tuner_band not in (TunerBands.FM1, TunerBands.FM2):
                self.tuner_band = TunerBands.FM1
        elif text[0:3] in ("FM1", "FM2"):
            self.operation_mode = OperationModes.TUNER_PLAYING
            if text[2] == "1":
                self.tuner_band = TunerBands.FM1
            else: # "2"
                self.tuner_band = TunerBands.FM2

            if str.isdigit(text[3]):
                self.tuner_preset = int(text[3])
            else: # " " no preset
                self.tuner_preset = 0
        else:
            self._parse_unknown(text)

    def _parse_tuner_am(self, text):
        self.display_mode = DisplayModes.SHOWING_OPERATION

        freq = text[4:8]
        if freq[0] == " ": # " 540"
            freq = "0" + freq[1:]
        if str.isdigit(freq):
            self.tuner_freq = int(freq) # 1640 kHz = 1640

        self.tuner_band = TunerBands.AM

        if text[0:4] == "SCAN":
            self.operation_mode = OperationModes.TUNER_SCANNING
            self.tuner_preset = 0
        else:
            self.operation_mode = OperationModes.TUNER_PLAYING
            if str.isdigit(text[3]):
                self.tuner_preset = int(text[3])
            else: # no preset
                self.tuner_preset = 0

    def _parse_cd(self, text):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if text == "CHK MAGAZIN":
            self.operation_mode = OperationModes.CD_CHECK_MAGAZINE
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif text == "NO  CHANGER":
            self.operation_mode = OperationModes.CD_NO_CHANGER
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif text == "    NO DISC":
            self.operation_mode = OperationModes.CD_NO_DISC
            self.cd_disc = 0
            self.cd_track = 0
            self.cd_track_pos = 0
        elif text[0:3] == "CD ": # "CD 1" to "CD 6"
            self.cd_disc = int(text[3])
            self.cd_track_pos = 0
            if text[5:10] == "NO CD": # "CD 1 NO CD "
                self.operation_mode = OperationModes.CD_CDX_NO_CD
                self.cd_track = 0
            elif text[5:7] == "TR": # "CD 1 TR 03 "
                self.operation_mode = OperationModes.CD_PLAYING
                self.cd_track = int(text[8:10])
            elif str.isdigit(text[8]): # "CD 1  047  "
                self.operation_mode = OperationModes.CD_PLAYING
                self._parse_cd_track_pos(text)
            else:
                self._parse_unknown(text)
        elif text[0:2] == "CD": # "CD1" to "CD6"
            self.cd_disc = int(text[2])
            self.cd_track_pos = 0
            if text[4:10] == "CD ERR": # "CD1 CD ERR "
                self.operation_mode = OperationModes.CD_CDX_CD_ERR
                self.cd_track = 0
            else:
                self._parse_unknown(text)
        elif text[0:3] == "CUE": # "CUE   034  "
            self.operation_mode = OperationModes.CD_CUE
            self._parse_cd_track_pos(text)

        elif text[0:3] == "REV": # "REV   209  "
            self.operation_mode = OperationModes.CD_REV
            self._parse_cd_track_pos(text)
        else:
            self._parse_unknown(text)

    def _parse_cd_track_pos(self, text):
        if text[4] == '-' or text[5] == '-':
            self.cd_track_pos = 0
        else:
            minutes = 0
            if str.isdigit(text[5]):
                minutes += int(text[5]) * 10
            if str.isdigit(text[6]):
                minutes += int(text[6])

            seconds = 0
            if str.isdigit(text[7]):
                seconds += int(text[7]) * 10
            if str.isdigit(text[8]):
                seconds += int(text[8])

            self.cd_track_pos = (minutes * 60) + seconds

    def _parse_tape(self, text):
        self.display_mode = DisplayModes.SHOWING_OPERATION
        if text in ("TAPE PLAY A", "TAPE PLAY B"):
            self.operation_mode = OperationModes.TAPE_PLAYING
            if text[10] == "A":
                self.tape_side = 1
            else: # "B"
                self.tape_side = 2
        elif text in ("TAPE  FF   ", "TAPE  REW  "):
            if text[6:9] == "REW":
                self.operation_mode = OperationModes.TAPE_REW
            else: # "FF "
                self.operation_mode = OperationModes.TAPE_FF
        elif text in ("TAPEMSS FF ", "TAPEMSS REW"):
            if text[8:11] == "REW":
                self.operation_mode = OperationModes.TAPE_MSS_REW
            else: # "FF "
                self.operation_mode = OperationModes.TAPE_MSS_FF
        elif text == "TAPE METAL ":
            self.operation_mode = OperationModes.TAPE_METAL
        elif text == "    NO TAPE":
            self.operation_mode = OperationModes.TAPE_NO_TAPE
            self.tape_side = 0
        elif text == "TAPE ERROR ":
            self.operation_mode = OperationModes.TAPE_ERROR
            self.tape_side = 0
        elif text == "TAPE LOAD  ":
            self.operation_mode = OperationModes.TAPE_LOAD
            self.tape_side = 0
        else:
            self._parse_unknown(text)

    def _parse_volume(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_VOLUME

    def _parse_sound_balance(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_BALANCE
        if text[4] == "C":
            self.sound_balance = 0  # Center
        elif text[4] == "R" and str.isdigit(text[10]):
            self.sound_balance = int(text[10])  # Right
        elif text[4] == "L" and str.isdigit(text[10]):
            self.sound_balance = -int(text[10])  # Left
        else:
            self._parse_unknown(text)

    def _parse_sound_fade(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_FADE
        if text[4] == "C":
            self.sound_fade = 0  # Center
        elif text[4] == "F" and str.isdigit(text[10]):
            self.sound_fade = int(text[10])  # Front
        elif text[4] == "R" and str.isdigit(text[10]):
            self.sound_fade = -int(text[10])  # Rear
        else:
            self._parse_unknown(text)

    def _parse_sound_bass(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_BASS
        if str.isdigit(text[8]):
            self.sound_bass = int(text[8])
            if text[6] == "-":
                self.sound_bass = self.sound_bass * -1
        else:
            self._parse_unknown(text)

    def _parse_sound_treble(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_TREBLE
        if str.isdigit(text[8]):
            self.sound_treble = int(text[8])
            if text[6] == "-":
                self.sound_treble = self.sound_treble * -1
        else:
            self._parse_unknown(text)

    def _parse_sound_midrange(self, text):
        self.display_mode = DisplayModes.ADJUSTING_SOUND_MIDRANGE
        if str.isdigit(text[8]):
            self.sound_midrange = int(text[8])
            if text[6] == "-":
                self.sound_midrange = self.sound_midrange * -1
        else:
            self._parse_unknown(text)

    def _parse_unknown(self, text):
        raise ValueError("Unrecognized: %r" % text)
