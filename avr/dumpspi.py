#!/usr/bin/env python
import sys
from serialtest import make_client
from vwradio.faceplates import Premium4

client = make_client()
serial = client.serial

# while True:
# numbytes = ser.in_waiting
#     if numbytes:
#         sys.stdout.write(ser.read(numbytes))

fp = Premium4()
while True:
    try:
        display_data_ram = client.dump_upd_state()['display_data_ram']
        lcd_text = ''

        for addr in fp.DISPLAY_ADDRESSES:
            code_code = display_data_ram[addr]
            char = fp.CHARACTERS[code_code]
            lcd_text += char
        sys.stdout.write("\r" + lcd_text)
        sys.stdout.flush()
    except KeyError:
        # occasionally fp.CHARACTERS[code_code] raises because of an unknown
        # char code.  this happens because the avr sometimes misses the data
        # setting command to set display data ram, so the emulator writes
        # pictograph data to the display data ram.
        pass
