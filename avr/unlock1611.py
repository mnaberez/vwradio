#!/usr/bin/env python -u
import time
from serialtest import make_client
from vwradio.faceplates import Premium4, Keys

client = make_client()
face = Premium4()

def read_display():
    display_data_ram = client.dump_upd_state()['display_data_ram']
    lcd_text = ''
    for addr in face.DISPLAY_ADDRESSES:
        code_code = display_data_ram[addr]
        char = face.CHARACTERS.get(code_code, '?')
        lcd_text += char
    return lcd_text

def hit_key(key, secs=0.25):
    key_name = face.get_key_name(key)
    print('Hitting key %s' % key_name)
    # hit the key
    key_data = face.encode_keys([key])
    client.load_upd_tx_key_data(key_data)
    time.sleep(secs)
    # release all keys
    key_data = face.encode_keys([])
    client.load_upd_tx_key_data(key_data)
    time.sleep(secs)

if __name__ == '__main__':
    try:
        while '1000' not in read_display():
            print("Waiting for 1000 on display")
            time.sleep(0.25)
        # toggle in code 1611 (assumes current code is 1000)
        hit_key(Keys.PRESET_2) # 0->1
        hit_key(Keys.PRESET_2) # 1->2
        hit_key(Keys.PRESET_2) # 2->3
        hit_key(Keys.PRESET_2) # 3->4
        hit_key(Keys.PRESET_2) # 4->5
        hit_key(Keys.PRESET_2) # 5->6
        hit_key(Keys.PRESET_3) # 0->1
        hit_key(Keys.PRESET_4) # 0->1
        hit_key(Keys.TUNE_UP, secs=3)
        print(read_display())
        hit_key(Keys.SCAN)
        print(read_display())
    except KeyboardInterrupt:
        client.load_upd_tx_key_data([0,0,0,0])
