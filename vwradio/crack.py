"""
This program uses a LabJack U3 controlling 10 relays to brute force crack
a VW Premium 4 radio made by Clarion.

The radio normally allows only two attempts per hour.  After each failed
attempt, it writes the attempt count to the AT93C64 EEPROM.  If power is
removed and then restored, the radio will read the attempt count from the
EEPROM and stay locked out for an hour.

Here, the EEPROM's chip select (CS) line is disconnected with a relay
so the radio can't update the attempt count, which allows the one hour
wait to be bypassed.  The radio will not start up without the EEPROM,
so the EPROM's CS is connected to the radio's microcontroller to allow
the radio to start, then disconnected before code entry.

Once two failed attempts are made, the radio locks out and starts waiting
an hour.  The power is then removed, and the radio doesn't remember the
attempts when it is powered up again.

Codes are guessed sequentially from 0000-1999.  No radio has been seen
with a code higher than 1999.  There is no feedback from the radio, so
it must be observed to know when it has been cracked.

LabJack U3 connections:
    FIO0-3 Station preset buttons 1-4 for code entry
    FIO4   Execute security code button ("Tuning >")
    FIO5   Power button
    FIO6   AT93C64 EEPROM CS signal interrupter
    FIO7   12VDC power input to radio

Lines are inverted (0=close contact, 1=open contact).

A pull-down resistor must be connected between the AT93C64's CS
line and GND so the EEPROM is disabled when its CS line is
disconnected from the radio's microcontroller.

A load must be connected in parallel with the radio's 12VDC input.
This can be a small DC motor or light bulb.  When 12VDC is disconnected,
the radio has residual power that can keep the microcontroller's RAM
alive.  The load is used to drain all the radio's residual power quickly.
If this is not done, the radio will remember the attempt count in its
microcontroller's RAM even if power is removed for a while.
"""

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
            self.labjack.setFIOState(u3.FIO0 + i, 1)
        time.sleep(0.2)

        # security code always defaults to "1000"
        self.digits = [1, 0, 0, 0]

    def enter_code(self, code):
        """Toggle in a new security code without executing it.  Code
        is an integer from 0-9999.  No radio has been seen with a code
        higher than"""
        code = str(code).rjust(4, "0")
        digits = [ int(c) for c in code ]

        for button, digit in enumerate(digits):
            while self.digits[button] != digit:
                self.press_preset_button(button)

    def execute(self):
        """Execute the current security code to try and unlock the radio"""
        self.labjack.setFIOState(u3.FIO4, 0) # button down
        time.sleep(3) # execute requires a long press

        self.labjack.setFIOState(u3.FIO4, 1) # button up
        time.sleep(5) # long delay until radio finishes flashing "SAFE"

    def press_power_button(self):
        """Press the power button"""
        for state in (0, 1): # 0=button down, 1=button up
            self.labjack.setFIOState(u3.FIO5, state)
            time.sleep(0.2)

    def press_preset_button(self, button):
        """Press a preset button and update the button's current digit.
        Button is an integer starting at 0 for preset 1."""
        for state in (0, 1): # 0=button down, 1=button up
            self.labjack.setFIOState(u3.FIO0 + button, state)
            time.sleep(0.2)

        self.digits[button] += 1
        if self.digits[button] > 9:
            self.digits[button] = 0


class Harness(object):
    """Hardware test harness control (12VDC power, EEPROM CS block)"""
    def __init__(self, labjack=None):
        if labjack is None:
            labjack = u3.U3()
            labjack.configU3()
        self.labjack = labjack

    def power_on(self):
        '''Turn on all 12VDC power to the radio'''
        self.labjack.setFIOState(u3.FIO7, 0)

    def power_off(self):
        '''Turn off all 12VDC power to the radio'''
        self.labjack.setFIOState(u3.FIO7, 1)

    def allow_eeprom_cs(self):
        '''Allow the EEPROM to see the CS signal from the
        radio's microcontroller'''
        self.labjack.setFIOState(u3.FIO6, 0)

    def deny_eeprom_cs(self):
        '''Deny the EEPROM from seing the CS signal by disconnecting it
        from the radio's microcontroller and making it always
        low (not enabled)'''
        self.labjack.setFIOState(u3.FIO6, 1)


class Cracker(object):
    """Crack a radio by brute force guessing codes"""
    def __init__(self, radio, harness):
        self.radio = radio
        self.harness = harness

    def crack(self, starting_code):
        code = starting_code
        max_code = 1999
        tries_this_cycle = 0

        self.power_on()

        while code <= max_code:
            percent = (float(code) / max_code) * 100
            print("Trying code %04d (max=%04d, %0.2f%% done)" % (
                code, max_code, percent))

            self.radio.enter_code(code)
            self.radio.execute()
            self.radio.clear()

            code += 1

            # the radio allows only 2 tries, then it locks out code entry
            # for an hour.  since we have blocked updating the attempt
            # count in the eeprom, power cycling allows us to try again
            # without waiting.
            tries_this_cycle += 1
            if tries_this_cycle == 2:
                self.power_off()
                self.power_on()
                self.tries_this_cycle = 0

    def power_on(self):
        print("Power on sequence")
        self.harness.allow_eeprom_cs()
        time.sleep(0.5)
        self.harness.power_on()
        time.sleep(2)
        self.radio.press_power_button()
        self.radio.clear()
        time.sleep(8)
        self.harness.deny_eeprom_cs()

    def power_off(self):
        print("Power off sequence")
        self.harness.power_off()
        time.sleep(4)


def main():
    if len(sys.argv) != 2:
        sys.stderr.write("Usage: crack.py <starting code>\n")
        sys.exit(1)
    starting_code=int(sys.argv[1])

    labjack = u3.U3()
    labjack.configU3()
    radio = Radio(labjack)
    harness = Harness(labjack)
    Cracker(radio, harness).crack(starting_code)


if __name__ == '__main__':
    main()
