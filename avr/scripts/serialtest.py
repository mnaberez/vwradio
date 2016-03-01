#!/usr/bin/env python
import os
import struct
import sys
import time
import unittest
import serial # pyserial
from vwradio.radios import DisplayModes, OperationModes, TunerBands

CMD_SET_LED = 0x01
CMD_ECHO = 0x02
CMD_SET_RUN_MODE = 0x03
CMD_EMULATED_UPD_DUMP_STATE = 0x10
CMD_EMULATED_UPD_SEND_COMMAND = 0x11
CMD_EMULATED_UPD_RESET = 0x12
CMD_RADIO_LOAD_KEY_DATA = 0x20
CMD_RADIO_STATE_PROCESS = 0x21
CMD_RADIO_STATE_DUMP = 0x22
CMD_RADIO_STATE_RESET = 0x23
CMD_FACEPLATE_UPD_DUMP_STATE = 0x30
CMD_FACEPLATE_UPD_SEND_COMMAND = 0x31
CMD_FACEPLATE_CLEAR_DISPLAY = 0x32
ACK = 0x06
NAK = 0x15
RUN_MODE_NORMAL = 0x00
RUN_MODE_TEST = 0x01
LED_GREEN = 0x00
LED_RED = 0x01
UPD_RAM_DISPLAY = 0
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

    def set_run_mode(self, mode):
        self.command([CMD_SET_RUN_MODE, mode])

    def set_led(self, led_num, led_state):
        self.command([CMD_SET_LED, led_num, int(led_state)])

    def emulated_upd_reset(self):
        self.command([CMD_EMULATED_UPD_RESET])

    def emulated_upd_dump_state(self):
        data = self.command([CMD_EMULATED_UPD_DUMP_STATE])
        return UpdEmulatorState(data[1:])

    def emulated_upd_send_command(self, spi_bytes):
        data = bytearray([CMD_EMULATED_UPD_SEND_COMMAND]) + bytearray(spi_bytes)
        self.command(data)

    def faceplate_upd_send_command(self, spi_bytes):
        data = bytearray([CMD_FACEPLATE_UPD_SEND_COMMAND]) + bytearray(spi_bytes)
        self.command(data)

    def faceplate_upd_dump_state(self):
        data = self.command([CMD_FACEPLATE_UPD_DUMP_STATE])
        return UpdEmulatorState(data[1:])

    def faceplate_clear_display(self):
        self.command([CMD_FACEPLATE_CLEAR_DISPLAY])

    def radio_load_key_data(self, key_bytes):
        data = bytearray([CMD_RADIO_LOAD_KEY_DATA]) + bytearray(key_bytes)
        self.command(data)

    def radio_state_reset(self):
        self.command([CMD_RADIO_STATE_RESET])

    def radio_state_dump(self):
        data = self.command([CMD_RADIO_STATE_DUMP])
        return RadioState(data[1:])

    def radio_state_process(self, display_ram):
        data = bytearray([CMD_RADIO_STATE_PROCESS]) + bytearray(display_ram)
        self.command(data)

    # Low level

    def command(self, data, ignore_nak=False):
        self._flush_rx() # discard rx if a previous command was interrupted
        self.send(data)
        return self.receive(ignore_nak)

    def send(self, data):
        self.serial.write(bytearray([len(data)] + list(data)))
        self._flush_tx()

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

    def _flush_rx(self):
        num_bytes = self.serial.in_waiting
        if num_bytes:
            self.serial.read(num_bytes)

    def _flush_tx(self):
        self.serial.flush()


class UpdEmulatorState(object):
    def __init__(self, data):
        self.ram_area = data[0]
        self.ram_size = data[1]
        self.address = data[2]
        self.increment = bool(data[3])
        self.display_ram = data[4:29]
        self.display_ram_dirty = bool(data[29])
        self.pictograph_ram = data[30:38]
        self.pictograph_ram_dirty = bool(data[38])
        self.chargen_ram  = data[39:151]
        self.chargen_ram_dirty = bool(data[151])

    def __repr__(self):
        return '<%s: %s> ' % (self.__class__.__name__, repr(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


class RadioState(object):
    def __init__(self, data):
        assert len(data) == 30
        self.operation_mode = data[0]
        self.display_mode = data[1]
        self.safe_tries = data[2]
        self.safe_code = (data[3] + (data[4] << 8))
        self.sound_bass =     struct.unpack('b', bytearray([data[5]]))[0]
        self.sound_treble =   struct.unpack('b', bytearray([data[6]]))[0]
        self.sound_midrange = struct.unpack('b', bytearray([data[7]]))[0]
        self.sound_balance =  struct.unpack('b', bytearray([data[8]]))[0]
        self.sound_fade =     struct.unpack('b', bytearray([data[9]]))[0]
        self.tape_side = data[10]
        self.cd_disc = data[11]
        self.cd_track = data[12]
        self.cd_cue_pos = (data[13] + (data[14] << 8))
        self.tuner_freq = (data[15] + (data[16] << 8))
        self.tuner_preset = data[17]
        self.tuner_band = data[18]
        self.display = data[19:30]

    def __repr__(self):
        return '<%s: %s> ' % (self.__class__.__name__, repr(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


class AvrTests(unittest.TestCase):
    serial = None # serial.Serial instance

    def setUp(self):
        self.client = Client(self.serial)
        self.client.set_run_mode(RUN_MODE_TEST)

    def tearDown(self):
        self.client.set_run_mode(RUN_MODE_NORMAL)

    # Command timeout

    if 'ALL' in os.environ:
        def test_timeout_ignores_incomplete_command(self):
            '''this test takes 2.25 seconds'''
            # send incomplete command
            self.client.serial.write(bytearray([42, 1, 2, 3]))
            self.client.serial.flush()
            # wait longer than timeout period
            time.sleep(2.25)
            # command should have timed out
            # next command should complete successfully
            rx_bytes = self.client.command(
                data=[CMD_ECHO], ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([ACK]))

        def test_timeout_timer_resets_after_each_byte(self):
            '''this test takes 6 seconds'''
            # send individual bytes very slowly
            for b in (5,CMD_ECHO,4,3,2,1,):
                self.client.serial.write(bytearray([b]))
                self.client.serial.flush()
                time.sleep(1)
            # command should not have timed out
            rx_bytes = self.client.receive()
            self.assertEqual(rx_bytes, bytearray([ACK,4,3,2,1,]))

    # Command dispatch

    def test_dispatch_returns_nak_for_zero_length_command(self):
        rx_bytes = self.client.command(data=[], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_dispatch_returns_nak_for_invalid_command(self):
        rx_bytes = self.client.command(data=[0xFF], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Echo command

    def test_high_level_echo(self):
        data = b'Hello world'
        self.assertEqual(self.client.echo(data), data)

    def test_echo_empty_args_returns_empty_ack(self):
        rx_bytes = self.client.command(
            data=[CMD_ECHO], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([ACK]))

    def test_echo_returns_args(self):
        for args in ([], [1], [1, 2, 3], list(range(254))):
            rx_bytes = self.client.command(
                data=[CMD_ECHO] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([ACK] + args))

    # Set run mode command

    def test_set_run_mode_returns_nak_for_bad_args_length(self):
        for args in ([], [RUN_MODE_TEST, 1]):
            rx_bytes = self.client.command(
                data=[CMD_SET_RUN_MODE] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_run_mode_returns_nak_for_bad_mode(self):
        rx_bytes = self.client.command(
            data=[CMD_SET_RUN_MODE, 0xFF], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Set LED command

    def test_high_level_set_led(self):
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                self.client.set_led(led, state)

    def test_set_led_returns_nak_for_bad_args_length(self):
        for args in ([], [1]):
            rx_bytes = self.client.command(
                data=[CMD_SET_LED] + args, ignore_nak=True)
            self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_returns_nak_for_bad_led(self):
        rx_bytes = self.client.command(
            data=[CMD_SET_LED, 0xFF, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_set_led_changes_valid_led(self):
        for led in (LED_GREEN, LED_RED):
            for state in (1, 0):
                rx_bytes = self.client.command(
                    data=[CMD_SET_LED, led, state], ignore_nak=True)
                self.assertEqual(rx_bytes, bytearray([ACK]))

    # Radio State Reset command

    def test_radio_state_reset_returns_nak_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[CMD_RADIO_STATE_RESET, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Radio State Dump command

    def test_radio_state_dump_returns_nak_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[CMD_RADIO_STATE_DUMP, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Reset UPD command

    def test_emulated_upd_reset_accepts_no_args(self):
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_RESET, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    # Dump UPD State command

    def test_emulated_upd_dump_state_accepts_no_args(self):
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_DUMP_STATE, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_emulated_upd_dump_state_dumps_serialized_state(self):
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_DUMP_STATE], ignore_nak=True)
        self.assertEqual(rx_bytes[0], ACK)
        self.assertEqual(len(rx_bytes), 153)

    # Process UPD Command command

    def test_process_upd_cmd_allows_empty_spi_data(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_SEND_COMMAND] + [], ignore_nak=True)
        self.assertEqual(rx_bytes[0], ACK)
        self.assertEqual(len(rx_bytes), 1)

    def test_process_upd_cmd_allows_max_spi_data_size_of_32(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_SEND_COMMAND] + ([0] * 32), ignore_nak=True)
        self.assertEqual(rx_bytes[0], ACK)
        self.assertEqual(len(rx_bytes), 1)

    def test_process_upd_cmd_returns_nak_if_spi_data_size_exceeds_32(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[CMD_EMULATED_UPD_SEND_COMMAND] + ([0] * 33),
            ignore_nak=True
            )
        self.assertEqual(rx_bytes[0], NAK)
        self.assertEqual(len(rx_bytes), 1)

    # uPD16432B Emulator

    def test_upd_resets_to_known_state(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_NONE) # 0=none
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertEqual(state.increment, False)
        self.assertEqual(state.display_ram, bytearray([0]*25))
        self.assertEqual(state.chargen_ram, bytearray([0]*112))
        self.assertEqual(state.pictograph_ram, bytearray([0]*8))

    # uPD16432B Emulator: Data Setting Command

    def test_upd_data_setting_sets_display_ram_area_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_DISPLAY)
        self.assertEqual(state.ram_size, 25)
        self.assertEqual(state.increment, False)

    def test_upd_data_setting_sets_display_ram_area_increment_on(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_DISPLAY)
        self.assertEqual(state.ram_size, 25)
        self.assertEqual(state.increment, True)

    def test_upd_data_setting_sets_pictograph_ram_area_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_PICTOGRAPH)
        self.assertEqual(state.ram_size, 8)
        self.assertEqual(state.increment, False)

    def test_upd_data_setting_sets_chargen_ram_area_increment_on(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_CHARGEN)
        self.assertEqual(state.ram_size, 112)
        self.assertEqual(state.increment, True)

    def test_upd_data_setting_sets_chargen_ram_area_ignores_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (should be ignored)
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_CHARGEN)
        self.assertEqual(state.ram_size, 112)
        self.assertEqual(state.increment, True)

    def test_upd_data_setting_unrecognized_ram_area_sets_none(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_NONE)
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertEqual(state.increment, True)

    def test_upd_data_setting_unrecognized_ram_area_ignores_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        cmd |= 0b00001000 # increment off (should be ignored)
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_NONE)
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertEqual(state.increment, True)

    # uPD16432B Emulator: Address Setting Command

    def test_upd_address_setting_unrecognized_ram_area_sets_zero(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_NONE)
        cmd  = 0b10000000 # address setting command
        cmd |= 0b00000011 # address 0x03
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.address, 0)

    def test_upd_address_setting_sets_addresses_for_each_ram_area(self):
        tuples = (
            (UPD_RAM_DISPLAY, 0b00000000, 0,       0), # min
            (UPD_RAM_DISPLAY, 0b00000000, 0x18, 0x18), # max
            (UPD_RAM_DISPLAY, 0b00000000, 0x19,    0), # out of range

            (UPD_RAM_PICTOGRAPH,   0b00000001,    0,    0), # min
            (UPD_RAM_PICTOGRAPH,   0b00000001, 0x07, 0x07), # max
            (UPD_RAM_PICTOGRAPH,   0b00000001, 0x08,    0), # out of range

            (UPD_RAM_CHARGEN,      0b00000010,    0,    0), # min
            (UPD_RAM_CHARGEN,      0b00000010, 0x0f, 0x69), # max
            (UPD_RAM_CHARGEN,      0b00000010, 0x10,    0), # out of range
        )
        for ram_area, ram_select_bits, address, expected_address in tuples:
            self.client.emulated_upd_reset()
            # data setting command
            cmd  = 0b01000000 # data setting command
            cmd |= ram_select_bits
            self.client.emulated_upd_send_command([cmd])
            state = self.client.emulated_upd_dump_state()
            self.assertEqual(state.ram_area, ram_area)
            # address setting command
            cmd = 0b10000000
            cmd |= address
            self.client.emulated_upd_send_command([cmd])
            # address should be as expected
            state = self.client.emulated_upd_dump_state()
            self.assertEqual(state.address, expected_address)

    # uPD16432B Emulator: Writing Data

    def test_upd_no_ram_area_ignores_data(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        # address setting command
        # followed by bytes that should be ignored
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 8))
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        self.assertEqual(self.client.emulated_upd_dump_state(), state)

    def test_upd_display_increment_on_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        # followed by a unique byte for all 25 bytes of display data ram
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 26))
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_DISPLAY)
        self.assertEqual(state.increment, True)
        self.assertEqual(state.address, 0) # wrapped around
        self.assertEqual(state.display_ram, data)

    def test_upd_display_increment_off_rewrites_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        cmd = 0b10000000
        cmd |= 5 # address 5
        # address setting command
        # followed by bytes that should be written to address 5 only
        self.client.emulated_upd_send_command([cmd, 1, 2, 3, 4, 5, 6, 7])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, UPD_RAM_DISPLAY)
        self.assertEqual(state.increment, False)
        self.assertEqual(state.address, 5)
        self.assertEqual(state.display_ram[5], 7)

    # uPD16432B Emulator: Dirty RAM Tracking

    def test_upd_writing_display_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.display_ram_dirty)
        self.assertEqual(state.display_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 0])
        # dirty flag should still be false
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.display_ram_dirty)

    def test_upd_writing_display_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.display_ram_dirty)
        self.assertEqual(state.display_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display data ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 1])
        # dirty flag should be true
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.display_ram[0], 1)
        self.assertTrue(state.display_ram_dirty)

    def test_upd_writing_pictograph_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.pictograph_ram_dirty)
        self.assertEqual(state.pictograph_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 0])
        # dirty flag should still be false
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.pictograph_ram_dirty)

    def test_upd_writing_pictograph_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.pictograph_ram_dirty)
        self.assertEqual(state.pictograph_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 1])
        # dirty flag should be true
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.pictograph_ram[0], 1)
        self.assertTrue(state.pictograph_ram_dirty)

    def test_upd_writing_chargen_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.chargen_ram_dirty)
        self.assertEqual(state.chargen_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 0])
        # dirty flag should still be false
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.chargen_ram_dirty)

    def test_upd_writing_chargen_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertFalse(state.chargen_ram_dirty)
        self.assertEqual(state.chargen_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 1])
        # dirty flag should be true
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.chargen_ram[0], 1)
        self.assertTrue(state.chargen_ram_dirty)

    # Faceplate

    def test_faceplate_clear_display_returns_nak_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[CMD_FACEPLATE_CLEAR_DISPLAY, 1], ignore_nak=True)
        self.assertEqual(rx_bytes, bytearray([NAK]))

    def test_faceplate_clear_display(self):
        self.client.faceplate_clear_display() # shouldn't raise

    def test_faceplate_upd_send_command_allows_max_spi_data_size_of_32(self):
        rx_bytes = self.client.command(
            data=[CMD_FACEPLATE_UPD_SEND_COMMAND] + [0x80] + ([0] * 31),
            ignore_nak=True
            )
        self.assertEqual(rx_bytes[0], ACK)
        self.assertEqual(len(rx_bytes), 1)

    def test_faceplate_upd_send_command_nak_if_spi_data_size_exceeds_32(self):
        rx_bytes = self.client.command(
            data=[CMD_FACEPLATE_UPD_SEND_COMMAND] + ([0] * 33),
            ignore_nak=True
            )
        self.assertEqual(rx_bytes[0], NAK)
        self.assertEqual(len(rx_bytes), 1)

    def test_faceplate_upd_send_command(self):
        # Data Setting command: write to display data ram
        data = [0x40]
        self.client.faceplate_upd_send_command(data) # shouldn't raise
        # Address Setting command + display data
        data = [0x80, 0, 0, 0x6f, 0x6c, 0x6c, 0x65, 0x48]
        self.client.faceplate_upd_send_command(data) # shouldn't raise

    # Radio State

    def test_radio_state_safe_mode(self):
        values = (
            # Premium 4
            (b"     0000  ",    0, 0, OperationModes.SAFE_ENTRY),
            (b"1    1234  ", 1234, 1, OperationModes.SAFE_ENTRY),
            (b"2    5678  ", 5678, 2, OperationModes.SAFE_ENTRY),
            (b"9    9999  ", 9999, 9, OperationModes.SAFE_ENTRY),
            # Premium 5
            (b"    0000   ",    0, 0, OperationModes.SAFE_ENTRY),
            (b"1   1234   ", 1234, 1, OperationModes.SAFE_ENTRY),
            (b"2   5678   ", 5678, 2, OperationModes.SAFE_ENTRY),
            (b"9   9999   ", 9999, 9, OperationModes.SAFE_ENTRY),
            # Premium 4 and 5
            (b"     SAFE  ", 1000, 0, OperationModes.SAFE_LOCKED),
            (b"1    SAFE  ", 1000, 1, OperationModes.SAFE_LOCKED),
            (b"2    SAFE  ", 1000, 2, OperationModes.SAFE_LOCKED),
            (b"9    SAFE  ", 1000, 9, OperationModes.SAFE_LOCKED),
        )
        for display, safe_code, safe_tries, mode in values:
            self.client.radio_state_reset()
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.safe_code, safe_code)
            self.assertEqual(state.safe_tries, safe_tries)
            self.assertEqual(state.operation_mode, mode)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_volume(self):
        displays = (
            b"AM    MIN  ",
            b"AM    MAX  ",
            b"FM1   MIN  ",
            b"FM1   MAX  ",
            b"FM2   MIN  ",
            b"FM2   MAX  ",
            b"CD    MIN  ",
            b"CD    MAX  ",
            b"TAP   MIN  ",
            b"TAP   MAX  ",
        )
        for display in displays:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_VOLUME)

    def test_radio_state_balance(self):
        values = (
            (b"BAL LEFT  9", -9),
            (b"BAL LEFT  1", -1),
            (b"BAL CENTER ", 0),
            (b"BAL RIGHT 1", 1),
            (b"BAL RIGHT 9", 9),
        )
        for display, balance in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_BALANCE)
            self.assertEqual(state.sound_balance, balance)

    def test_radio_state_fade(self):
        values = (
            (b"FADEREAR  9", -9),
            (b"FADEREAR  1", -1),
            (b"FADECENTER ", 0),
            (b"FADEFRONT 1", 1),
            (b"FADEFRONT 9", 9),
        )
        for display, fade in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_FADE)
            self.assertEqual(state.sound_fade, fade)

    def test_radio_state_bass(self):
        values = (
            (b"BASS  - 9  ", -9),
            (b"BASS  - 1  ", -1),
            (b"BASS    0  ", 0),
            (b"BASS  + 1  ", 1),
            (b"BASS  + 9  ", 9),
        )
        for display, bass in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_BASS)
            self.assertEqual(state.sound_bass, bass)

    def test_radio_state_treble(self):
        values = (
            (b"TREB  - 9  ", -9),
            (b"TREB  - 1  ", -1),
            (b"TREB    0  ", 0),
            (b"TREB  + 1  ", 1),
            (b"TREB  + 9  ", 9),
        )
        for display, treble in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_TREBLE)
            self.assertEqual(state.sound_treble, treble)

    def test_radio_state_premium_5_midrange(self):
        values = (
            (b"MID   - 9  ", -9),
            (b"MID   - 1  ", -1),
            (b"MID     0  ", 0),
            (b"MID   + 1  ", 1),
            (b"MID   + 9  ", 9),
        )
        for display, mid in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_process(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # process display
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_MIDRANGE)
            self.assertEqual(state.sound_midrange, mid)

    def test_radio_state_cd_playing(self):
        values = (
            (b"CD 1 TR 01 ", 1, 1),
            (b"CD 6 TR 99 ", 6, 99),
        )
        for display, disc, track in values:
            self.client.radio_state_reset()
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, disc)
            self.assertEqual(state.cd_track, track)
            self.assertEqual(state.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_cueing(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 5 TR 12 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 12)
        # process display
        self.client.radio_state_process(b"CUE   122  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 12)
        # self.assertEqual(radio.cd_cue_pos, 122) TODO
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CUEING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_check_magazine(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 1 TR 03 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 1)
        self.assertEqual(state.cd_track, 3)
        # radio.cd_cue_pos = 99 # TODO
        # process display
        self.client.radio_state_process(b"CHK MAGAZIN")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_cue_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CHECK_MAGAZINE)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_cdx_no_cd(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 1 TR 03 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 1)
        self.assertEqual(state.cd_track, 3)
        # radio.cd_cue_pos = 99 # TODO
        # process display
        self.client.radio_state_process(b"CD 2 NO CD ") # space in "CD 2"
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 2)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_cue_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CDX_NO_CD)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_cdx_cd_err(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 5 TR 03 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 3)
        # radio.cd_cue_pos = 99 # TODO
        # process display
        self.client.radio_state_process(b"CD1 CD ERR ") # no space in "CD1"
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 1)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_cue_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CDX_CD_ERR)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_no_disc(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 5 TR 03 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 3)
        # radio.cd_cue_pos = 99 # TODO
        # process display
        self.client.radio_state_process(b"    NO DISC")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_cue_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_NO_DISC)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_no_changer(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"CD 5 TR 03 ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 3)
        # radio.cd_cue_pos = 99 # TODO
        # process
        self.client.radio_state_process(b"NO  CHANGER")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_cue_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_NO_CHANGER)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_premium_5_tape_load(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"TAPE LOAD  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_LOAD)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_premium_5_tape_metal(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"TAPE METAL ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_METAL)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_play_a(self):
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_play_b(self):
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_ff(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"TAPE  FF   ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_FF)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_mss_ff(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        # process display
        self.client.radio_state_process(b"TAPEMSS FF ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_MSS_FF)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_rew(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"TAPE  REW  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_REW)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_mss_rew(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        # process display
        self.client.radio_state_process(b"TAPEMSS REW")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_MSS_REW)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_error(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"TAPE ERROR ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_ERROR)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_no_tape(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # process display
        self.client.radio_state_process(b"    NO TAPE")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_NO_TAPE)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_fm_scan_off(self):
        values = (
            (b"FM1  887MHz",  887, TunerBands.FM1, 0),
            (b"FM1  887MHZ",  887, TunerBands.FM1, 0),
            (b"FM1 1023MHZ", 1023, TunerBands.FM1, 0),
            (b"FM11 915MHZ",  915, TunerBands.FM1, 1),
            (b"FM161079MHZ", 1079, TunerBands.FM1, 6),
            (b"FM2  887MHZ",  887, TunerBands.FM2, 0),
            (b"FM2 1023MHZ", 1023, TunerBands.FM2, 0),
            (b"FM21 915MHZ",  915, TunerBands.FM2, 1),
            (b"FM261079MHZ", 1079, TunerBands.FM2, 6),
            )
        for display, freq, band, preset in values:
            self.client.radio_state_reset()
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.tuner_band, band)
            self.assertEqual(state.tuner_freq, freq)
            self.assertEqual(state.tuner_preset, preset)
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_fm_scan_on_fm1_band(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_band, TunerBands.FM1)
        self.assertEqual(state.tuner_preset, 1)
        # process display
        self.client.radio_state_process(b"SCAN 879MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_freq, 879)
        self.assertEqual(state.tuner_preset, 0)
        self.assertEqual(state.tuner_band, TunerBands.FM1)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_fm_scan_on_fm2_band(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_process(b"FM21 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_band, TunerBands.FM2)
        self.assertEqual(state.tuner_preset, 1)
        # process display
        self.client.radio_state_process(b"SCAN 879MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_freq, 879)
        self.assertEqual(state.tuner_preset, 0)
        self.assertEqual(state.tuner_band, TunerBands.FM2)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_fm_scan_on_unknown_band_sets_fm1(self):
        # set up known values
        self.client.radio_state_reset()
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_band, TunerBands.UNKNOWN)
        # process display
        self.client.radio_state_process(b"SCAN 879MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_freq, 879)
        self.assertEqual(state.tuner_preset, 0)
        self.assertEqual(state.tuner_band, TunerBands.FM1)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_SCANNING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_am_scan_off(self):
        values = (
            (b"AM   670kHz",  670, 0),
            (b"AM   670KHZ",  670, 0),
            (b"AM  1540KHZ", 1540, 0),
            (b"AM 1 670KHZ",  670, 1),
            (b"AM 61540KHZ", 1540, 6),
            )
        for display, freq, preset in values:
            self.client.radio_state_reset()
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.tuner_freq, freq)
            self.assertEqual(state.tuner_band, TunerBands.AM)
            self.assertEqual(state.operation_mode, OperationModes.TUNER_PLAYING)
            self.assertEqual(state.tuner_preset, preset)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tuner_am_scan_on(self):
        values = (
            (b"SCAN 530kHz",  530),
            (b"SCAN1710KHZ", 1710),
        )
        for display, freq in values:
            self.client.radio_state_reset()
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.tuner_freq, freq)
            self.assertEqual(state.tuner_band, TunerBands.AM)
            self.assertEqual(state.tuner_preset, 0)
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_SCANNING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_ignores_blank(self):
        self.client.radio_state_reset()
        # put into a known state
        self.client.radio_state_process(b"FM161079MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)
        # blank displays should not change the state
        for display in (b'\x00'*11, b' '*11):
            self.client.radio_state_process(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

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

def main(verbosity):
    AvrTests.serial = make_serial()
    unittest.main(defaultTest='test_suite', verbosity=verbosity)

if __name__ == '__main__':
    if 'VERBOSE' in os.environ:
        verbosity = 2 # test names
    else:
        verbosity = 1 # dots only
    main(verbosity)
