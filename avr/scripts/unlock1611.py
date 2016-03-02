#!/usr/bin/env python -u
import time
from vwradio import avrclient
from vwradio.faceplates import Premium4, Keys
from vwradio.radios import Radio, OperationModes

client = avrclient.make_client() # avr
face = Premium4() # display ram and character info
radio = Radio() # infers radio state from display

def read_display():
    display_ram = client.emulated_upd_dump_state().display_ram
    lcd_text = ''
    for addr in face.DISPLAY_ADDRESSES:
        code_code = display_ram[addr]
        char = face.CHARACTERS.get(code_code, '?')
        lcd_text += char
    return lcd_text

def hit_key(key, secs=0.25):
    key_name = face.get_key_name(key)
    print('Hitting key %s' % key_name)
    # hit the key
    key_data = face.encode_keys([key])
    client.emulated_upd_load_key_data(key_data)
    time.sleep(secs)
    # release all keys
    key_data = face.encode_keys([])
    client.emulated_upd_load_key_data(key_data)
    time.sleep(secs)

if __name__ == '__main__':
    client.pass_faceplate_keys_to_emulated_upd(False);
    code_to_enter = 1611
    code_entry_keys = (Keys.PRESET_1, Keys.PRESET_2,
                       Keys.PRESET_3, Keys.PRESET_4)
    safe_modes = (OperationModes.SAFE_ENTRY,
                  OperationModes.SAFE_LOCKED)

    lcd_text = read_display()
    radio.process(lcd_text)
    while radio.operation_mode == OperationModes.UNKNOWN:
        print("Unknown state: Waiting for radio to write to LCD")
        lcd_text = read_display()
        radio.process(lcd_text)
        time.sleep(1)

    while radio.operation_mode in safe_modes:
        if radio.operation_mode == OperationModes.SAFE_LOCKED:
            print("Safe mode locked: Waiting for code entry prompt")
            lcd_text = read_display()
            radio.process(lcd_text)
            time.sleep(1)
        else: # OperationModes.SAFE_ENTRY
            print("Safe mode entry: Toggling in code %d" % code_to_enter)
            for i in range(4):
                while str(radio.safe_code)[i] != str(code_to_enter)[i]:
                    hit_key(code_entry_keys[i])
                    lcd_text = read_display()
                    radio.process(lcd_text)
                    print(lcd_text)
            hit_key(Keys.TUNE_UP, secs=3)
            lcd_text = read_display()
            radio.process(lcd_text)
            print(lcd_text)

    print("Radio is unlocked")
    hit_key(Keys.SCAN)
    client.pass_faceplate_keys_to_emulated_upd(True);
