import time

import u3 # LabJackPython
import lcd_charsets
import lcd_decode

class Lcd(object):
    def __init__(self, device):
        self.device = device

    def spi(self, data):
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=1))
        data = self.device.spi(
            SPIBytes=data,
            AutoCS=False,
            DisableDirConfig=False,
            SPIMode='D', # CPOL=1, CPHA=1
            SPIClockFactor=255, # 0-255, 255=slowest
            CSPinNum=u3.FIO0,
            MOSIPinNum=u3.FIO1,
            CLKPinNum=u3.FIO2,
            MISOPinNum=u3.FIO3,
            )['SPIBytes']
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0))
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0))
        return data

    def clear(self):
        self.spi([0x04]) # Display Setting command
        self.spi([0xcf]) # Status command
        self.spi([0x41]) # Data Setting command: write to pictograph ram
        self.spi([0x80] + ([0]*8)) # Address Setting command, pictograph data
        self.spi([0x40]) # Data Setting command: write to display ram
        self.spi([0x80] + ([0]*16)) # Address Setting command, display data

    def write(self, text):
        if len(text) > 11:
            raise ValueError("Text %r is longer than max of 11", text)
        self.spi([0x40]) # Data Setting command: write to display ram
        text = reversed(text.ljust(11, ' '))
        packet = [0x82] + list([ self.char_code(c) for c in text ])
        self.spi(packet)

    def define_char(self, index, data):
        if index not in range(16):
            raise ValueError("Character number %r is not 0-15", index)
        if len(data) != 7:
            raise ValueError("Character data length %r is not 7" % len(data))
        self.spi([0x4a]) # Data Setting command: write to chargen ram
        packet = [0x80 + index] + list(data) # Address Setting command, data
        self.spi(packet)

    def display_charset(self):
        self.spi([0x40]) # Data Setting command: write to display ram
        for i in range(0, 0x100, 7):
            data = [ ord(c) for c in '0x%02X' % i ] # 4 chars: code in hex
            for j in range(7): # 7 characters
                code = i + j
                if code > 0xFF: # past end of charset
                    code = 0x20 # blank space
                data.append(code)
            data = list(reversed(data))

            self.spi([0x82] + data) # Address Setting command, display data
            time.sleep(1)
        self.clear()

    def display_rom_charset_comparison(self):
        def read_char_data(charset, index):
            start = i * 7
            end = start + 7
            return charset[start:end]

        for i in range(0x10, 0x100):
            # refine character 0 with the rom pattern
            data = read_char_data(lcd_charsets.PREMIUM_4, i)
            lcd.define_char(0, data)

            # first four chars: display character code in hex
            lcd.spi([0x40])
            data = list(reversed([ ord(c) for c in '0x%02X' % i ]))
            lcd.spi([0x89] + data)

            # all other chars: alternate between rom and programmable char 0
            for blink in range(6):
                for code in (0, i):
                    lcd.spi([0x82] + ([code]*7))
                    time.sleep(0.2)
        self.clear()

    CHARACTERS = lcd_decode.Premium4.CHARACTERS
    def char_code(self, char):
        code = None
        for key, value in self.CHARACTERS.items():
            if value == char:
                code = key
        if code is None:
            code = 0x7f # block cursor
        return code


if __name__ == '__main__':
    device = u3.U3()
    try:
        lcd = Lcd(device)
        lcd.clear()
        lcd.display_rom_charset_comparison()

    finally:
        device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0)) # STB
        device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0)) # DAT
        device.reset()
        device.close()
