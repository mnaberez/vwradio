PREMIUM_4_CHARACTERS = {
  0x20 => " ",
  0x37 => "7",
  0x38 => "8",
  0x45 => "E",
  0x46 => "F",
  0x53 => "S",
  0xe0 => "A",
  0xe4 => "0",
  0xe5 => "1",
  0xe6 => "3",
  0xe7 => "4",
  0xe8 => "5",
  0xe9 => "6",
  0xea => "9",
  0xf3 => "2",
}

# Most Premium 5 characters are ASCII
PREMIUM_5_CHARACTERS = {
  0x00 => "1 (fm1 or fm2)",
  0x01 => "2 (fm1 or fm2)",
  0x02 => "1 (preset)",
  0x03 => "2 (preset)",
  0x04 => "3 (preset)",
  0x05 => "4 (preset)",
  0x06 => "5 (preset)",
  0x07 => "6 (preset)",
  0x20 => " ",
  0x2b => "+",
  0x2d => "-",
  0x30 => "0",
  0x31 => "1",
  0x32 => "2",
  0x33 => "3",
  0x34 => "4",
  0x35 => "5",
  0x36 => "6",
  0x37 => "7",
  0x38 => "8",
  0x39 => "9",
  0x41 => "A",
  0x42 => "B",
  0x43 => "C",
  0x44 => "D",
  0x45 => "E",
  0x46 => "F",
  0x47 => "G",
  0x48 => "H",
  0x49 => "I",
  0x4c => "L",
  0x4d => "M",
  0x4e => "N",
  0x4f => "O",
  0x50 => "P",
  0x52 => "R",
  0x53 => "S",
  0x54 => "T",
  0x59 => "Y",
  0x6b => "k",
  0x7a => "z",
}

CHARACTERS = PREMIUM_5_CHARACTERS

def explain_cmd(cmd)
  puts "command byte = 0x%02x (%08b)" % [cmd, cmd]

  cmdsel = cmd & 0b11000000

  if cmdsel == 0b00000000
    puts "  Display Setting Command"

    if (cmd & 1) == 0
      puts "    Duty setting: 1/8 duty"
    else
      puts "    Duty setting: 1/15 duty"
    end

    if (cmd & 2) == 0
      puts "    Master/slave setting: master"
    else
      puts "    Master/slave setting: slave"
    end

    if (cmd & 4) == 0
      puts "    Drive voltage supply method: external"
    else
      puts "    Drive voltage supply method: internal"
    end

  elsif cmdsel == 0b01000000
    puts "  Data Setting Command"

    mode = cmd & 0b00000111
    if mode == 0
      puts "    Write to display data RAM"
    elsif mode == 1
      puts "    Write to character display RAM"
    elsif mode == 2
      puts "    Wrie to CGRAM"
    elsif mode == 3
      puts "    Write to LED output latch"
    elsif mode == 4
      puts "    Read key data"
    else
      puts "    ? Unknown mode ?"
    end

    # TODO page 12 says increment should be bit 3 off
    # but page 15 says increment should be bit 3 on
    # bit 3 off makes more sense looking at the captures
    incflag = cmd & 0b00001000
    if incflag == 0
      puts "    Address increment mode: increment"
    else
      puts "    Address increment mode: fixed"
    end

  elsif cmdsel == 0b10000000
    puts "  Address Setting Command"
    address = cmd & 0b00011111
    puts "    Address = %02x" % address

  elsif cmdsel == 0b11000000
    puts "  Status Command"

    if (cmd & 32) == 0
      puts "    Test mode setting: 0=Normal operation"
    else
      puts "    Test mode setting: 1=Test Mode"
    end

    if (cmd & 16) == 0
      puts "    Standby mode setting: 0=Normal operation"
    else
      puts "    Standby mode setting: 1=Standby mode"
    end

    if (cmd & 8) == 0
      puts "    Key scan control: 0=Key scanning stopped"
    else
      puts "    Key scan control: 1=Key scan operation"
    end

    if (cmd & 4) == 0
      puts "    LED control: 0=LED forced off"
    else
      puts "    LED control: 1=Normal operation"
    end

    lcd_mode = cmd & 0b00000011
    if lcd_mode == 0
      puts "    LCD mode: LCD forced off (SEGn, COMn=Vlc5)"
    elsif lcd_mode == 1
      puts "    LCD mode: LCD forced off (SEGn, COMn=unselected waveform"
    elsif lcd_mode == 2
      puts "    LCD mode: Normal operation (0b00)"
    else # 3
      puts "    LCD mode: Normal operation (0b11)"
    end
  else
    raise "unknown command"
  end # if cmdsel
end

old_stb = 0
old_dat = 0
old_clk = 0
old_bus = 0
old_rst = 0

receiving_command = false
byte = 0
bit = 0

File.readlines(ARGV[0]).each_with_index do |line, i|
  next if i.zero? # header

  time, stb, dat, clk, bus, rst, *others = line.split(',').map(&:to_i)

  # strobe means start of command
  if (old_stb == 0) && (stb == 1)
    puts "\nstrobe low -> high (data input)"
    receiving_command = true
    byte = 0
    bit = 7
  end

  # clocked bit
  if (old_clk == 0) && (clk == 1)
    byte += (2 ** bit) if dat == 1

    bit -= 1
    if bit < 0 # got all bits of byte
      if receiving_command
        explain_cmd(byte)
        receiving_command = false
      else
        line = "  data byte = 0x%02x (%08b)" % [byte, byte]
        char = CHARACTERS[byte]
        line += "  \"#{char}\"" if char
        puts line
      end
      bit = 7
      byte = 0
    end
  end

  if (old_stb == 1) && (stb == 0)
    puts "strobe high -> low (execute command)"
  end

  old_stb = stb
  old_dat = dat
  old_clk = clk
  old_bus = bus
  old_rst = rst
end
