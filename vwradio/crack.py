"""
This program uses a LabJack U3 controlling 5 relays to brute force crack
a VW Premium 4 or 5 radio.

The radio allows two code entry attempts per hour.  After each failed attempt,
it writes the attempt count to the AT93C64 EEPROM.  After two failed attempts,
the radio displays "SAFE" and is locked out for an hour.  The radio must
remain powered on for an hour to unlock, which gives two more attempts.  If the
radio is powered off and then on again, it will read the attempt count from the
EEPROM and stay locked out for an hour.  The radio seems to track attempts only
for rate limiting; it does not seem to care about the total number of attempts.

Codes are guessed sequentially from 0000-1999.  No radio has been seen
with a code higher than 1999.  There is no feedback from the radio, so
it must be observed to know when it has been cracked.

LabJack U3 connections:
    FIO0-3 Station preset buttons 1-4 for code entry
    FIO4   Execute security code button ("Tuning >")

Lines are inverted (0=close contact, 1=open contact).

Usage: crack.py <starting code>
"""

import datetime
import sys
import time
import u3 # LabJack


class Radio(object):
    """Radio front panel interaction"""
    def __init__(self, labjack=None):
        if labjack is None:
            labjack = u3.U3()
            labjack.configU3()
        self.labjack = labjack
        self.clear()

    def __repr__(self):
        return '<Radio: %s>' % ''.join([str(d) for d in self.digits])

    def clear(self):
        """Initialize the LabJack DIO and set the default button states"""
        for i in range(0, 5):
            self.labjack.setDOState(u3.FIO0 + i, 1)
        time.sleep(0.2)

        # security code always defaults to "1000"
        self.digits = [1, 0, 0, 0]

    def enter_code(self, code):
        """Toggle in a new security code without executing it.  Code
        is an integer from 0-9999."""
        code = str(code).rjust(4, "0")
        digits = [ int(c) for c in code ]

        for button, digit in enumerate(digits):
            while self.digits[button] != digit:
                self.press_preset_button(button)

    def execute(self):
        """Execute the current security code to try and unlock the radio"""
        self.labjack.setDOState(u3.FIO4, 0) # button down
        time.sleep(3) # execute requires a long press

        self.labjack.setDOState(u3.FIO4, 1) # button up
        time.sleep(5) # long delay until radio finishes flashing "SAFE"

    def press_preset_button(self, button):
        """Press a preset button and update the button's current digit.
        Button is an integer starting at 0 for preset 1."""
        for state in (0, 1): # 0=button down, 1=button up
            self.labjack.setDOState(u3.FIO0 + button, state)
            time.sleep(0.2)

        self.digits[button] += 1
        if self.digits[button] > 9:
            self.digits[button] = 0


class Cracker(object):
    """Crack a radio by brute force guessing codes"""
    def __init__(self, radio):
        self.radio = radio

    def crack(self, starting_code):
        code = starting_code
        max_code = 1999
        tries_this_cycle = 0

        while code <= max_code:
            percent = (float(code) / max_code) * 100
            print("Trying code %04d (max=%04d, %0.2f%% done)" % (
                code, max_code, percent))

            self.radio.enter_code(code)
            self.radio.execute()
            self.radio.clear()

            code += 1

            # the radio allows only 2 tries, then it locks out code entry
            # for an hour.
            tries_this_cycle += 1
            if tries_this_cycle == 2:
                print("Waiting 1 hour since %s" % datetime.datetime.now())
                time.sleep(3600)
                tries_this_cycle = 0


def main():
    if len(sys.argv) != 2:
        sys.stderr.write(__doc__)
        sys.exit(1)
    starting_code=int(sys.argv[1])

    labjack = u3.U3()
    radio = Radio(labjack)
    Cracker(radio).crack(starting_code)


if __name__ == '__main__':
    main()
