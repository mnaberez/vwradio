import sys
import time
import u3 # LabJack

class Radio(object):
    """Radio front panel interaction

       Station preset buttons 1-4 connect to LabJack FIO0-3
       Execute security code button ("Tuning >") connects to LabJack FIO4
       Lines are inverted (0=close contact, 1=open contact)
    """

    def __init__(self):
        self._d = u3.U3()
        self._d.configU3()
        self.clear()

    def __repr__(self):
        return '<Radio: %s>' % ''.join([str(d) for d in self.digits])

    def clear(self):
        """Initialize the LabJack DIO and set the default button states"""
        for i in range(0, 5):
            self._d.setFIOState(i, 1)
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
                self._press_preset_button(button)

    def execute(self):
        """Execute the current security code to try and unlock the radio"""
        self._d.setFIOState(4, 0) # button down
        time.sleep(5) # execute requires a long press

        self._d.setFIOState(4, 1) # button up
        time.sleep(30) # long delay until radio finishes flashing "SAFE"

    def _press_preset_button(self, button):
        """Press a preset button and update the button's current digit.
        Button is an integer starting at 0 for preset 1."""
        for state in (0, 1): # 0=button down, 1=button up
            self._d.setFIOState(button, state)
            time.sleep(0.2)

        self.digits[button] += 1
        if self.digits[button] > 9:
            self.digits[button] = 0


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write("Usage: crack.py <starting code>\n")
        sys.exit(1)

    code = int(sys.argv[1])
    max_code = 1999
    tries_this_hour = 0
    radio = Radio()

    while code <= max_code:
        print("Trying code %d (max=%d)" % (code, max_code))

        radio.enter_code(code)
        radio.execute()
        radio.clear() # radio clears to 1000 after unsuccessful try

        code += 1

        # radio allows only two tries, then it must be left
        # idle for at least an hour before the next try
        tries_this_hour += 1
        if tries_this_hour == 2:
            print("Waiting since %s" % time.strftime('%I:%M %p'))
            time.sleep(3600 + 60)
            tries_this_hour = 0
