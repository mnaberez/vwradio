#!/usr/bin/env python3 -u
import sys
from vwradio import avrclient
from vwradio.constants import Keys, OperationModes, TunerBands

if __name__ == '__main__':
    client = avrclient.make_client()
    client.set_auto_key_passthru(False)

    desired_freq = int(float(sys.argv[1]) * 10)
    if (desired_freq & 1) != 1:
        sys.stderr.write("Frequency must be odd\n")
        sys.exit(1)
    if (desired_freq < 879) or (desired_freq > 1079):
        sys.stderr.write("Frequency not in range of 87.9 - 107.9\n")
        sys.exit(1)

    # put radio into fm1
    state = client.radio_state_dump()
    while state.operation_mode != OperationModes.TUNER_PLAYING:
        client.hit_key(Keys.MODE_FM)
        state = client.radio_state_dump()
    while state.tuner_band != TunerBands.FM1:
        client.hit_key(Keys.MODE_FM)
        state = client.radio_state_dump()

    # hold tune up or tune down until close to desired frequency
    if state.tuner_freq > desired_freq:
        key = Keys.TUNE_DOWN
    else:
        key = Keys.TUNE_UP
    client.load_keys([key])
    while abs(state.tuner_freq - desired_freq) > 4:
        state = client.radio_state_dump()
    client.load_keys([])

    # single-press tune up or tune down until desired frequency reached
    while (state.tuner_freq != desired_freq):
        client.hit_key(key)
        state = client.radio_state_dump()
        if state.tuner_freq > desired_freq:
            key = Keys.TUNE_DOWN
        else:
            key = Keys.TUNE_UP

    sys.stdout.write("%s\n" % client.read_lcd())
    client.set_auto_key_passthru(True)
