#!/usr/bin/env python
import sys
import unittest
import serial # pyserial

CMD_SET_LED = 0x01
CMD_ECHO = 0x02
LED_GREEN = 0x00
LED_RED = 0x01
ACK = 0x06
NAK = 0x15

class Client(object):
    def __init__(self, ser):
        self.serial = ser

    def send_command(self, data):
        rx_bytes = self.send_raw(data)
        if rx_bytes[0] != ACK:
            raise Exception("Bad response: %r" % rx_bytes)
        return rx_bytes

    def send_raw(self, data):
        self.serial.write(bytearray([len(data)] + list(data)))
        self.serial.flush()
        num_bytes = ord(self.serial.read(1))
        rx_bytes = bytearray(self.serial.read(num_bytes))
        if len(rx_bytes) != num_bytes:
            raise Exception("Timeout")
        return rx_bytes

    def set_led(self, led_num, led_state):
        self.send_command([CMD_SET_LED, led_num, int(led_state)])


class AvrTests(unittest.TestCase):
    def _make_client(self):
        if getattr(self, 'serial', None) is None:
            self.serial = serial.Serial(port='/dev/cu.usbserial-FTHKH0VE',
                baudrate=57600, timeout=2)
        return Client(self.serial)

    # Command dispatch

    def test_dispatch_returns_nak_for_zero_length_command(self):
        client = self._make_client()
        rx_bytes = client.send_raw([])
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_dispatch_returns_nak_for_invalid_command(self):
        client = self._make_client()
        rx_bytes = client.send_raw([0xFF])
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Echo command

    def test_echo_empty_args_returns_empty_ack(self):
        client = self._make_client()
        rx_bytes = client.send_raw([CMD_ECHO])
        self.assertEqual(rx_bytes, bytearray([ACK]))

    def test_echo_returns_args(self):
        for args in ([], [1], [1, 2, 3], list(range(254))):
            client = self._make_client()
            rx_bytes = client.send_raw([CMD_ECHO] + args)
            self.assertEqual(rx_bytes, bytearray([ACK] + args))

    # Set LED command

    def test_set_led_returns_nak_for_bad_args_length(self):
        for args in ([], [1]):
            client = self._make_client()
            rx_bytes = client.send_raw([CMD_SET_LED] + args)
            self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_returns_nak_for_bad_led(self):
        client = self._make_client()
        rx_bytes = client.send_raw([CMD_SET_LED, 0xFF, 1])
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_changes_valid_led(self):
        client = self._make_client()
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                rx_bytes = client.send_raw([CMD_SET_LED, led, state])
                self.assertEqual(rx_bytes, bytearray([ACK]))


if __name__ == '__main__':
    def test_suite():
        return unittest.findTestCases(sys.modules[__name__])
    unittest.main(defaultTest='test_suite')
