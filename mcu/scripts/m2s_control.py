'''
Send messages to the Sub-MCU over the Main-to-Sub SPI bus
'''

import u3
import time

class Pins(object):
    DAT_MOSI = u3.FIO1
    DAT_MISO = u3.FIO2 # unused
    CLK = u3.FIO3
    ENA = u3.FIO5

class SubMCU(object):
    def __init__(self, device=None):
        if device is None:
            device = u3.U3()
        self.device = device

    def send(self, data):
        self.device.setDOState(Pins.ENA, 0)
        time.sleep(0.001)
        for d in data:
            self.device.spi(
                SPIBytes=[d],
                AutoCS=False,
                DisableDirConfig=False,
                SPIMode='C', # CPOL=1, CPHA=0
                SPIClockFactor=255, # 0-255, 255=slowest
                CSPINNum=Pins.ENA,
                MOSIPinNum=Pins.DAT_MOSI,
                MISOPinNum=Pins.DAT_MISO,
                CLKPinNum=Pins.CLK,
                )
            time.sleep(0.0001)
        self.device.setDOState(Pins.ENA, 1)

if __name__ == '__main__':
    sub = SubMCU()
    for i in range(256):
        packet = [0x81, 0, i, 0, 0, 0]
        print([hex(x) for x in packet])
        sub.send(packet)
        time.sleep(0.3)
