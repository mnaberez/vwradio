
def explain_cmd(cmd)
  puts "command byte = 0x%02x (%08b)" % [cmd, cmd]

  cmdsel = cmd & 0b11000000

  if cmdsel == 0b00000000
    puts "  Display Setting Command"

  elsif cmdsel == 0b01000000
    puts "  Data Setting Command"

    mode = cmd & 0b00000111
    if mode == 0b000
      puts "    Write to display data RAM"
    elsif mode == 0b001
      puts "    Write to character display RAM"
    elsif mode == 0b010
      puts "    Wrie to CGRAM"
    elsif mode == 0b011
      puts "    Write to LED output latch"
    elsif mode == 0b100
      puts "    Read key data"
    else
      puts "    ? Unknown mode ?"
    end

    # TODO page 12 says increment should be bit 3 off
    # but page 15 says increment should be bit 3 on
    # bit 3 on makes more sense looking at the captures
    increment = cmd & 0b00001000
    if increment == 0b00001000
      puts "    Address increment mode: fixed"
    else
      puts "    Address increment mode: increment"
    end

  elsif cmdsel == 0b10000000
    puts "  Address Setting Command"
    address = cmd & 0b00011111
    puts "    Address = %02x" % address

  elsif cmdsel == 0b11000000
    puts "  Status Command"

    if (cmd & 0b00100000) == 0b00100000
      puts "    Test mode setting: 1=Test Mode"
    else
      puts "    Test mode setting: 0=Normal operation"
    end

    if (cmd & 0b00010000) == 0b00010000
      puts "    Standby mode setting: 1=Standby mode"
    else
      puts "    Standby mode setting: 0=Normal operation"
    end

    if (cmd & 0b00001000) == 0b00001000
      puts "    Key scan control: 1=Key scan operation"
    else
      puts "    Key scan control: 0=Key scanning stopped"
    end

    if (cmd & 0b00000100) == 0b00000100
      puts "    LED control: 1=Normal operation"
    else
      puts "    LED control: 0=LED forced off"
    end

    lcd_mode = cmd & 0b00000011
    if lcd_mode == 0b00
      puts "    LCD mode: LCD forced off (SEGn, COMn=Vlc5)"
    elsif lcd_mode == 0b01
      puts "    LCD mode: LCD forced off (SEGn, COMn=unselected waveform"
    elsif lcd_mode == 0b10
      puts "    LCD mode: Normal operation (0b00)"
    else
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
        puts "  data byte = 0x%02x (%08b)" % [byte, byte]
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


# Time[s], STB, DAT, CLK, BUS, RST,