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
  0x00: "1 (fm1 or fm2)",
  0x01: "2 (fm1 or fm2)",
  0x02: "1 (preset)",
  0x03: "2 (preset)",
  0x04: "3 (preset)",
  0x05: "4 (preset)",
  0x06: "5 (preset)",
  0x07: "6 (preset)",
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

def explain_cmd(cmd):
  print("command byte = 0x%02x (%s)" % (cmd, bin(cmd)))

  cmdsel = cmd & 0b11000000

  if cmdsel == 0b00000000:
    print("  Display Setting Command")

    if (cmd & 1) == 0:
      print("    Duty setting: 1/8 duty")
    else:
      print("    Duty setting: 1/15 duty")

    if (cmd & 2) == 0:
      print("    Master/slave setting: master")
    else:
      print("    Master/slave setting: slave")

    if (cmd & 4) == 0:
      print("    Drive voltage supply method: external")
    else:
      print("    Drive voltage supply method: internal")

  elif cmdsel == 0b01000000:
    print("  Data Setting Command")

    mode = cmd & 0b00000111
    if mode == 0:
      print("    Write to display data RAM")
    elif mode == 1:
      print("    Write to character display RAM")
    elif mode == 2:
      print("    Wrie to CGRAM")
    elif mode == 3:
      print("    Write to LED output latch")
    elif mode == 4:
      print("    Read key data")
    else:
      print("    ? Unknown mode ?")

    # TODO page 12 says increment should be bit 3 off
    # but page 15 says increment should be bit 3 on
    # bit 3 off makes more sense looking at the captures
    incflag = cmd & 0b00001000
    if incflag == 0:
      print("    Address increment mode: increment")
    else:
      print("    Address increment mode: fixed")

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
      print("    LCD mode: LCD forced off (SEGn, COMn=Vlc5)")
    elif lcd_mode == 1:
      print("    LCD mode: LCD forced off (SEGn, COMn=unselected waveform")
    elif lcd_mode == 2:
      print("    LCD mode: Normal operation (0b00)")
    else: # 3
      print("    LCD mode: Normal operation (0b11)")
  else:
    raise Exception("unknown command")

old_stb = 0
old_dat = 0
old_clk = 0
old_bus = 0
old_rst = 0

receiving_command = False
byte = 0
bit = 0

with open(sys.argv[1], 'r') as f:
  for i, line in enumerate(f.readlines()):
    if i == 0:
      continue # skip header line

    cols = [ c.strip() for c in line.split(',') ]
    time = float(cols[0])
    stb, dat, clk, bus, rst = [ int(c) for c in cols[1:6] ]

    # strobe means start of command
    if (old_stb == 0) and (stb == 1):
      print("\nstrobe low -> high (data input)")
      receiving_command = True
      byte = 0
      bit = 7

    # clocked bit
    if (old_clk == 0) and (clk == 1):
      if dat == 1:
        byte += (2 ** bit)

      bit -= 1
      if bit < 0: # got all bits of byte
        if receiving_command:
          explain_cmd(byte)
          receiving_command = False
        else:
          line = "  data byte = 0x%02x (%s)" % (byte, bin(byte))
          char = CHARACTERS.get(byte)
          if char is not None:
            line += '  "%s"' % char
          print(line)
        bit = 7
        byte = 0

    if (old_stb == 1) and (stb == 0):
      print("strobe high -> low (execute command)")

    old_stb = stb
    old_dat = dat
    old_clk = clk
    old_bus = bus
    old_rst = rst
