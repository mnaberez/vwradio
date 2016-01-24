import time

import u3 # LabJackPython
import lcd_decode

class Lcd(object):
    def __init__(self, device):
        self.device = device

    def spi(self, data):
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=1))
        result = self.device.spi(
            SPIBytes=data,
            AutoCS=False,
            DisableDirConfig=False,
            SPIMode='D', # CPOL=1, CPHA=1
            SPIClockFactor=255, # 0-255, 255=slowest
            CSPinNum=u3.FIO0,
            MOSIPinNum=u3.FIO1,
            CLKPinNum=u3.FIO2,
            MISOPinNum=u3.FIO3,
            )
        data = result['SPIBytes']
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0))
        self.device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0))
        return data

    def write(self, text):
        self.spi([0x04]) # Display Setting Command
        self.spi([0xcf]) # Status Command
        self.spi([0x40]) # Data Setting Command
        text = reversed(text[:11].ljust(11, ' '))
        packet = [0x82] + list([ self.char_code(c) for c in text ])
        self.spi(packet)

    def dump_charset(self, delay_secs=0.1):
        self.spi([0x04]) # Display Setting Command
        self.spi([0xcf]) # Status Command
        self.spi([0x41]) # Data Setting Command: write to pictograph ram
        self.spi([0x80] + ([0]*8)) # Address Setting command, pictograph data
        self.spi([0x40]) # Data Setting Command: write to display ram
        for i in range(0, 0x100, 7):
            data = [ self.char_code(c) for c in '0x%02X' % i ]
            for j in range(7): # 7 characters
                code = i + j
                if code > 0xFF: # past end of charset
                    code = 0x20 # blank space
                data.append(code)
            data = list(reversed(data))

            self.spi([0x82] + data) # Address Setting command, display data
            time.sleep(1)
        self.write('')

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
        lcd.dump_charset()

    finally:
        device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0)) # STB
        device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0)) # DAT
        device.reset()
        device.close()
