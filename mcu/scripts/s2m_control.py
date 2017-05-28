'''
Send messages to the Main-MCU over the Sub-to-Main SPI bus

This script doesn't work reliably because the bus seems very
timing sensitive.  Bit-banging is used because the LabJack
slowest SPI clock rate is still too fast for the Main-MCU.
'''

import u3

class Pins(object):
    DAT_MOSI = u3.FIO1
    DAT_MISO = u3.FIO2 # unused
    CLK = u3.FIO3
    ENA = u3.FIO5

class MainMCU(object):
    def __init__(self, device=None):
        if device is None:
            device = u3.U3()
        self.device = device

    def send(self, data):
        self.device.setDOState(Pins.CLK, 1)
        self.device.setDOState(Pins.ENA, 0)
        for d in data:
            for bitpos in range(7, -1, -1):
                if d & (2**bitpos):
                    bit = 1
                else:
                    bit = 0
                self.device.setDOState(Pins.DAT_MOSI, bit)
                self.device.setDOState(Pins.CLK, 0)
                self.device.setDOState(Pins.CLK, 1)
        self.device.setDOState(Pins.ENA, 1)

if __name__ == '__main__':
    main = MainMCU()
    for i in range(1000):
        packet = [0b11001101, 0b11001000, 0b00000000, 0b00101010]
        print([hex(x) for x in packet])
        main.send(packet)

    for i in range(3):
        packet = [0x90,0x48,0x00,0x2a] # no key pressed
        print([hex(x) for x in packet])
        main.send(packet)
