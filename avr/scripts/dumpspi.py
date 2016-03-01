#!/usr/bin/env python
import sys
from vwradio.avrclient import make_client
from vwradio.faceplates import Premium4

client = make_client()
ser = client.serial

# while True:
#     numbytes = ser.in_waiting
#     if numbytes:
#         sys.stdout.write(ser.read(numbytes))

fp = Premium4()
while True:
    display_ram = client.emulated_upd_dump_state().display_ram
    lcd_text = ''

    for addr in fp.DISPLAY_ADDRESSES:
        code_code = display_ram[addr]
        char = fp.CHARACTERS[code_code]
        lcd_text += char
    sys.stdout.write("\r" + lcd_text)
    sys.stdout.flush()
