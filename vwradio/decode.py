import csv
import gzip
import sys
from vwradio import faceplates

class Upd16432b(object):
    '''Emulates the NEC uPD16432B.  Processes SPI command packets
    and updates internal RAM areas as the uPD16432B would.'''

    def __init__(self):
        self.display_ram = [0] * 0x19
        self.pictograph_ram = [0] * 0x08
        self.chargen_ram = [0] * 7 * 0x10
        self.led_output_ram = [0]
        self.key_data_ram = [0] * 4

        self.current_ram = None
        self.address = 0
        self.increment = False

    def process(self, spi_command):
        '''Process an SPI command packet, which is an arbitrary number of
        bytes received while the uPD16432B was selected with STB.  The
        first byte is the command, any successive bytes are data.'''
        self._print_spi_command(spi_command)

        # Command byte
        cmd = spi_command[0]

        # Process command byte
        cmdsel = cmd & 0b11000000
        if cmdsel == 0b00000000:
            self._process_display_setting(spi_command)
        elif cmdsel == 0b01000000:
            self._process_data_setting(spi_command)
        elif cmdsel == 0b10000000:
            self._process_address_setting(spi_command)
        elif cmdsel == 0b11000000:
            self._process_status(spi_command)

        # Process data bytes
        if self.current_ram is not None:
            for byte in spi_command[1:]:
                if self.address >= len(self.current_ram):
                    self.address = 0

                self.current_ram[self.address] = byte

                if self.increment:
                    self.address += 1

    def _process_display_setting(self, spi_command):
        self._out("    Display Setting Command")
        cmd = spi_command[0]

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

    def _process_data_setting(self, spi_command):
        self._out("  Data Setting Command")
        cmd = spi_command[0]
        mode = cmd & 0b00000111
        if mode == 0:
            self._out("    0=Write to display RAM")
            self.current_ram = self.display_ram
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
            # display ram or pictograph support increment flag
            incr = cmd & 0b00001000
            self.increment = incr == 0
            if self.increment:
                self._out("    Address increment mode: 0=increment")
            else:
                self._out("    Address increment mode: 1=fixed")
        else:
            # other commands always increment and also reset address
            self._out("    Command implies address increment; increment = on")
            self.increment = True
            self._out("    Command implies reset to address 0; address = 0")
            self.address = 0

    def _process_address_setting(self, spi_command):
        self._out("  Address Setting Command")
        cmd = spi_command[0]
        address = cmd & 0b00011111
        self._out("    Address = %02x" % address)
        if self.current_ram is self.chargen_ram:
            self.address = address * 7 # character number, 7 bytes per char
        else:
            self.address = address

    def _process_status(self, spi_command):
        self._out("  Status command")
        cmd = spi_command[0]
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
            self._out("    LCD mode: 1=LCD forced off (SEGn, "
                      "COMn=unselected waveform")
        elif lcd_mode == 2:
            self._out("    LCD mode: 2=Normal operation (0b00)")
        else: # 3
            self._out("    LCD mode: 3=Normal operation (0b11)")

    def _print_spi_command(self, spi_command):
        self._out("SPI Data: " + _hexdump(spi_command))
        for i, byte in enumerate(spi_command):
            desc = "Command byte" if i == 0 else "Data byte"
            line = "  %s = 0x%02x (%s)" % (desc, byte, format(byte, '#010b'))
            self._out(line)

    def _out(self, text):
        print(text)


class Visualizer(object):
    '''Visualizes the current display of the radio.  Reads the state of the
    uPD16432B emulator, then uses knowledge of the faceplate to draw what the
    faceplate would display.'''

    def __init__(self, upd, faceplate):
        '''+upd+ is a Upd16432b instance, which is a generic emulator that
        interprets commands and tracks state but does not have any details of
        a particular faceplate implementation such has how the LCD matrix or
        keys are wired.  +faceplate+ is a Faceplate instance, which provides
        those details.'''
        self.upd = upd
        self.faceplate = faceplate

    def print_state(self):
        # dump ram as hex
        self._out('Key Data RAM: ' + _hexdump(self.upd.key_data_ram))
        self._out('Chargen RAM: ' + _hexdump(self.upd.chargen_ram))
        self._out('Pictograph RAM: ' + _hexdump(self.upd.pictograph_ram))
        self._out('Display RAM: ' + _hexdump(self.upd.display_ram))
        self._out('LED Output Latch: 0x%02x' % self.upd.led_output_ram[0])

        # draw characters as bitmaps
        self._out('Drawn Chargen RAM:')
        for line in self.draw_chargen_ram():
            self._out('  ' + line)
        self._out('Drawn Display RAM:')
        for line in self.draw_display_ram():
            self._out('  ' + line)

        # decode raw bytes into equivalent ascii, pictograph names, etc.
        self._out('Decoded Display RAM: %r' % self.decode_display_ram())
        self._out('Decoded Pictographs: %r' % self.decode_pictograph_names())
        self._out('Decoded Keys Pressed: %r' % self.decode_key_names())

    def draw_display_ram(self):
        data = []
        for address in self.faceplate.DISPLAY_ADDRESSES:
            char_code = self.upd.display_ram[address]
            data.extend(self._read_char_data(char_code))
        return self._draw_chars(data, self.faceplate.DISPLAY_ADDRESSES)

    def draw_chargen_ram(self):
        return self._draw_chars(self.upd.chargen_ram, range(0x10))

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

    def _read_char_data(self, char_code):
        if char_code < 0x10:
            charset = self.upd.chargen_ram
        else:
            charset = self.faceplate.ROM_CHARSET
        offset = char_code * 7
        return charset[offset:offset+7]

    def decode_display_ram(self):
        decoded = ''
        for address in self.faceplate.DISPLAY_ADDRESSES:
            byte = self.upd.display_ram[address]
            if byte in range(16):
                decoded += "<cgram:0x%02x>" % byte
            else:
                decoded += self.faceplate.CHARACTERS.get(byte, '?')
        return decoded

    def decode_pictograph_names(self):
        pictographs = self.faceplate.decode_pictographs(self.upd.pictograph_ram)
        return [ self.faceplate.get_pictograph_name(p) for p in pictographs ]

    def decode_key_names(self):
        keys = self.faceplate.decode_keys(self.upd.key_data_ram)
        return [ self.faceplate.get_key_name(k) for k in keys ]

    def _out(self, text):
        print(text)


def _hexdump(list_of_bytes):
    return '[%s]' % ', '.join([ '0x%02x' % x for x in list_of_bytes ])


def parse_analyzer_file(filename, emulator, visualizer):
    spi_command = []
    byte = 0
    bit = 0

    old_stb = 0
    old_clk = 0

    opener = gzip.open if filename.endswith('.gz') else open
    with opener(filename, 'r') as f:
        headings = [ col.strip() for col in f.next().split(',') ]
        reader = csv.DictReader(f, headings)

        for row in reader:
            stb = int(row['STB'])
            dat = int(row['DAT'])
            clk = int(row['CLK'])

            # strobe low->high starts session
            if (old_stb == 0) and (stb == 1):
                spi_command = []
                byte = 0
                bit = 7

            # clock low->high latches data from radio to lcd
            if (old_clk == 0) and (clk == 1):
                if dat == 1:
                    byte += (2 ** bit)

                bit -= 1
                if bit < 0: # got all bits of byte
                    spi_command.append(byte)
                    byte = 0
                    bit = 7

            # strobe high->low ends session
            if (old_stb == 1) and (stb == 0):
                if spi_command:
                    emulator.process(spi_command)
                    print('')
                    visualizer.print_state()
                    print('')
                spi_command = []
                byte = 0
                bit = 7

            old_stb = stb
            old_clk = clk


def main():
    if len(sys.argv) != 3:
        sys.stderr.write("Usage: %s <4|5> <filename>\n" % sys.argv[0])
        sys.exit(1)

    if sys.argv[1] == '4':
        faceplate = faceplates.Premium4()
    else:
        faceplate = faceplates.Premium5()

    filename = sys.argv[2]

    emulator = Upd16432b()
    visualizer = Visualizer(emulator, faceplate)
    parse_analyzer_file(filename, emulator, visualizer)


if __name__ == '__main__':
    main()
