#!/usr/bin/env python3 -u
import time
from vwradio import avrclient
from vwradio.constants import Keys, OperationModes

client = avrclient.make_client()

if __name__ == '__main__':
    client.set_auto_key_passthru(False)
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
                    client.hit_key(code_entry_keys[i])
                    state = client.radio_state_dump()
                    print(state.safe_code)
            client.hit_key(Keys.TUNE_UP, secs=3)
            state = client.radio_state_dump()

    print("Radio is unlocked")
    client.hit_key(Keys.SCAN)
    client.set_auto_key_passthru(True)
