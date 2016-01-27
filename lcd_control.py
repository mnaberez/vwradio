import string
import time

import u3 # LabJackPython
import lcd_charsets
import lcd_decode

class Pins(object):
    STB = u3.FIO0
    DAT_OUT = u3.FIO1
    DAT_IN = u3.FIO2
    CLK = u3.FIO3
    RST = u3.FIO4
    LOF = u3.FIO5
    EJE = u3.FIO6
    POW = u3.FIO7

class Lcd(object):
    def __init__(self, device):
        self.device = device

    def spi(self, data):
        data = self.device.spi(
            SPIBytes=data,
            AutoCS=True,
            InvertCS=True,
            DisableDirConfig=False,
            SPIMode='D', # CPOL=1, CPHA=1
            SPIClockFactor=255, # 0-255, 255=slowest
            CSPinNum=Pins.STB,
            MOSIPinNum=Pins.DAT_OUT,
            MISOPinNum=Pins.DAT_IN,
            CLKPinNum=Pins.CLK,
            )['SPIBytes']
        return data

    def reset(self):
        # configure pins as inputs
        self.device.getDIState(Pins.EJE)
        self.device.getDIState(Pins.POW)

        # configure pins as ouputs and set initial state
        self.device.setDOState(Pins.STB, 0)
        self.device.setDOState(Pins.LOF, 1)
        for state in (1, 0, 1):
            self.device.setDOState(Pins.RST, state)
        self.clear()

    def clear(self):
        self.spi([0x04]) # Display Setting command
        self.spi([0xcf]) # Status command
        self.spi([0x41]) # Data Setting command: write to pictograph ram
        self.spi([0x80] + ([0]*8)) # Address Setting command, pictograph data
        self.spi([0x40]) # Data Setting command: write to display ram
        self.spi([0x80] + ([0x20]*16)) # Address Setting command, display data

    def read_keys(self):
        keys = []

        keydata = self.read_key_data()
        for bytenum, byte in enumerate(keydata):
            current_map = lcd_decode.Premium4.KEYS.get(bytenum, {})
            for bitnum in range(8):
                if byte & (2**bitnum):
                    key = current_map.get(bitnum)
                    if key is None:
                        raise ValueError('Unrecognized key')
                    keys.append(key)

        if self.device.getDIState(Pins.EJE) == 0:
            keys.append(lcd_decode.Keys.STOP_EJECT)
        if self.device.getDIState(Pins.POW) == 0:
            keys.append(lcd_decode.Keys.POWER)

        return keys

    def read_key_data(self):
        return self.spi([0x44, 0, 0, 0, 0])[1:]

    def write(self, text, pos=0):
        self.write_codes([ self.char_code(c) for c in text ], pos)

    def write_codes(self, char_codes, pos=0):
        if len(char_codes) > (11 - pos):
            raise ValueError("Data %r exceeds visible range from pos %d" %
                (char_codes, pos))
        self.spi([0x40]) # Data Setting command: write to display ram
        address = 0x0d - len(char_codes) - pos
        self.spi([0x80 + address] + list(reversed(char_codes)))

    def define_char(self, index, data):
        if index not in range(16):
            raise ValueError("Character number %r is not 0-15", index)
        if len(data) != 7:
            raise ValueError("Character data length %r is not 7" % len(data))
        self.spi([0x4a]) # Data Setting command: write to chargen ram
        packet = [0x80 + index] + list(data) # Address Setting command, data
        self.spi(packet)

    CHARACTERS = lcd_decode.Premium4.CHARACTERS
    def char_code(self, char):
        if char in string.digits:
            return ord(char)
        for key, value in self.CHARACTERS.items():
            if value == char:
                return key
        return 0x7f # not found, show block cursor char


class Demonstrator(object):
    def __init__(self, lcd):
        self.lcd = lcd

    def show_charset(self):
        for i in range(0, 0x100, 7):
            self.lcd.write('0x%02X' % i, pos=0)
            data = [0x20] * 7 # 7 chars, default blank spaces
            for j in range(len(data)):
                code = i + j
                if code > 0xFF: # past end of charset
                    break
                data[j] = code
            self.lcd.write_codes(data, pos=4)
            time.sleep(1)
        self.lcd.clear()

    def show_rom_charset_comparison(self):
        def read_char_data(charset, index):
            start = i * 7
            end = start + 7
            return charset[start:end]

        for i in range(0x10, 0x100):
            # refine character 0 with the rom pattern
            data = read_char_data(lcd_charsets.PREMIUM_4, i)
            self.lcd.define_char(0, data)

            # first four chars: display character code in hex
            self.lcd.write('0x%02X' % i, pos=0)

            # all other chars: alternate between rom and programmable char 0
            for blink in range(6):
                for code in (0, i):
                    self.lcd.write_codes([code]*7, pos=4)
                    time.sleep(0.2)
        self.lcd.clear()

    def show_keys(self):
        self.lcd.clear()
        self.lcd.write('Hit Key', pos=4)
        while True:
            keys = self.lcd.read_keys()
            names = [ lcd_decode.Keys.get_name(k) for k in keys ]
            if names:
                print("%r" % names)
                msg = names[0][:11].ljust(11)
                self.lcd.write(msg)
        time.sleep(0.1)

    def clock(self):
        self.lcd.clear()
        self.lcd.write("Time", pos=0)
        while True:
            clock = time.strftime("%I:%M%p").lower()
            if clock[0] == '0':
                clock = ' ' + clock[1:]
            self.lcd.write(clock, pos=4)
            time.sleep(0.5)


def main():
    device = u3.U3()
    try:
        lcd = Lcd(device)
        lcd.reset()
        demo = Demonstrator(lcd)
        demo.show_keys()
    finally:
        device.reset()
        device.close()


if __name__ == '__main__':
    main()

