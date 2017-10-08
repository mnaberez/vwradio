import re
import time
import u3 # LabJackPython

class TapeController(object):
    ENABLE = u3.FIO0
    DAT_MOSI = u3.FIO1
    DAT_MISO = u3.FIO2 # unused
    CLK = u3.FIO3

    def __init__(self, labjack):
        self._labjack = labjack

    def send(self, data):
        for byte in data:
            self._labjack.setDOState(self.ENABLE, 0)
            time.sleep(0.001)
            labjack.spi(
                SPIBytes=[byte],
                AutoCS=False,
                DisableDirConfig=False,
                SPIMode='C', # C seems reliable, D doesn't
                SPIClockFactor=255, # 0-255, 255=slowest
                CSPinNum=self.ENABLE,
                MOSIPinNum=self.DAT_MOSI,
                MISOPinNum=self.DAT_MISO,
                CLKPinNum=self.CLK,
                )
            self._labjack.getDIState(self.ENABLE)
            self._labjack.getDIState(self.CLK)
            self._labjack.getDIState(self.DAT_MOSI)


cmds = {
    'Initial 12V Power Up':       [0xF8, 0x9A, 0xD8, 0xA8, 0xF0, 0x00, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ],
    'Tape inserted':              [0xF4, 0xAC, 0xA8, 0xAA, 0x9A, 0xD8, 0xC2, 0xDF, 0x52, 0xDF, 0x56],
    'Tape inserted during SAFE':  [0xF4, 0xAC, 0xA8, 0xAA, 0x9A, 0xD8, 0xC2, 0xF0, 0x00],
    'Tape Side during PLAY A':    [0xAE, 0xE7, 0x62, 0xEF, 0x66],
    'Tape Side during PLAY B':    [0x9E, 0xD7, 0x52, 0xDF, 0x56],
    'Stop during PLAY A':         [0x52, 0xAA, 0xF0, 0x00],
    'Stop during PLAY B':         [0x62, 0x9A, 0xF2, 0xF0, 0x00],
    'Eject during stopped on A':  [0xCC, 0xA8, 0xF0, 0x00],
    'Eject during stopped on B':  [0xCC, 0xA8, 0xF0, 0x00],
    'Play after stop on side A':  [0xD4, 0xAA, 0x9A, 0xDB, 0xC2, 0xDF, 0x52, 0xDF, 0x56],
    'Play after stop on side B':  [0xD4, 0xAA, 0x9A, 0xDB, 0xC2, 0xAE, 0xE7, 0x62, 0xEF, 0x66],
    'MSS FF during PLAY A':       [0xC0, 0xD2],
    'MSS FF during PLAY B':       [0xC0, 0xE2],
    'MSS REW during PLAY A':      [0xC0, 0xEA, 0xE2],
    'MSS REW during PLAY B':      [0xC0, 0xDA, 0xD2],
}


# while it is stopped
#   0 = stop motors
#   0x9a = ejects tape and keeps motoring until stopped
#   0xaa = sucks in tape and keeps motoring until stopped
#   0x62 = engage head
#   0x52 = disengage head

# 9e change to side a
# ae change to side b


if __name__ == '__main__':
    labjack = u3.U3()
    tape = TapeController(labjack)

    while True:
        line = re.sub('[^\d\sa-fA-F]', '', raw_input())
        data = [ int(s, 16) for s in line.split() ]
        if data:
            print("Sending %r" % [ '0x%02X' % d for d in data ])
            tape.send(data)
        else:
            break

