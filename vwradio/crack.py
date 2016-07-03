"""
This program uses a Raspberry Pi controlling 5 relays to brute force crack
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

Usage: crack.py <starting code>
"""

import datetime
import sys
import time
import RPi.GPIO as GPIO


class Pins(object):
    """Raspberry Pi GPIO header pin assignments"""
    PRESET_1 = 29
    PRESET_2 = 31
    PRESET_3 = 33
    PRESET_4 = 35
    EXECUTE = 37

class States(object):
    """Logic states to output on GPIO to open/close relay contacts"""
    OPEN_CONTACT = GPIO.HIGH
    CLOSE_CONTACT = GPIO.LOW


class Radio(object):
    """Radio front panel interaction"""
    def __init__(self):
        self.setup()

    def __repr__(self):
        return '<Radio: %s>' % ''.join([str(d) for d in self.digits])

    def setup(self):
        """Initialize GPIO and set the default button states"""
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BOARD)
        for name, pin in Pins.__dict__.items():
            if not name.startswith('_'):
                GPIO.setup(pin, GPIO.OUT, initial=States.OPEN_CONTACT)
        GPIO.setwarnings(True)
        time.sleep(0.2)
        self.clear()

    def clear(self):
        """Security code always defaults to 1000"""
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
        GPIO.output(Pins.EXECUTE, States.CLOSE_CONTACT)
        time.sleep(3) # execute requires a long press

        GPIO.output(Pins.EXECUTE, States.OPEN_CONTACT)
        time.sleep(5) # long delay until radio finishes flashing "SAFE"

    def press_preset_button(self, button):
        """Press a preset button and update the button's current digit.
        Button is an integer starting at 0 for preset 1."""
        for state in (States.CLOSE_CONTACT, States.OPEN_CONTACT):
            pin = getattr(Pins, 'PRESET_%d' % (button + 1))
            GPIO.output(pin, state)
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

        print("Cracking starts in 30 seconds.  Power radio on now.")
        time.sleep(30)

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
                next_at = datetime.datetime.now() + datetime.timedelta(hours=1)
                print("Waiting 1 hour.  Next attempt at %s" % next_at)
                time.sleep(3600)
                tries_this_cycle = 0


def main():
    if len(sys.argv) != 2:
        sys.stderr.write(__doc__)
        sys.exit(1)
    starting_code=int(sys.argv[1])

    radio = Radio()
    Cracker(radio).crack(starting_code)


if __name__ == '__main__':
    main()
