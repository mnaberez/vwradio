import gzip
import sys
import lcd_faceplates

class LcdAnalyzer(object):

  def __init__(self, faceplate):
    self.faceplate = faceplate

    self.display_data_ram = [0] * 0x19
    self.pictograph_ram = [0] * 0x08
    self.chargen_ram = [0] * 7 * 0x10
    self.led_output_ram = [0]
    self.key_data_ram = [0] * 4

    self.current_ram = None
    self.address = 0
    self.increment = False

  def process(self, spi_data):
    self.print_spi_data(spi_data)

    # Command Byte
    cmd = spi_data[0]
    cmdsel = cmd & 0b11000000

    # Process command byte
    if cmdsel == 0b00000000:
      self._cmd_display_setting(spi_data)
    elif cmdsel == 0b01000000:
      self._cmd_data_setting(spi_data)
    elif cmdsel == 0b10000000:
      self._cmd_address_setting(spi_data)
    elif cmdsel == 0b11000000:
      self._cmd_status(spi_data)
    else:
      self._cmd_unknown(spi_data)

    # Process data bytes
    for byte in spi_data[1:]:
      if self.current_ram is not None:
        if self.address >= len(self.current_ram):
          self.address = 0

        self.current_ram[self.address] = byte

        if self.increment:
          self.address += 1

    self.print_state()

  def _cmd_display_setting(self, spi_data):
    print("    Display Setting Command")
    cmd = spi_data[0]

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

  def _cmd_data_setting(self, spi_data):
    print("  Data Setting Command")
    cmd = spi_data[0]
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
      self.current_ram = self.key_data_ram
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
      # other commands always increment and also reset address
      print("    Command implies address increment; increment is now on")
      self.increment = True
      print("    Command implies reset to address 0; address is now 0")
      self.address = 0


  def _cmd_address_setting(self, spi_data):
      print("  Address Setting Command")
      cmd = spi_data[0]
      address = cmd & 0b00011111
      print("    Address = %02x" % address)
      if self.current_ram is self.chargen_ram:
        self.address = address * 7 # character number, 7 bytes per char
      else:
        self.address = address

  def _cmd_status(self, spi_data):
    print("  Status command")
    cmd = spi_data[0]
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

  def _cmd_unknown(self, spi_data):
    print("? Unknown command ?")

  def _read_char_data(self, char_code):
    charset = self.chargen_ram if char_code < 0x10 else self.faceplate.ROM_CHARSET
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
    for address in self.faceplate.DISPLAY_ADDRESSES:
      char_code = self.display_data_ram[address]
      data.extend(self._read_char_data(char_code))
    return self._draw_chars(data, self.faceplate.DISPLAY_ADDRESSES)

  def draw_chargen_ram(self):
    return self._draw_chars(self.chargen_ram, range(0x10))

  def decode_display_ram(self):
    decoded = ''
    for address in self.faceplate.DISPLAY_ADDRESSES:
      byte = self.display_data_ram[address]
      if byte in range(16):
        decoded += "<cgram:0x%02x>" % byte
      else:
        decoded += self.faceplate.CHARACTERS.get(byte, '?')
    return decoded

  def decode_pictographs(self):
    names = []
    for offset in range(8):
      for bit in range(8):
        if self.pictograph_ram[offset] & (2**bit):
          pictograph = self.faceplate.PICTOGRAPHS.get(offset, {}).get(bit, None)
          if pictograph is None:
            name = "<unknown at byte %d, bit %d>" % (offset, bit)
          else:
            name = lcd_faceplates.Pictographs.get_name(pictograph)
          names.append(name)
    return '[%s]' % ', '.join(names)

  def decode_keys(self):
    keys = []
    key_data = self.key_data_ram
    for bytenum, byte in enumerate(key_data):
        key_map = self.faceplate.KEYS.get(bytenum, {})
        for bitnum in range(8):
            if byte & (2**bitnum):
                key = key_map.get(bitnum)
                if key is None:
                    msg = 'Unrecognized key at byte %d, bit %d'
                    raise ValueError(msg % (bytenum, bitnum))
                keys.append(key)
    names = [ lcd_faceplates.Keys.get_name(k) for k in keys ]
    return '[%s]' % ', '.join(names)

  def _hexdump(self, list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])

  def print_state(self):
    print('Key Data RAM: ' + self._hexdump(self.key_data_ram))
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
    print('Decoded Keys Pressed: ' + self.decode_keys())
    print('')

  def print_spi_data(self, spi_data):
    print("SPI Data: " + self._hexdump(spi_data))
    for i, byte in enumerate(spi_data):
      desc = "Command byte" if i == 0 else "Data byte"
      print("  %s = 0x%02x (%s)" % (desc, byte, format(byte, '#010b')))
    print('')


def parse_analyzer_file(filename, analyzer):
  spi_data = []
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
        spi_data = []
        byte = 0
        bit = 7

      # clock low->high latches data from radio to lcd
      if (old_clk == 0) and (clk == 1):
        if dat == 1:
          byte += (2 ** bit)

        bit -= 1
        if bit < 0: # got all bits of byte
          spi_data.append(byte)
          byte = 0
          bit = 7

      # strobe high->low ends session
      if (old_stb == 1) and (stb == 0):
        if spi_data:
          analyzer.process(spi_data)
        spi_data = []
        byte = 0
        bit = 7

      old_stb = stb
      old_clk = clk


def main():
  if sys.argv[1] == '4':
    faceplate = lcd_faceplates.Premium4
  else:
    faceplate = lcd_faceplates.Premium5
  analyzer = LcdAnalyzer(faceplate)
  filename = sys.argv[2]
  parse_analyzer_file(filename, analyzer)


if __name__ == '__main__':
  main()
