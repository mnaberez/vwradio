from vwradio.faceplates import Enum

class RadioModes(Enum):
    UNKNOWN = 0
    SAFE_ENTRY = 10
    SAFE_LOCKED = 11
    RADIO_AM = 20
    RADIO_FM1 = 21
    RADIO_FM2 = 22
    CD_PLAYING = 30
    CD_CUEING = 31
    CD_NO_CD = 32
    CD_NO_DISC = 33
    CD_NO_CHANGER = 34
    CD_CHECK_MAGAZINE = 35
    TAPE_PLAYING = 40
    TAPE_MSS_FF = 41
    TAPE_MSS_REW = 42
    TAPE_NO_TAPE = 43
    TAPE_ERROR = 44


class Radio(object):
    def __init__(self):
        self.text = ' ' * 11
        self.mode = RadioModes.UNKNOWN
        self.safe_code = 1000
        self.safe_tries = 0
        self.sound_balance = 0 # left -9, center 0, right +9
        self.sound_fade = 0 # rear -9, center 0, front +9
        self.sound_bass = 0 # -9 to 9
        self.sound_treble = 0 # -9 to 9
        self.radio_freq = 0 # 883=88.3 MHz, 5400=540.0 KHz
        self.radio_preset = 0 # 0=none, am/fm1/fm2 preset 1-6
        self.radio_scanning = False # True if tuner is scanning
        self.cd_disc = 0 # 0=none, disc 1-6
        self.cd_track = 0 # 0=none, track 1-99
        self.tape_side = 0 # 0=none, 1=side a, 2=side b

    def process(self, text):
        if text == ' ' * 11:
            pass # blank
        elif text[6:9] in ('MIN', 'MAX'):
            pass # volume min or max
        elif str.isdigit(text[0]):
            self._process_safe(text)
        elif text[0:4] == '    ' and text[9:11] == '  ':
            self._process_safe(text)
        elif text[0:3] == 'BAS':
            self._process_bass(text)
        elif text[0:3] == 'TRE':
            self._process_treble(text)
        elif text[0:3] == 'BAL':
            self._process_balance(text)
        elif text[0:3] == 'FAD':
            self._process_fade(text)
        elif text[0:3] == 'TAP':
            self._process_tape(text)
        elif text[0:3] in ('CD ', 'CUE', 'CHK'):
            self._process_cd(text)
        elif text in ('NO  CHANGER', '    NO DISC'):
            self._process_cd(text)
        elif text[8:11] in ('MHZ', 'MHz'):
            self._process_fm(text)
        elif text[8:11] in ('KHZ', 'kHz'):
            self._process_am(text)
        else:
            self._process_unknown(text)
        self.text = text

    def _process_safe(self, text):
        if str.isdigit(text[0]):
            self.safe_tries = int(text[0])
        else:
            self.safe_tries = 0

        safe_or_code = text[5:9]
        if safe_or_code == 'SAFE':
            self.mode = RadioModes.SAFE_LOCKED
            self.safe_code = 1000
        elif str.isdigit(safe_or_code):
            self.mode = RadioModes.SAFE_ENTRY
            self.safe_code = int(safe_or_code)
        else:
            self._process_unknown(text)

    def _process_balance(self, text):
        if text[4] == 'C':
            self.sound_balance = 0  # Center
        elif text[4] == 'L' and str.isdigit(text[10]):
            self.sound_balance = int(text[10])  # Left
        elif text[4] == 'R' and str.isdigit(text[10]):
            self.sound_balance = -int(text[10])  # Right
        else:
            self._process_unknown(text)

    def _process_fade(self, text):
        if text[4] == 'C':
            self.sound_fade = 0  # Center
        elif text[4] == 'F' and str.isdigit(text[10]):
            self.sound_fade = int(text[10])  # Front
        elif text[4] == 'R' and str.isdigit(text[10]):
            self.sound_fade = -int(text[10])  # Rear
        else:
            self._process_unknown(text)

    def _process_bass(self, text):
        if str.isdigit(text[8]):
            if text[6] == '-':
                self.sound_bass = -int(text[8])
            else:
                self.sound_bass = int(text[8])
        else:
            self._process_unknown(text)

    def _process_treble(self, text):
        if str.isdigit(text[8]):
            if text[6] == '-':
                self.sound_treble = -int(text[8])
            else:
                self.sound_treble = int(text[8])
        else:
            self._process_unknown(text)

    def _process_fm(self, text):
        freq = text[4:8]
        if freq[0] == ' ': # " 881"
            freq = '0' + freq[1:]
        if str.isdigit(freq):
            self.radio_freq = int(freq)

        if text[0:4] == 'SCAN':
            self.radio_scanning = True
            self.radio_preset = 0
        elif text[0:3] in ('FM1', 'FM2'):
            if text[2] == '1':
                self.mode = RadioModes.RADIO_FM1
            elif text[2] == '2': # "2"
                self.mode = RadioModes.RADIO_FM2

            if str.isdigit(text[3]):
                self.radio_preset = int(text[3])
            else: # " " no preset
                self.radio_preset = 0
        else:
            self._process_unknown(text)

    def _process_am(self, text):
        freq = text[4:8]
        if freq[0] == ' ': # " 540"
            freq = '0' + freq[1:]
        if str.isdigit(freq):
            self.radio_freq = int(freq) * 10

        self.mode = RadioModes.RADIO_AM

        if text[0:4] == 'SCAN':
            self.radio_scanning = True
            self.radio_preset = 0
        else:
            self.radio_scanning = False
            if str.isdigit(text[3]):
                self.radio_preset = int(text[3])
            else: # no preset
                self.radio_preset = 0

    def _process_cd(self, text):
        if text == 'CHK MAGAZIN':
            self.mode = RadioModes.CD_CHECK_MAGAZINE
            self.cd_disc = 0
            self.cd_track = 0
        elif text == 'NO  CHANGER':
            self.mode = RadioModes.CD_NO_CHANGER
            self.cd_disc = 0
            self.cd_track = 0
        elif text == '    NO DISC':
            self.mode = RadioModes.CD_NO_DISC
            self.cd_disc = 0
            self.cd_track = 0
        elif text[0:3] == 'CD ':
            self.cd_disc = int(text[3])
            if text[5:10] == 'NO CD':
                self.mode = RadioModes.CD_NO_CD
                self.cd_track = 0
            else: # "TR 01"
                self.mode = RadioModes.CD_PLAYING
                self.cd_track = int(text[8:10])
        elif text[0:3] == 'CUE':
            self.mode = RadioModes.CD_CUEING
            # TODO cue position
        else:
            self._process_unknown(text)

    def _process_tape(self, text):
        if text in ('TAPE PLAY A', 'TAPE PLAY B'):
            self.mode = RadioModes.TAPE_PLAYING
            if text[10] == 'A':
                self.tape_side = 1
            else: # "B"
                self.tape_side = 2
        elif text in ('TAPEMSS FF ', 'TAPEMSS REW'):
            if text[8:11] == 'REW':
                self.mode = RadioModes.TAPE_MSS_REW
            else: # 'FF '
                self.mode = RadioModes.TAPE_MSS_FF
        elif text == 'TAPE ERROR ':
            self.mode = RadioModes.TAPE_ERROR
            self.tape_side = 0
        else:
            self._process_unknown(text)

    def _process_unknown(self, text):
        # TODO temporary
        import sys
        sys.stderr.write("Unrecognized: %r\n" % text)
        # raise ValueError("Unrecognized: %r" % text)
