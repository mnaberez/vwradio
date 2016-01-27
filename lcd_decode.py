import gzip
import sys
import lcd_charsets

class _Enum(object):
    @classmethod
    def get_name(klass, value):
        for k, v in klass.__dict__.items():
            if v == value:
                return k
        return None

class Keys(_Enum):
    POWER = 0
    PRESET_1 = 1
    PRESET_2 = 2
    PRESET_3 = 3
    PRESET_4 = 4
    PRESET_5 = 5
    PRESET_6 = 6
    SOUND_BASS = 10
    SOUND_TREB = 11
    SOUND_FADE = 12
    SOUND_BAL = 13
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

class Pictographs(_Enum):
    PERIOD = 0
    MIX = 10
    TAPE_METAL = 20
    TAPE_DOLBY = 21
    MODE_AMFM = 30
    MODE_CD = 31
    MODE_TAPE = 32

class LcdState(object):
  '''Abstract'''

  DISPLAY_ADDRESSES = ()
  ROM_CHARSET = ()
  CHARACTERS = {}
  PICTOGRAPHS = {}
  KEYS = {}

  def __init__(self):
    self.display_data_ram = [0] * 0x19
    self.pictograph_ram = [0] * 0x08
    self.chargen_ram = [0] * 7 * 0x10
    self.led_output_ram = [0]

    self.current_ram = None
    self.address = 0
    self.increment = False

  def eval(self, session):
    self.print_session(session)

    # Command Byte
    cmd = session[0]
    cmdsel = cmd & 0b11000000

    # Process command byte
    if cmdsel == 0b00000000:
      self._cmd_display_setting(session)
    elif cmdsel == 0b01000000:
      self._cmd_data_setting(session)
    elif cmdsel == 0b10000000:
      self._cmd_address_setting(session)
    elif cmdsel == 0b11000000:
      self._cmd_status(session)
    else:
      self._cmd_unknown(session)

    # Process data bytes
    for byte in session[1:]:
      if self.current_ram is not None:
        if self.address >= len(self.current_ram):
          self.address = 0

        self.current_ram[self.address] = byte

        if self.increment:
          self.address += 1

    self.print_state()

  def _cmd_display_setting(self, session):
    print("    Display Setting Command")
    cmd = session[0]

    if (cmd & 1) == 0:
      print("    Duty setting: 0=1/8 duty")
    else:
      print("    Duty setting: 1=1/15 duty")

    if (cmd & 2) == 0:
      print("    Master/slave setting: 0=master")
    else:
      print("    Master/slave setting: 1=slave")

    if (cmd & 4) == 0:
      print("    Drive voltage supply method: 0=external")
    else:
      print("    Drive voltage supply method: 1=internal")

  def _cmd_data_setting(self, session):
    print("  Data Setting Command")
    cmd = session[0]
    mode = cmd & 0b00000111
    if mode == 0:
      print("    0=Write to display data RAM")
      self.current_ram = self.display_data_ram
    elif mode == 1:
      print("    1=Write to pictograph RAM")
      self.current_ram = self.pictograph_ram
    elif mode == 2:
      print("    2=Write to chargen ram")
      self.current_ram = self.chargen_ram
    elif mode == 3:
      print("    3=Write to LED output latch")
      self.current_ram = self.led_output_ram
    elif mode == 4: # Read key data
      print("    4=Read key data")
      self.current_ram = None
    else: # Unknown mode
      print("    ? Unknown mode ?")
      self.current_ram = None

    if mode in (0, 1):
      # display data ram or pictograph support increment flag
      incr = cmd & 0b00001000
      self.increment = incr == 0
      if self.increment:
        print("    Address increment mode: 0=increment")
      else:
        print("    Address increment mode: 1=fixed")
    else:
      # other modes are always increment
      print("    Increment mode ignored; this area always increments")
      self.increment = True

  def _cmd_address_setting(self, session):
      print("  Address Setting Command")
      cmd = session[0]
      address = cmd & 0b00011111
      print("    Address = %02x" % address)
      if self.current_ram is self.chargen_ram:
        self.address = address * 7 # character number, 7 bytes per char
      else:
        self.address = address

  def _cmd_status(self, session):
    print("  Status command")
    cmd = session[0]
    if (cmd & 32) == 0:
      print("    Test mode setting: 0=Normal operation")
    else:
      print("    Test mode setting: 1=Test Mode")

    if (cmd & 16) == 0:
      print("    Standby mode setting: 0=Normal operation")
    else:
      print("    Standby mode setting: 1=Standby mode")

    if (cmd & 8) == 0:
      print("    Key scan control: 0=Key scanning stopped")
    else:
      print("    Key scan control: 1=Key scan operation")

    if (cmd & 4) == 0:
      print("    LED control: 0=LED forced off")
    else:
      print("    LED control: 1=Normal operation")

    lcd_mode = cmd & 0b00000011
    if lcd_mode == 0:
      print("    LCD mode: 0=LCD forced off (SEGn, COMn=Vlc5)")
    elif lcd_mode == 1:
      print("    LCD mode: 1=LCD forced off (SEGn, COMn=unselected waveform")
    elif lcd_mode == 2:
      print("    LCD mode: 2=Normal operation (0b00)")
    else: # 3
      print("    LCD mode: 3=Normal operation (0b11)")

  def _cmd_unknown(self, session):
    print("? Unknown command ?")

  def _read_char_data(self, char_code):
    charset = self.chargen_ram if char_code < 0x10 else self.ROM_CHARSET
    start = char_code * 7
    end = start + 7
    return charset[start:end]

  def _draw_chars(self, data, addresses):
    heading = ''.join(['0x%02x:  ' % a for a in addresses])
    lines = [heading]

    for row in range(7):
      line = ''
      for charnum in range(len(addresses)):
        byte = data[(charnum * 7) + row]
        line += (format(byte, '#010b')[5:].
                  replace('0', '.').replace('1', 'O') + '  ')
      lines.append(line)
    return lines

  def draw_display_ram(self):
    data = []
    for address in self.DISPLAY_ADDRESSES:
      char_code = self.display_data_ram[address]
      data.extend(self._read_char_data(char_code))
    return self._draw_chars(data, self.DISPLAY_ADDRESSES)

  def draw_chargen_ram(self):
    return self._draw_chars(self.chargen_ram, range(0x10))

  def decode_display_ram(self):
    decoded = ''
    for address in self.DISPLAY_ADDRESSES:
      byte = self.display_data_ram[address]
      if byte in range(16):
        decoded += "<cgram:0x%02x>" % byte
      else:
        decoded += self.CHARACTERS.get(byte, '?')
    return decoded

  def decode_pictographs(self):
    names = []
    for offset in range(8):
      for bit in range(8):
        if self.pictograph_ram[offset] & (2**bit):
          pictograph = self.PICTOGRAPHS.get(offset, {}).get(bit, None)
          if pictograph is None:
            name = "<unknown at byte %d, bit %d>" % (offset, bit)
          else:
            name = Pictographs.get_name(pictograph)
          names.append(name)
    return '[%s]' % ', '.join(names)

  def _hexdump(self, list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])

  def print_state(self):
    print('Chargen RAM: ' + self._hexdump(self.chargen_ram))
    print('Pictograph RAM: ' + self._hexdump(self.pictograph_ram))
    print('Display Data RAM: ' + self._hexdump(self.display_data_ram))
    print('LED Output Latch: 0x%02x' % self.led_output_ram[0])
    print('Drawn Chargen RAM:')
    for line in self.draw_chargen_ram():
      print('  ' + line)
    print('Drawn Display Data RAM:')
    for line in self.draw_display_ram():
      print('  ' + line)
    print('Decoded Display Data RAM: %r' % self.decode_display_ram())
    print('Decoded Pictographs: ' + self.decode_pictographs())
    print('')

  def print_session(self, session):
    print("Session: " + self._hexdump(session))
    for i, byte in enumerate(session):
      desc = "Command byte" if i == 0 else "Data byte"
      print("  %s = 0x%02x (%s)" % (desc, byte, format(byte, '#010b')))
    print('')


class Premium4(LcdState):
  DISPLAY_ADDRESSES = tuple(range(0x0c, 1, -1))
  ROM_CHARSET = lcd_charsets.PREMIUM_4
  CHARACTERS = {
    0x10: " ",
    0x11: " ",
    0x12: " ",
    0x13: " ",
    0x14: " ",
    0x15: " ",
    0x16: " ",
    0x17: " ",
    0x18: " ",
    0x19: " ",
    0x1a: " ",
    0x1b: " ",
    0x1c: " ",
    0x1d: " ",
    0x1e: " ",
    0x1f: " ",
    0x20: " ",
    0x21: "!",
    0x22: '"',
    0x23: "#",
    0x24: "$",
    0x25: "%",
    0x26: "&",
    0x27: "'",
    0x28: "(",
    0x29: ")",
    0x2a: "*",
    0x2b: "+",
    0x2c: ",",
    0x2d: "-",
    0x2e: ".",
    0x2f: "/",
    0x30: "0",
    0x31: "1",
    0x32: "2",
    0x33: "3",
    0x34: "4",
    0x35: "5",
    0x36: "6",
    0x37: "7",
    0x38: "8",
    0x39: "9",
    0x3a: ":",
    0x3b: ";",
    0x3c: "<",
    0x3d: "=",
    0x3e: ">",
    0x3f: "?",
    0x40: "@",
    0x41: "A",
    0x42: "B",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x49: "I",
    0x4a: "J",
    0x4b: "K",
    0x4c: "L",
    0x4d: "M",
    0x4e: "N",
    0x4f: "O",
    0x50: "P",
    0x51: "Q",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x55: "U",
    0x56: "V",
    0x57: "W",
    0x58: "X",
    0x59: "Y",
    0x5a: "Z",
    0x5b: "[",
    0x5c: "\\",
    0x5d: "]",
    0x5e: "^",
    0x5f: "_",
    0x60: "`",
    0x61: "a",
    0x62: "b",
    0x63: "c",
    0x64: "d",
    0x65: "e",
    0x66: "f",
    0x67: "g",
    0x68: "h",
    0x69: "i",
    0x6a: "j",
    0x6b: "k",
    0x6c: "l",
    0x6d: "m",
    0x6e: "n",
    0x6f: "o",
    0x70: "p",
    0x71: "q",
    0x72: "r",
    0x73: "s",
    0x74: "t",
    0x75: "u",
    0x76: "v",
    0x77: "w",
    0x78: "x",
    0x79: "y",
    0x7a: "z",
    0x7b: "{",
    0x7c: "|",
    0x7d: "}",
    0x7e: "~",
    0xe0: "A",
    0xe1: "B",
    0xe2: "N",
    0xe3: "V",
    0xe4: "0",
    0xe5: "1",
    0xe6: "3",
    0xe7: "4",
    0xe8: "5",
    0xe9: "6",
    0xea: "9",
    0xeb: "1", # for FM1
    0xec: "2", # for FM2
    0xed: "2", # for preset 2
    0xee: "3", # for preset 3
    0xef: "4", # for preset 4
    0xf0: "5", # for preset 5
    0xf1: "6",
    0xf2: "6", # for preset 6
    0xf3: "2",
    0xf4: " ",
    0xf5: " ",
    0xf6: " ",
    0xf7: " ",
    0xf8: " ",
    0xf9: " ",
    0xfa: " ",
    0xfb: " ",
    }

  PICTOGRAPHS = {
    7: {3: Pictographs.TAPE_METAL},
    6: {5: Pictographs.TAPE_DOLBY,
        0: Pictographs.MIX},
    3: {6: Pictographs.PERIOD},
    2: {3: Pictographs.MODE_AMFM},
    1: {0: Pictographs.MODE_CD,
        5: Pictographs.MODE_TAPE},
    }

  KEYS = {
    2: {5: Keys.TAPE_SIDE,
        4: Keys.SEEK_UP,
        3: Keys.MIX_DOLBY,
        1: Keys.SCAN,
        0: Keys.SEEK_DOWN},

    1: {7: Keys.MODE_FM,
        6: Keys.MODE_AM,
        5: Keys.TUNE_UP,
        4: Keys.SOUND_BAL,
        3: Keys.MODE_CD,
        2: Keys.MODE_TAPE,
        1: Keys.TUNE_DOWN,
        0: Keys.SOUND_FADE},

    0: {7: Keys.PRESET_6,
        6: Keys.PRESET_5,
        5: Keys.PRESET_4,
        4: Keys.SOUND_BASS,
        3: Keys.PRESET_3,
        2: Keys.PRESET_2,
        1: Keys.PRESET_1,
        0: Keys.SOUND_TREB}
  }


class Premium5(LcdState):
  DISPLAY_ADDRESSES = tuple(range(11))
  ROM_CHARSET = lcd_charsets.PREMIUM_5

  CHARACTERS = {
    0x20: " ",
    0x2b: "+",
    0x2d: "-",
    0x30: "0",
    0x31: "1",
    0x32: "2",
    0x33: "3",
    0x34: "4",
    0x35: "5",
    0x36: "6",
    0x37: "7",
    0x38: "8",
    0x39: "9",
    0x41: "A",
    0x42: "B",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x49: "I",
    0x4c: "L",
    0x4d: "M",
    0x4e: "N",
    0x4f: "O",
    0x50: "P",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x58: "X",
    0x59: "Y",
    0x6b: "k",
    0x7a: "z",
    }

  PICTOGRAPHS = {
    4: {5: Pictographs.PERIOD},
    2: {7: Pictographs.TAPE_METAL},
    1: {2: Pictographs.TAPE_DOLBY},
    # TODO MIX
    }

  KEYS = {} # TODO key map


def parse_analyzer_file(filename, lcd):
  session = []
  byte = 0
  bit = 0

  old_stb = 0
  old_clk = 0

  opener = gzip.open if filename.endswith('.gz') else open
  with opener(filename, 'r') as f:
    for i, line in enumerate(f.readlines()):
      if i == 0:
        continue # skip header line

      cols = [ c.strip() for c in line.split(b',') ]
      # time = float(cols[0])
      stb, dat, clk, bus, rst = [ int(c) for c in cols[1:6] ]

      # strobe low->high starts session
      if (old_stb == 0) and (stb == 1):
        byte = 0
        bit = 7

      # clock low->high latches data from radio to lcd
      if (old_clk == 0) and (clk == 1):
        if dat == 1:
          byte += (2 ** bit)

        bit -= 1
        if bit < 0: # got all bits of byte
          session.append(byte)
          byte = 0
          bit = 7

      # strobe high->low ends session
      if (old_stb == 1) and (stb == 0):
        if session:
          lcd.eval(session)
        session = []
        byte = 0
        bit = 7

      old_stb = stb
      old_clk = clk


if __name__ == '__main__':
    if sys.argv[1] == '4':
      lcd = Premium4()
    else:
      lcd = Premium5()
    filename = sys.argv[2]
    parse_analyzer_file(filename, lcd)
