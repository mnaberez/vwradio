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
        self.device.getFeedback(u3.BitStateRead(IONumber=Pins.EJE))
        self.device.getFeedback(u3.BitStateRead(IONumber=Pins.POW))
        self.device.getFeedback(u3.BitStateWrite(IONumber=Pins.STB, State=0))
        self.device.getFeedback(u3.BitStateWrite(IONumber=Pins.LOF, State=1))
        for state in (1, 0, 1):
            self.device.getFeedback(u3.BitStateWrite(IONumber=Pins.RST, State=state))
        self.clear()

    def clear(self):
        self.spi([0x04]) # Display Setting command
        self.spi([0xcf]) # Status command
        self.spi([0x41]) # Data Setting command: write to pictograph ram
        self.spi([0x80] + ([0]*8)) # Address Setting command, pictograph data
        self.spi([0x40]) # Data Setting command: write to display ram
        self.spi([0x80] + ([0x20]*16)) # Address Setting command, display data

    def read_key_data(self):
        return self.spi([0x44, 0, 0, 0, 0])[1:]

    def read_keys(self):
        keys = []

        data = self.read_key_data()
        if data[0] & 1:   keys.append('treb')
        if data[0] & 2:   keys.append('preset1')
        if data[0] & 4:   keys.append('preset2')
        if data[0] & 8:   keys.append('preset3')
        if data[0] & 16:  keys.append('bass')
        if data[0] & 32:  keys.append('preset4')
        if data[0] & 64:  keys.append('preset5')
        if data[0] & 128: keys.append('preset6')
        if data[1] & 1:   keys.append('fade')
        if data[1] & 2:   keys.append('tune <')
        if data[1] & 4:   keys.append('tape')
        if data[1] & 8:   keys.append('cd')
        if data[1] & 16:  keys.append('bal')
        if data[1] & 32:  keys.append('tune >')
        if data[1] & 64:  keys.append('am')
        if data[1] & 128: keys.append('fm')
        if data[2] & 1:   keys.append('seek <')
        if data[2] & 2:   keys.append('scan')
        if data[2] & 8:   keys.append('mix')
        if data[2] & 16:  keys.append('seek >')
        if data[2] & 32:  keys.append('tapside')

        data = self.device.getFeedback(u3.BitStateRead(IONumber=Pins.EJE))
        if data[0] != 1:
            keys.append('eject')

        data = self.device.getFeedback(u3.BitStateRead(IONumber=Pins.POW))
        if data[0] != 1:
            keys.append('power')

        return keys

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
            if keys:
                self.lcd.write(("KEY:" + keys[0]).upper().ljust(11))
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

