'''
Send messages to the Sub-MCU over the Main-to-Sub SPI bus
'''

import u3
import sys
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

# 0x00 = "    VW-CAR", static
# 0x01 = "CD x TR xx", params
# 0x02 = "CUE xxxx", params
# 0x03 = "REV xxxx", params
# 0x04 = "SCANCDxTRxx", params
# 0x05 = " NO  CHANGER", static
# 0x06 = " NO  MAGAZIN", static
# 0x07 = "    NO DISC", static
# 0x08 = "CD x ERROR", params
# 0x09 = "CD x xxxx", params
# 0x0a = "CD x MAX", params
# 0x0b = "CD x MIN", params
# 0x0c = "CHK MAGAZIN", static
# 0x0d = " CDx CD ERR", params
# 0x0e = " CD  ERROR", static
# 0x0f = "CD x NO CD", params
# 0x10 = " SET ONVOL Y", static
# 0x11 = " SET ONVOL N", static
# 0x12 = " SET ONVOLxx", params
# 0x13 = " SET CD MIX1", static
# 0x14 = " SET CD MIX6", static
# 0x15 = "TAPE SKIP Y", static
# 0x16 = "TAPE SKIP N", static
# 0x17 = "RAD 3CP T7", static
# 0x18 = "VER", static
# 0x19 = blank, static
# 0x1a = "HC", static
# 0x1b = "V", static
# 0x1c = "SEEK SET M", static
# 0x1d = "SEEK SET N", static
# 0x1e = "SEEK SET M1", static
# 0x1f = "SEEK SET M2", static
# 0x20 = "RAD 3CP T7", static
# 0x21 = "VER 0x.02" params
# 0x22 = frequency strength, params
# 0x23 = "HC", params
# 0x24 = "V", params
# 0x25 = "SEEK SET Mx", params
# 0x26 = "SEEK SET Nx", params
# 0x27 = "SEEK SET M1x", params
# 0x28 = "SEEK SET M2x", params
# 0x29 = "SEEK SET M3x", params
# 0x2a = "SEEK SET N1x", params
# 0x2b = "SEEK SET N2x", params
# 0x2c = "SEEK SET N3x", params
# 0x2d = "SEEK SET Xxx", params
# 0x2e = "SEEK SET Yxx", params
# 0x2f = "SEEK SET Zxx", params
# 0x30 = "FERN ON", static
# 0x31 = "FERN OFF", static
# 0x32 = "TEST TUN ON", static
# 0x33 = "TEST xxQx-xx", params
# 0x34 = "TEST BASS xx", params
# 0x35 = "TEST TREB xx", params
# 0x36 = "TEST TUN OFF", static
# 0x37 = "  ON TUNING", static
# 0x38 = "TEST BASS", static
# 0x38 = "TEST TREB", static
# 0x3a = "  FM    MHZ", static
# 0x3b = "  AM    KHZ", static
# 0x3c = "SCAN    MHZ", static
# 0x3d = "SCAN    KHZ", static
# 0x3e = "  FM    MAX", static
# 0x3f = "  FM    MIN", static
