import gzip
import sys
from vwradio import faceplates

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

        self.debug = False

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
        if self.current_ram is not None:
            for byte in spi_data[1:]:
                if self.address >= len(self.current_ram):
                    self.address = 0

                self.current_ram[self.address] = byte

                if self.increment:
                    self.address += 1

        self.print_state()

    def _cmd_display_setting(self, spi_data):
        self._out("    Display Setting Command")
        cmd = spi_data[0]

        if (cmd & 1) == 0:
            self._out("    Duty setting: 0=1/8 duty")
        else:
            self._out("    Duty setting: 1=1/15 duty")

        if (cmd & 2) == 0:
            self._out("    Master/slave setting: 0=master")
        else:
            self._out("    Master/slave setting: 1=slave")

        if (cmd & 4) == 0:
            self._out("    Drive voltage supply method: 0=external")
        else:
            self._out("    Drive voltage supply method: 1=internal")

    def _cmd_data_setting(self, spi_data):
        self._out("  Data Setting Command")
        cmd = spi_data[0]
        mode = cmd & 0b00000111
        if mode == 0:
            self._out("    0=Write to display data RAM")
            self.current_ram = self.display_data_ram
        elif mode == 1:
            self._out("    1=Write to pictograph RAM")
            self.current_ram = self.pictograph_ram
        elif mode == 2:
            self._out("    2=Write to chargen ram")
            self.current_ram = self.chargen_ram
        elif mode == 3:
            self._out("    3=Write to LED output latch")
            self.current_ram = self.led_output_ram
        elif mode == 4:
            self._out("    4=Read key data")
            self.current_ram = self.key_data_ram
        else: # Unknown mode
            self._out("    ? Unknown mode ?")
            self.current_ram = None

        if mode in (0, 1):
            # display data ram or pictograph support increment flag
            incr = cmd & 0b00001000
            self.increment = incr == 0
            if self.increment:
                self._out("    Address increment mode: 0=increment")
            else:
                self._out("    Address increment mode: 1=fixed")
        else:
            # other commands always increment and also reset address
            self._out("    Command implies address increment; increment is now on")
            self.increment = True
            self._out("    Command implies reset to address 0; address is now 0")
            self.address = 0

    def _cmd_address_setting(self, spi_data):
        self._out("  Address Setting Command")
        cmd = spi_data[0]
        address = cmd & 0b00011111
        self._out("    Address = %02x" % address)
        if self.current_ram is self.chargen_ram:
            self.address = address * 7 # character number, 7 bytes per char
        else:
            self.address = address

    def _cmd_status(self, spi_data):
        self._out("  Status command")
        cmd = spi_data[0]
        if (cmd & 32) == 0:
            self._out("    Test mode setting: 0=Normal operation")
        else:
            self._out("    Test mode setting: 1=Test Mode")

        if (cmd & 16) == 0:
            self._out("    Standby mode setting: 0=Normal operation")
        else:
            self._out("    Standby mode setting: 1=Standby mode")

        if (cmd & 8) == 0:
            self._out("    Key scan control: 0=Key scanning stopped")
        else:
            self._out("    Key scan control: 1=Key scan operation")

        if (cmd & 4) == 0:
            self._out("    LED control: 0=LED forced off")
        else:
            self._out("    LED control: 1=Normal operation")

        lcd_mode = cmd & 0b00000011
        if lcd_mode == 0:
            self._out("    LCD mode: 0=LCD forced off (SEGn, COMn=Vlc5)")
        elif lcd_mode == 1:
            self._out("    LCD mode: 1=LCD forced off (SEGn, COMn=unselected waveform")
        elif lcd_mode == 2:
            self._out("    LCD mode: 2=Normal operation (0b00)")
        else: # 3
            self._out("    LCD mode: 3=Normal operation (0b11)")

    def _cmd_unknown(self, spi_data):
        self._out("? Unknown command ?")

    def _read_char_data(self, char_code):
        if char_code < 0x10:
            charset = self.chargen_ram
        else:
            charset = self.faceplate.ROM_CHARSET
        offset = char_code * 7
        return charset[offset:offset+7]

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

    def decode_pictograph_names(self):
        pictographs = self.faceplate.decode_pictographs(self.pictograph_ram)
        return [ self.faceplate.get_pictograph_name(p) for p in pictographs ]

    def decode_key_names(self):
        keys = self.faceplate.decode_keys(self.key_data_ram)
        return [ self.faceplate.get_key_name(k) for k in keys ]

    def _hexdump(self, list_of_bytes):
        return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])

    def print_state(self):
        self._out('Key Data RAM: ' + self._hexdump(self.key_data_ram))
        self._out('Chargen RAM: ' + self._hexdump(self.chargen_ram))
        self._out('Pictograph RAM: ' + self._hexdump(self.pictograph_ram))
        self._out('Display Data RAM: ' + self._hexdump(self.display_data_ram))
        self._out('LED Output Latch: 0x%02x' % self.led_output_ram[0])
        self._out('Drawn Chargen RAM:')
        for line in self.draw_chargen_ram():
            self._out('  ' + line)
        self._out('Drawn Display Data RAM:')
        for line in self.draw_display_ram():
            self._out('  ' + line)
        self._out('Decoded Display Data RAM: %r' % self.decode_display_ram())
        self._out('Decoded Pictographs: %r' % self.decode_pictograph_names())
        self._out('Decoded Keys Pressed: %r' % self.decode_key_names())
        self._out('')

    def print_spi_data(self, spi_data):
        self._out("SPI Data: " + self._hexdump(spi_data))
        for i, byte in enumerate(spi_data):
            desc = "Command byte" if i == 0 else "Data byte"
            self._out("  %s = 0x%02x (%s)" % (desc, byte, format(byte, '#010b')))
        self._out('')

    def _out(self, text):
        if self.debug:
            print(text)


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
        faceplate = faceplates.Premium4()
    else:
        faceplate = faceplates.Premium5()
    analyzer = LcdAnalyzer(faceplate)
    analyzer.debug = True
    filename = sys.argv[2]
    parse_analyzer_file(filename, analyzer)


if __name__ == '__main__':
    main()
