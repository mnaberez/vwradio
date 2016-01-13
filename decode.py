import sys

PREMIUM_4_CHARACTERS = {
  0x20: " ",
  0x37: "7",
  0x38: "8",
  0x45: "E",
  0x46: "F",
  0x53: "S",
  0xe0: "A",
  0xe4: "0",
  0xe5: "1",
  0xe6: "3",
  0xe7: "4",
  0xe8: "5",
  0xe9: "6",
  0xea: "9",
  0xf3: "2",
}

# Most Premium 5 characters are ASCII
PREMIUM_5_CHARACTERS = {
  0x00: "<fm 1>",
  0x01: "<fm 2>",
  0x02: "<preset 1>",
  0x03: "<preset 2>",
  0x04: "<preset 3>",
  0x05: "<preset 4>",
  0x06: "<preset 5>",
  0x07: "<preset 6>",
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
  0x59: "Y",
  0x6b: "k",
  0x7a: "z",
}

CHARACTERS = PREMIUM_5_CHARACTERS

class LcdState(object):
  '''Abstract'''
  def __init__(self, debug=True):
    self.debug = debug

    self.display_data_ram = [0] * 0x19
    self.pictograph_ram = [0] * 0x08
    self.chargen_ram = [0] * 0x10

    self.current_ram = None
    self.address = 0
    self.increment = False

  def eval(self, session):
    if self.debug:
      self.print_session(session)

    # Command Byte
    cmd = session[0]
    cmdsel = cmd & 0b11000000
    if cmdsel == 0b01000000: # Data Setting Command
      mode = cmd & 0b00000111
      if mode == 0: # Write to display data RAM
        self.current_ram = self.display_data_ram
      elif mode == 1: # Write to pictograph RAM
        self.current_ram = self.pictograph_ram
      elif mode == 2: # Write to character generator RAM
        self.current_ram = self.chargen_ram
      elif mode == 3: # Write to LED output latch
        self.current_ram = None
      elif mode == 4: # Read key data
        self.current_ram = None
      else: # Unknown mode
        self.current_ram = None

      incr = cmd & 0b00001000
      self.increment = incr == 0
    elif cmdsel == 0b10000000: # Address Setting Command
      self.address = cmd & 0b00011111

    # Data Bytes
    for byte in session[1:]:
      if self.current_ram is not None:
        self.current_ram[self.address] = byte
        if self.increment:
          self.address += 1

    if self.debug:
      self.print_state()

  @property
  def characters(self):
    raise NotImplementedError

  def decode_display_ram(self):
    raise NotImplementedError

  def decode_pictographs(self):
    raise NotImplementedError

  def _hexdump(self, list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])

  def print_state(self):
    print('Chargen RAM: ' + self._hexdump(self.chargen_ram))
    print('Pictograph RAM: ' + self._hexdump(self.pictograph_ram))
    print('Display Data RAM: ' + self._hexdump(self.display_data_ram))
    print('Decoded Pictographs: ' + self.decode_pictographs())
    print('Decoded Display Data: %r' % self.decode_display_ram())
    print('')

  def print_session(self, session):
    print("Session: " + self._hexdump(session))
    for i, byte in enumerate(session):
      if i == 0: # command byte
        self.print_command(byte)
      else: # data byte
        print("  Data byte = 0x%02x (%s)" % (byte, format(byte, '#010b')))
    print('')

  def print_command(self, cmd):
    print("  Command byte = 0x%02x (%s)" % (cmd, format(cmd, '#010b')))

    cmdsel = cmd & 0b11000000

    if cmdsel == 0b00000000:
      print("    Display Setting Command")

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

    elif cmdsel == 0b01000000:
      print("  Data Setting Command")

      mode = cmd & 0b00000111
      if mode == 0:
        print("    0=Write to display data RAM")
      elif mode == 1:
        print("    1=Write to pictograph RAM")
      elif mode == 2:
        print("    2=Write to chargen_ram")
      elif mode == 3:
        print("    3=Write to LED output latch")
      elif mode == 4:
        print("    4=Read key data")
      else:
        print("    ? Unknown mode ?")

      incr = cmd & 0b00001000
      if incr == 0:
        print("    Address increment mode: 0=increment")
      else:
        print("    Address increment mode: 1=fixed")

    elif cmdsel == 0b10000000:
      print("  Address Setting Command")
      address = cmd & 0b00011111
      print("    Address = %02x" % address)

    elif cmdsel == 0b11000000:
      print("  Status Command")

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
    else:
      raise Exception("unknown command")


class Premium4(LcdState):
  @property
  def characters(self):
    return PREMIUM_4_CHARACTERS

  def decode_display_ram(self):
    decoded = ''
    for byte in reversed(self.display_data_ram[2:13]):
      decoded += self.characters.get(byte, '?')
    return decoded

  def decode_pictographs(self):
    return '??? Not Implemented '

class Premium5(LcdState):
  @property
  def characters(self):
    return PREMIUM_5_CHARACTERS

  def decode_display_ram(self):
    decoded = ''
    for byte in self.display_data_ram[:11]:
      decoded += self.characters.get(byte, '?')
    return decoded

  def decode_pictographs(self):
    pictographs = []
    if self.pictograph_ram[1] & 0x04:
      pictographs.append("dolby")
    if self.pictograph_ram[2] & 0x80:
      pictographs.append("metal")
    if self.pictograph_ram[4] & 0x20:
      pictographs.append("period")
    # TODO handle MIX pictograph
    return '[%s]' % ', '.join(pictographs)


def parse_analyzer_file(filename, lcd):
  session = []
  byte = 0
  bit = 0

  old_stb = 0
  old_clk = 0

  with open(filename, 'r') as f:
    for i, line in enumerate(f.readlines()):
      if i == 0:
        continue # skip header line

      cols = [ c.strip() for c in line.split(',') ]
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
        lcd.eval(session)
        session = []
        byte = 0
        bit = 7

      old_stb = stb
      old_clk = clk


if __name__ == '__main__':
    if sys.argv[1] == '4':
      lcd = Premium4(debug=True)
    else:
      lcd = Premium5(debug=True)
    filename = sys.argv[2]
    parse_analyzer_file(filename, lcd)
