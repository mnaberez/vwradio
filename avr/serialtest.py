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
        return rx_bytes

    def send_command(self, data, ignore_nak=False):
        self.serial.write(bytearray([len(data)] + list(data)))
        self.serial.flush()

        # read number of bytes to expect
        head = self.serial.read(1)
        if len(head) == 0:
            raise Exception("Timeout: No reply header byte received")
        expected_num_bytes = ord(head)

        # read bytes expected, or more if available
        num_bytes_to_read = expected_num_bytes
        if self.serial.in_waiting > num_bytes_to_read: # unexpected extra data
            num_bytes_to_read = self.serial.in_waiting
        rx_bytes = bytearray(self.serial.read(num_bytes_to_read))

        # sanity checks on reply length
        if len(rx_bytes) < expected_num_bytes:
            raise Exception(
                "Timeout: Expected reply of %d bytes, got only %d bytes: %r" %
                (expected_num_bytes, len(rx_bytes), rx_bytes)
                )
        elif len(rx_bytes) > expected_num_bytes:
            raise Exception(
                "Invalid: Too long: expected of %d bytes, got %d bytes: %r " %
                (expected_num_bytes, len(rx_bytes), rx_bytes)
            )
        elif len(rx_bytes) == 0:
            raise Exception("Invalid: Reply had header byte but not ack/nak")

        # check ack/nak byte
        if rx_bytes[0] not in (ACK, NAK):
            raise Exception("Invalid: First byte not ACK/NAK: %r" % rx_bytes)
        elif (rx_bytes[0] == NAK) and (not ignore_nak):
            raise Exception("Received NAK response: %r" % rx_bytes)

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
        rx_bytes = client.send_command(data=[], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_dispatch_returns_nak_for_invalid_command(self):
        client = self._make_client()
        rx_bytes = client.send_command(data=[0xFF], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Echo command

    def test_echo_empty_args_returns_empty_ack(self):
        client = self._make_client()
        rx_bytes = client.send_command(
            data=[CMD_ECHO], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([ACK]))

    def test_echo_returns_args(self):
        for args in ([], [1], [1, 2, 3], list(range(254))):
            client = self._make_client()
            rx_bytes = client.send_command(
                data=[CMD_ECHO] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([ACK] + args))

    # Set LED command

    def test_set_led_returns_nak_for_bad_args_length(self):
        for args in ([], [1]):
            client = self._make_client()
            rx_bytes = client.send_command(
                data=[CMD_SET_LED] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_returns_nak_for_bad_led(self):
        client = self._make_client()
        rx_bytes = client.send_command(
            data=[CMD_SET_LED, 0xFF, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_changes_valid_led(self):
        client = self._make_client()
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                rx_bytes = client.send_command(
                    data=[CMD_SET_LED, led, state], ignore_nak=True)
                self.assertEqual(rx_bytes, bytearray([ACK]))


if __name__ == '__main__':
    def test_suite():
        return unittest.findTestCases(sys.modules[__name__])
    unittest.main(defaultTest='test_suite')
