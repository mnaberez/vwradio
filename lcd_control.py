import time

import u3 # LabJackPython

def spi_write(device, data):
    device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=1))
    result = device.spi(
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
    device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0))
    device.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0))
    return data

def lcd_print(dev, text):
    spi_write(dev, [0x04]) # Display Setting Command
    spi_write(dev, [0xcf]) # Status Command
    spi_write(dev, [0x40]) # Data Setting Command
    text = reversed(text[:11].ljust(11, ' '))
    packet = [0x82] + list([ char_code(c) for c in text ])
    spi_write(dev, packet)

def dump_charset(dev, delay_secs=0.1):
    spi_write(dev, [0x04]) # Display Setting Command
    spi_write(dev, [0xcf]) # Status Command
    spi_write(dev, [0x41]) # Data Setting Command: write to pictograph ram
    spi_write(dev, [0x80] + ([0]*8)) # Address Setting command, pictograph data
    spi_write(dev, [0x40]) # Data Setting Command: write to display ram
    for i in range(0, 0x100, 7):
        data = [ char_code(c) for c in '0x%02X' % i ] # "0xAB" char code in hex
        data.extend([ i+j for j in range(7) ])        # 7 characters
        data = list(reversed(data))

        spi_write(dev, [0x82] + data) # Address Setting command, display data
        time.sleep(0.5)
    lcd_print(dev, '')

CHARACTERS = {
    0x7f: "_",
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
    0x40: "@",
    0x41: "A",
    0x42: "B",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x4a: "J",
    0x4b: "K",
    0x4d: "M",
    0x4c: "L",
    0x4f: "O",
    0x49: "I",
    0x50: "P",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x55: "U",
    0x56: "V",
    0x57: "W",
    0x58: "X",
    0x59: "Y",
    0x5a: "Z",
    0x78: "x",
    0xe0: "A",
    0xe1: "B",
    0xe2: "N",
    0xe4: "0",
    0xe5: "1",
    0xe6: "3",
    0xe7: "4",
    0xe8: "5",
    0xe9: "6",
    0xea: "9",
    0xeb: "FM1", # for FM1
    0xec: "FM2", # for FM2
    0xed: "PRESET2", # for preset 2
    0xee: "PRESET3", # for preset 3
    0xef: "PRESET4", # for preset 4
    0xf0: "PRESET5", # for preset 5
    0xf2: "PRESET6", # for preset 6
    0xf3: "PRESET2",
}

def char_code(char):
    for key, value in CHARACTERS.items():
        if value == char:
            return key
    return 0x2b


if __name__ == '__main__':
    dev = u3.U3()
    try:
        dump_charset(dev)
    finally:
        dev.getFeedback(u3.BitStateWrite(IONumber=u3.FIO0, State=0)) # STB
        dev.getFeedback(u3.BitStateWrite(IONumber=u3.FIO1, State=0)) # DAT
        dev.reset()
        dev.close()
