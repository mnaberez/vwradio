#!/usr/bin/env python -u
import time
from vwradio import avrclient
from vwradio.constants import Keys, OperationModes

client = avrclient.make_client()

def hit_key(key, secs=0.25):
    key_name = Keys.get_name(key)
    print('Hitting key %s' % key_name)
    client.load_keys([key]) # hit key
    time.sleep(secs)
    client.load_keys([]) # release all keys
    time.sleep(secs)

if __name__ == '__main__':
    client.set_auto_keypress_passthru(False)
    code_to_enter = 1611
    code_entry_keys = (Keys.PRESET_1, Keys.PRESET_2,
                       Keys.PRESET_3, Keys.PRESET_4)
    safe_modes = (OperationModes.SAFE_ENTRY,
                  OperationModes.SAFE_LOCKED)

    state = client.radio_state_dump()
    while state.operation_mode == OperationModes.UNKNOWN:
        print("Unknown state: Waiting for radio to write to LCD")
        state = client.radio_state_dump()
        time.sleep(1)

    while state.operation_mode in safe_modes:
        if state.operation_mode == OperationModes.SAFE_LOCKED:
            print("Safe mode locked: Waiting for code entry prompt")
            state = client.radio_state_dump()
            time.sleep(1)
        else: # OperationModes.SAFE_ENTRY
            print("Safe mode entry: Toggling in code %d" % code_to_enter)
            for i in range(4):
                while str(state.safe_code)[i] != str(code_to_enter)[i]:
                    hit_key(code_entry_keys[i])
                    state = client.radio_state_dump()
                    print(state.safe_code)
            hit_key(Keys.TUNE_UP, secs=3)
            state = client.radio_state_dump()

    print("Radio is unlocked")
    hit_key(Keys.SCAN)
    client.set_auto_keypress_passthru(True)
