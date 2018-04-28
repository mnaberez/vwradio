#!/usr/bin/env python3 -u
import time
import sys
from vwradio import avrclient
from vwradio.constants import Keys

client = avrclient.make_client()

if __name__ == '__main__':
    # build list of keycodes to try (one bit per key, max 32 bits)
    keycodes = []
    keycode = 1
    while len(keycodes) < 32:
        keycodes.append(keycode)
        keycode = keycode << 1

    client.set_auto_key_passthru(False)
    for keycode in keycodes:
        # put the display into a known state
        client.hit_key(Keys.MODE_AM)
        client.hit_key(Keys.MODE_FM)
        client.hit_key(Keys.PRESET_1)

        # split the 32-bit keycode to 4 key data bytes
        key_data = []
        for i in range(3, -1, -1):
            key_data.append((keycode >> (8*i) & 0xFF))

        # try the key
        if key_data == [0,0,0,0x40]:
            print('skipped initial')
        elif key_data == [0,0,0x02,0]:
            print('skipped scan')
        elif key_data == [0,0,0x20,0]:
            print('skipped code')
        elif key_data == [0,0x10,0,0]:
            print('skipped bal')
        elif key_data == [0,0,0,0x80]:
            print('skipped no code')
        else:
            sys.stdout.write("\n%r%s" % (key_data, ' ' * 25,))
            sys.stdout.flush()
            client.emulated_upd_load_key_data(key_data)
            time.sleep(20)
            reading_1 = client.read_lcd()
            client.emulated_upd_load_key_data([0, 0, 0, 0])
            time.sleep(0.25)
            reading_2 = client.read_lcd()

            if (reading_1 != 'FM11 891MHZ') or (reading_2 != 'FM11 891MHZ'):
                sys.stdout.write("\r%r down:%r up:%r\n" %
                    (key_data, reading_1, reading_2))
                sys.stdout.flush()
    client.set_auto_key_passthru(True)
