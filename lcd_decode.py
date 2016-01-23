import gzip
import sys

class LcdState(object):
  '''Abstract'''

  MATRIX_ORDER = []
  CHARACTERS = {}
  PICTOGRAPHS = {}

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

  def _cmd_unknown(session):
    print("? Unknown command ?")

  def decode_chargen_ram(self):
    lines = []
    line = ''
    for charnum in range(16):
      line += '0x%02x:  ' % charnum
    lines.append(line)

    for row in range(7):
      line = ''
      for charnum in range(16):
        byte = self.chargen_ram[(charnum * 7) + row]
        line += (format(byte, '#010b')[5:].
                  replace('0', '.').replace('1', 'O') + '  ')
      lines.append(line)
    return lines

  def decode_display_ram(self):
    decoded = ''
    for address in self.MATRIX_ORDER:
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
          name = self.PICTOGRAPHS.get(offset, {}).get(bit, None)
          if name is None:
            name = "<unknown at byte %d, bit %d>" % (offset, bit)
          names.append(name)
    return '[%s]' % ', '.join(names)

  def _hexdump(self, list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])

  def print_state(self):
    print('Chargen RAM: ' + self._hexdump(self.chargen_ram))
    print('Pictograph RAM: ' + self._hexdump(self.pictograph_ram))
    print('Display Data RAM: ' + self._hexdump(self.display_data_ram))
    print('LED Output Latch: 0x%02x' % self.led_output_ram[0])
    print('Decoded Chargen RAM:')
    for line in self.decode_chargen_ram():
      print('  ' + line)
    print('Decoded Pictographs: ' + self.decode_pictographs())
    print('Decoded Display Data: %r' % self.decode_display_ram())
    print('')

  def print_session(self, session):
    print("Session: " + self._hexdump(session))
    for i, byte in enumerate(session):
      desc = "Command byte" if i == 0 else "Data byte"
      print("  %s = 0x%02x (%s)" % (desc, byte, format(byte, '#010b')))
    print('')


class Premium4(LcdState):
  MATRIX_ORDER = list(range(12, 1, -1))

  CHARACTERS = {
    0x20: " ",
    0x2b: "+",
    0x2d: "-",
    0x37: "7",
    0x38: "8",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x4b: "K",
    0x4d: "M",
    0x4c: "L",
    0x4f: "O",
    0x49: "I",
    0x50: "P",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x55: "U",
    0x57: "W",
    0x58: "X",
    0x59: "Y",
    0x5a: "Z",
    0xe0: "A",
    0xe1: "B",
    0xe2: "N",
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
    0xf2: "6", # for preset 6
    0xf3: "2",
    }

  PICTOGRAPHS = {
    7: {3: 'metal'},
    6: {5: 'dolby', 0: 'mix'},
    3: {6: 'period'},
    2: {3: 'mode:am/fm'},
    1: {0: 'mode:cd', 5: 'mode:tape'},
    }


class Premium5(LcdState):
  MATRIX_ORDER = list(range(11))

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
    4: {5: 'period'},
    2: {7: 'metal'},
    1: {2: 'dolby'},
    # TODO MIX
    }


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
