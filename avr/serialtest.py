#!/usr/bin/env python
import os
import sys
import time
import unittest
import serial # pyserial

CMD_SET_LED = 0x01
CMD_ECHO = 0x02
CMD_DUMP_UPD_STATE = 0x03
CMD_RESET_UPD = 0x04
CMD_PROCESS_UPD_COMMAND = 0x05
ACK = 0x06
NAK = 0x15
LED_GREEN = 0x00
LED_RED = 0x01
UPD_RAM_DISPLAY_DATA = 0
UPD_RAM_PICTOGRAPH = 1
UPD_RAM_CHARGEN = 2
UPD_RAM_NONE = 0xFF

class Client(object):
    def __init__(self, ser):
        self.serial = ser

    # High level

    def echo(self, data):
        rx_bytes = self.command(bytearray([CMD_ECHO]) + bytearray(data))
        return rx_bytes[1:]

    def set_led(self, led_num, led_state):
        self.command([CMD_SET_LED, led_num, int(led_state)])

    def reset_upd(self):
        self.command([CMD_RESET_UPD])

    def dump_upd_state(self):
        raw = self.command([CMD_DUMP_UPD_STATE])
        dump = {'ram_area': raw[1],
                'ram_size': raw[2],
                'address': raw[3],
                'increment': bool(raw[4]),
                'display_data_ram': raw[5:30],
                'pictograph_ram': raw[30:38],
                'chargen_ram': raw[38:150]
               }
        assert len(dump['display_data_ram']) == 25
        assert len(dump['pictograph_ram']) == 8
        assert len(dump['chargen_ram']) == 112
        return dump

    def process_upd_command(self, spi_bytes):
        data = bytearray([CMD_PROCESS_UPD_COMMAND]) + bytearray(spi_bytes)
        self.command(data)

    # Low level

    def command(self, data, ignore_nak=False):
        self.send(data)
        return self.receive(ignore_nak)

    def send(self, data):
        self.serial.write(bytearray([len(data)] + list(data)))
        self.serial.flush()

    def receive(self, ignore_nak=False):
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
                "Invalid: Too long: expected %d bytes, got %d bytes: %r " %
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


class AvrTests(unittest.TestCase):
    serial = None # serial.Serial instance

    # Command timeout

    if 'ALL' in os.environ:
        def test_timeout_ignores_incomplete_command(self):
            '''this test takes 2.25 seconds'''
            client = Client(self.serial)
            # send incomplete command
            client.serial.write(bytearray([42, 1, 2, 3]))
            client.serial.flush()
            # wait longer than timeout period
            time.sleep(2.25)
            # command should have timed out
            # next command should complete successfully
            rx_bytes = client.command(
                data=[CMD_ECHO], ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([ACK]))

        def test_timeout_timer_resets_after_each_byte(self):
            '''this test takes 6 seconds'''
            client = Client(self.serial)
            # send individual bytes very slowly
            for b in (5,CMD_ECHO,4,3,2,1,):
                client.serial.write(bytearray([b]))
                client.serial.flush()
                time.sleep(1)
            # command should not have timed out
            rx_bytes = client.receive()
            self.assertEqual(rx_bytes, bytearray([ACK,4,3,2,1,]))

    # Command dispatch

    def test_dispatch_returns_nak_for_zero_length_command(self):
        client = Client(self.serial)
        rx_bytes = client.command(data=[], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_dispatch_returns_nak_for_invalid_command(self):
        client = Client(self.serial)
        rx_bytes = client.command(data=[0xFF], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Echo command

    def test_high_level_echo(self):
        client = Client(self.serial)
        data = b'Hello world'
        self.assertEqual(client.echo(data), data)

    def test_echo_empty_args_returns_empty_ack(self):
        client = Client(self.serial)
        rx_bytes = client.command(
            data=[CMD_ECHO], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([ACK]))

    def test_echo_returns_args(self):
        for args in ([], [1], [1, 2, 3], list(range(254))):
            client = Client(self.serial)
            rx_bytes = client.command(
                data=[CMD_ECHO] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([ACK] + args))

    # Set LED command

    def test_high_level_set_led(self):
        client = Client(self.serial)
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                client.set_led(led, state)

    def test_set_led_returns_nak_for_bad_args_length(self):
        for args in ([], [1]):
            client = Client(self.serial)
            rx_bytes = client.command(
                data=[CMD_SET_LED] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_returns_nak_for_bad_led(self):
        client = Client(self.serial)
        rx_bytes = client.command(
            data=[CMD_SET_LED, 0xFF, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_changes_valid_led(self):
        client = Client(self.serial)
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                rx_bytes = client.command(
                    data=[CMD_SET_LED, led, state], ignore_nak=True)
                self.assertEqual(rx_bytes, bytearray([ACK]))

    # Reset UPD command

    def test_reset_upd_accepts_no_args(self):
        client = Client(self.serial)
        rx_bytes = client.command(
            data=[CMD_RESET_UPD, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Dump UPD State command

    def test_dump_upd_state_accepts_no_args(self):
        client = Client(self.serial)
        rx_bytes = client.command(
            data=[CMD_DUMP_UPD_STATE, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_dump_upd_state_dumps_serialized_state(self):
        client = Client(self.serial)
        rx_bytes = client.command(
            data=[CMD_DUMP_UPD_STATE], ignore_nak=True)
        self.assertEqual(rx_bytes[0], ACK)
        self.assertEqual(len(rx_bytes), 150)

    # uPD16432B Emulator

    def test_upd_resets_to_known_state(self):
        client = Client(self.serial)
        client.reset_upd()
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_NONE) # 0=none
        self.assertEqual(state['ram_size'], 0)
        self.assertEqual(state['address'], 0)
        self.assertEqual(state['increment'], False)
        self.assertEqual(state['display_data_ram'], bytearray([0]*25))
        self.assertEqual(state['chargen_ram'], bytearray([0]*112))
        self.assertEqual(state['pictograph_ram'], bytearray([0]*8))

    def test_upd_process_ignores_empty_spi_bytes(self):
        client = Client(self.serial)
        client.reset_upd()
        old_state = client.dump_upd_state()
        client.process_upd_command([])
        self.assertEqual(client.dump_upd_state(), old_state)

    # uPD16432B Emulator: Data Setting Command

    def test_upd_data_setting_sets_display_data_ram_area_increment_off(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00001000 # increment off
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_DISPLAY_DATA)
        self.assertEqual(state['ram_size'], 25)
        self.assertEqual(state['increment'], False)

    def test_upd_data_setting_sets_display_data_ram_area_increment_on(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00000000 # increment on
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_DISPLAY_DATA)
        self.assertEqual(state['ram_size'], 25)
        self.assertEqual(state['increment'], True)

    def test_upd_data_setting_sets_pictograph_ram_area_increment_off(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_PICTOGRAPH)
        self.assertEqual(state['ram_size'], 8)
        self.assertEqual(state['increment'], False)

    def test_upd_data_setting_sets_chargen_ram_area_increment_on(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_CHARGEN)
        self.assertEqual(state['ram_size'], 112)
        self.assertEqual(state['increment'], True)

    def test_upd_data_setting_sets_chargen_ram_area_ignores_increment_off(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (should be ignored)
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_CHARGEN)
        self.assertEqual(state['ram_size'], 112)
        self.assertEqual(state['increment'], True)

    def test_upd_data_setting_unrecognized_ram_area_sets_none(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_NONE)
        self.assertEqual(state['ram_size'], 0)
        self.assertEqual(state['address'], 0)
        self.assertEqual(state['increment'], True)

    def test_upd_data_setting_unrecognized_ram_area_ignores_increment_off(self):
        client = Client(self.serial)
        client.reset_upd()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        cmd |= 0b00001000 # increment off (should be ignored)
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_NONE)
        self.assertEqual(state['ram_size'], 0)
        self.assertEqual(state['address'], 0)
        self.assertEqual(state['increment'], True)

    # uPD16432B Emulator: Address Setting Command

    def test_upd_address_setting_unrecognized_ram_area_sets_zero(self):
        client = Client(self.serial)
        client.reset_upd()
        state = client.dump_upd_state()
        self.assertEqual(state['ram_area'], UPD_RAM_NONE)
        cmd  = 0b10000000 # address setting command
        cmd |= 0b00000011 # address 0x03
        client.process_upd_command([cmd])
        state = client.dump_upd_state()
        self.assertEqual(state['address'], 0)

    def test_upd_address_setting_sets_addresses_for_each_ram_area(self):
        client = Client(self.serial)
        tuples = (
            (UPD_RAM_DISPLAY_DATA, 0b00000000, 0,       0), # min
            (UPD_RAM_DISPLAY_DATA, 0b00000000, 0x18, 0x18), # max
            (UPD_RAM_DISPLAY_DATA, 0b00000000, 0x19,    0), # out of range

            (UPD_RAM_PICTOGRAPH,   0b00000001,    0,    0), # min
            (UPD_RAM_PICTOGRAPH,   0b00000001, 0x07, 0x07), # max
            (UPD_RAM_PICTOGRAPH,   0b00000001, 0x08,    0), # out of range

            (UPD_RAM_CHARGEN,      0b00000010,    0,    0), # min
            (UPD_RAM_CHARGEN,      0b00000010, 0x0f, 0x69), # max
            (UPD_RAM_CHARGEN,      0b00000010, 0x10,    0), # out of range
        )
        for ram_area, ram_select_bits, address, expected_address in tuples:
            client.reset_upd()
            # data setting command
            cmd  = 0b01000000 # data setting command
            cmd |= ram_select_bits
            client.process_upd_command([cmd])
            state = client.dump_upd_state()
            self.assertEqual(state['ram_area'], ram_area)
            # address setting command
            cmd = 0b10000000
            cmd |= address
            client.process_upd_command([cmd])
            # address should be character number * 7 (7 bytes per char)
            state = client.dump_upd_state()
            self.assertEqual(state['address'], expected_address)

def make_serial():
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=115200, timeout=2)

def make_client(serial=None):
    if serial is None:
        serial = make_serial()
    return Client(serial)

def test_suite():
    return unittest.findTestCases(sys.modules[__name__])

def main():
    AvrTests.serial = make_serial()
    unittest.main(defaultTest='test_suite')

if __name__ == '__main__':
    main()
