
class Enum(object):
    '''Abstract'''
    @classmethod
    def get_name(klass, value):
        for k, v in klass.__dict__.items():
            if v == value:
                return k
        return None

class OperationModes(Enum):
    UNKNOWN = 0
    SAFE_ENTRY = 10
    SAFE_LOCKED = 11
    SAFE_NO_CODE = 12
    TUNER_PLAYING = 20
    TUNER_SCANNING = 21
    CD_PLAYING = 30
    CD_CUEING = 31
    CD_NO_DISC = 32
    CD_NO_CHANGER = 33
    CD_CHECK_MAGAZINE = 34
    CD_CDX_NO_CD = 35
    CD_CDX_CD_ERR = 36
    TAPE_PLAYING = 40
    TAPE_LOAD = 41
    TAPE_METAL = 42
    TAPE_FF = 43
    TAPE_REW = 44
    TAPE_MSS_FF = 45
    TAPE_MSS_REW = 46
    TAPE_NO_TAPE = 47
    TAPE_ERROR = 48

class DisplayModes(Enum):
    UNKNOWN = 0
    SHOWING_OPERATION = 10
    ADJUSTING_SOUND_VOLUME = 20
    ADJUSTING_SOUND_BALANCE = 21
    ADJUSTING_SOUND_FADE = 22
    ADJUSTING_SOUND_BASS = 23
    ADJUSTING_SOUND_TREBLE = 24
    ADJUSTING_SOUND_MIDRANGE = 25

class TunerBands(Enum):
    UNKNOWN = 0
    FM1 = 1
    FM2 = 2
    AM = 3

class Keys(Enum):
    NONE = 0
    PRESET_1 = 1
    PRESET_2 = 2
    PRESET_3 = 3
    PRESET_4 = 4
    PRESET_5 = 5
    PRESET_6 = 6
    POWER = 7
    SOUND_BASS = 10
    SOUND_TREB = 11
    SOUND_FADE = 12
    SOUND_BAL = 13
    SOUND_MID = 14
    SOUND_FB = 15
    TUNE_UP = 20
    TUNE_DOWN = 21
    SEEK_UP = 22
    SEEK_DOWN = 23
    SCAN = 24
    MODE_CD = 30
    MODE_AM = 31
    MODE_FM = 32
    MODE_TAPE = 33
    TAPE_SIDE = 40
    STOP_EJECT = 41
    MIX_DOLBY = 42
    HIDDEN_INITIAL = 50
    HIDDEN_NO_CODE = 51
    HIDDEN_VOL_UP = 52
    HIDDEN_VOL_DOWN = 53
    HIDDEN_SEEK_UP = 54
    HIDDEN_SEEK_DOWN = 55

class Pictographs(Enum):
    NONE = 0
    PERIOD = 1
    MIX = 2
    TAPE_METAL = 10
    TAPE_DOLBY = 11
    MODE_AMFM = 20
    MODE_CD = 21
    MODE_TAPE = 22
