import itertools
import os
import time
import unittest

from vwradio.constants import DisplayModes, OperationModes, TunerBands, Keys, Pictographs
from vwradio.faceplates import Premium4
from vwradio import avrclient

# only test against real hardware when asked
if 'HARDWARE_TEST' in os.environ:
    BaseTestCase = unittest.TestCase
else:
    BaseTestCase = object

class TestAvr(BaseTestCase):
    serial = None # serial.Serial instance

    def setUp(self):
        if getattr(self, 'serial') is None:
            self.serial = avrclient.make_serial()
        self.client = avrclient.Client(self.serial)
        self.client.set_run_mode(avrclient.RUN_MODE_STOPPED)

    def tearDown(self):
        self.client.set_run_mode(avrclient.RUN_MODE_RUNNING)

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
                data=[avrclient.CMD_ECHO], ignore_error=True)
            self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK]))

        def test_timeout_timer_resets_after_each_byte(self):
            '''this test takes 6 seconds'''
            # send individual bytes very slowly
            for b in (5,avrclient.CMD_ECHO,4,3,2,1,):
                self.client.serial.write(bytearray([b]))
                self.client.serial.flush()
                time.sleep(1)
            # command should not have timed out
            rx_bytes = self.client.receive()
            self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK,4,3,2,1,]))

    # Command dispatch

    def test_dispatch_returns_error_for_zero_length_command(self):
        rx_bytes = self.client.command(data=[], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_NO_COMMAND]))

    def test_dispatch_returns_error_for_invalid_command(self):
        rx_bytes = self.client.command(data=[0xFF], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_COMMAND]))

    # Echo command

    def test_high_level_echo(self):
        data = b'Hello world'
        self.assertEqual(self.client.echo(data), data)

    def test_echo_empty_args_returns_empty_ack(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_ECHO], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK]))

    def test_echo_returns_args(self):
        for args in ([], [1], [1, 2, 3], list(range(254))):
            rx_bytes = self.client.command(
                data=[avrclient.CMD_ECHO] + args, ignore_error=True)
            self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK] + args))

    # Set Run Mode command

    def test_set_run_mode_returns_error_for_bad_args_length(self):
        for args in ([], [avrclient.RUN_MODE_STOPPED, 1]):
            rx_bytes = self.client.command(
            data=[avrclient.CMD_SET_RUN_MODE] + args, ignore_error=True)
            self.assertEqual(
                rx_bytes,
                bytearray([avrclient.ERROR_BAD_ARGS_LENGTH])
                )

    def test_set_run_mode_returns_error_for_bad_mode(self):
        rx_bytes = self.client.command(
        data=[avrclient.CMD_SET_RUN_MODE, 0xFF], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_VALUE]))

    # Pass Emulated uPD Display to Faceplate command

    def test_auto_display_passthru_nak_bad_args_length(self):
        for args in ([], [0, 0]):
            cmd = avrclient.CMD_SET_AUTO_DISPLAY_PASSTHRU
            rx_bytes = self.client.command(data=[cmd] + args, ignore_error=True)
            self.assertEqual(
                rx_bytes,
                bytearray([avrclient.ERROR_BAD_ARGS_LENGTH])
                )

    def test_auto_display_passthru_nak_bad_arg_value(self):
        cmd = avrclient.CMD_SET_AUTO_DISPLAY_PASSTHRU
        rx_bytes = self.client.command(data=[cmd, 0xFF], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_VALUE]))

    # Pass Faceplate Keys to Emulated uPD command

    def test_auto_key_passthru_nak_bad_args_length(self):
        for args in ([], [0, 0]):
            cmd = avrclient.CMD_SET_AUTO_KEY_PASSTHRU
            rx_bytes = self.client.command(data=[cmd] + args, ignore_error=True)
            self.assertEqual(
                rx_bytes,
                bytearray([avrclient.ERROR_BAD_ARGS_LENGTH])
                )

    def test_auto_key_passthru_nak_bad_arg_value(self):
        cmd = avrclient.CMD_SET_AUTO_KEY_PASSTHRU
        rx_bytes = self.client.command(data=[cmd, 0xFF], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_VALUE]))

    # Set LED command

    def test_high_level_set_led(self):
        for led in (avrclient.LED_GREEN, avrclient.LED_RED):
            for state in (1, 0):
                self.client.set_led(led, state)

    def test_set_led_returns_error_for_bad_args_length(self):
        for args in ([], [1]):
            rx_bytes = self.client.command(
                data=[avrclient.CMD_SET_LED] + args, ignore_error=True)
            self.assertEqual(
                rx_bytes,
                bytearray([avrclient.ERROR_BAD_ARGS_LENGTH])
                )

    def test_set_led_returns_error_for_bad_led(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_SET_LED, 0xFF, 1], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_VALUE]))

    def test_set_led_changes_valid_led(self):
        for led in (avrclient.LED_GREEN, avrclient.LED_RED):
            for state in (1, 0):
                rx_bytes = self.client.command(
                    data=[avrclient.CMD_SET_LED, led, state], ignore_error=True)
                self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK]))

    # Radio State Reset command

    def test_radio_state_reset_returns_error_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_RADIO_STATE_RESET, 1], ignore_error=True)
        self.assertEqual(
            rx_bytes,
            bytearray([avrclient.ERROR_BAD_ARGS_LENGTH])
            )

    # Radio State Dump command

    def test_radio_state_dump_returns_error_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_RADIO_STATE_DUMP, 1], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    # Reset UPD command

    def test_emulated_upd_reset_accepts_no_args(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_RESET, 1], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    # Dump UPD State command

    def test_emulated_upd_dump_state_accepts_no_args(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_DUMP_STATE, 1], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    def test_emulated_upd_dump_state_dumps_serialized_state(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_DUMP_STATE], ignore_error=True)
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 152)

    # Process UPD Command command

    def test_process_upd_cmd_allows_empty_spi_data(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_SEND_COMMAND] + [],
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 1)

    def test_process_upd_cmd_allows_max_spi_data_size_of_32(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_SEND_COMMAND] + ([0] * 32),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 1)

    def test_process_upd_cmd_returns_error_if_spi_data_size_exceeds_32(self):
        self.client.emulated_upd_reset()
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_SEND_COMMAND] + ([0] * 33),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
        self.assertEqual(len(rx_bytes), 1)

    # Load UPD Key Data command

    def test_emulated_upd_load_key_data_nak_if_bad_args(self):
        for bad_args in ([], [1,2,3,4,5]):
            rx_bytes = self.client.command(
                data=[avrclient.CMD_EMULATED_UPD_LOAD_KEY_DATA] + bad_args,
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_emulated_upd_load_key_data_nak_if_key_passthru_is_enabled(self):
        self.client.set_auto_key_passthru(True)
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_LOAD_KEY_DATA, 0, 0, 0, 0],
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BLOCKED_BY_PASSTHRU)
        self.assertEqual(len(rx_bytes), 1)
        self.client.set_auto_key_passthru(False)

    def test_emulated_upd_load_key_data_ack_if_passhthru_disabled(self):
        self.client.set_auto_key_passthru(False)
        rx_bytes = self.client.command(
            data=[avrclient.CMD_EMULATED_UPD_LOAD_KEY_DATA, 0, 0, 0, 0],
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 1)

    # uPD16432B Emulator

    def test_upd_resets_to_known_state(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_NONE) # 0=none
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertFalse(state.increment)
        self.assertEqual(state.display_ram, bytearray(0x19))
        self.assertEqual(state.chargen_ram, bytearray(7 * 0x10))
        self.assertEqual(state.pictograph_ram, bytearray(8))

    # uPD16432B Emulator: Data Setting Command

    def test_upd_data_setting_sets_display_ram_area_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_DISPLAY)
        self.assertEqual(state.ram_size, 25)
        self.assertFalse(state.increment)

    def test_upd_data_setting_sets_display_ram_area_increment_on(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_DISPLAY)
        self.assertEqual(state.ram_size, 25)
        self.assertTrue(state.increment)

    def test_upd_data_setting_sets_pictograph_ram_area_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_PICTOGRAPH)
        self.assertEqual(state.ram_size, 8)
        self.assertFalse(state.increment)

    def test_upd_data_setting_sets_chargen_ram_area_increment_on(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_CHARGEN)
        self.assertEqual(state.ram_size, 112)
        self.assertTrue(state.increment)

    def test_upd_data_setting_sets_chargen_ram_area_ignores_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (should be ignored)
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_CHARGEN)
        self.assertEqual(state.ram_size, 112)
        self.assertTrue(state.increment) # should ignore increment off

    def test_upd_data_setting_sets_led_ram_area_increment_on(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_LED)
        self.assertEqual(state.ram_size, 1)
        self.assertTrue(state.increment)

    def test_upd_data_setting_sets_led_ram_area_ignores_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off (should be ignored)
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_LED)
        self.assertEqual(state.ram_size, 1)
        self.assertTrue(state.increment) # should ignore increment off

    def test_upd_data_setting_unrecognized_ram_area_sets_none(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_NONE)
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertTrue(state.increment)

    def test_upd_data_setting_unrecognized_ram_area_ignores_increment_off(self):
        self.client.emulated_upd_reset()
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        cmd |= 0b00001000 # increment off (should be ignored)
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_NONE)
        self.assertEqual(state.ram_size, 0)
        self.assertEqual(state.address, 0)
        self.assertTrue(state.increment) # should ignore increment off

    # uPD16432B Emulator: Address Setting Command

    def test_upd_address_setting_unrecognized_ram_area_sets_zero(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_NONE)
        cmd  = 0b10000000 # address setting command
        cmd |= 0b00000011 # address 0x03
        self.client.emulated_upd_send_command([cmd])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.address, 0)

    def test_upd_address_setting_sets_addresses_for_each_ram_area(self):
        tuples = (
            (avrclient.UPD_RAM_DISPLAY, 0b00000000, 0,       0), # min
            (avrclient.UPD_RAM_DISPLAY, 0b00000000, 0x18, 0x18), # max
            (avrclient.UPD_RAM_DISPLAY, 0b00000000, 0x19,    0), # out of range

            (avrclient.UPD_RAM_PICTOGRAPH,   0b00000001,    0,    0), # min
            (avrclient.UPD_RAM_PICTOGRAPH,   0b00000001, 0x07, 0x07), # max
            (avrclient.UPD_RAM_PICTOGRAPH,   0b00000001, 0x08,    0), # out of range

            (avrclient.UPD_RAM_CHARGEN,      0b00000010,    0,    0), # min
            (avrclient.UPD_RAM_CHARGEN,      0b00000010, 0x0f, 0x69), # max
            (avrclient.UPD_RAM_CHARGEN,      0b00000010, 0x10,    0), # out of range

            (avrclient.UPD_RAM_LED,          0b00000011,    0,    0), # min
            (avrclient.UPD_RAM_LED,          0b00000011,    0,    0), # max
            (avrclient.UPD_RAM_LED,          0b00000011,    1,    0), # out of range
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

    def test_upd_writing_no_ram_area_ignores_data(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        # address setting command
        # followed by bytes that should be ignored
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 8))
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        self.assertEqual(self.client.emulated_upd_dump_state(), state)

    def test_upd_writing_display_ram_increment_on_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        # followed by a unique byte for all 25 bytes of display ram
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 26))
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_DISPLAY)
        self.assertTrue(state.increment)
        self.assertEqual(state.address, 0) # wrapped around
        self.assertEqual(state.display_ram, data)

    def test_upd_writing_display_ram_increment_off_rewrites_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        cmd = 0b10000000
        cmd |= 5 # address 5
        # address setting command
        # followed by bytes that should be written to address 5 only
        self.client.emulated_upd_send_command([cmd, 1, 2, 3, 4, 5, 6, 7])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_DISPLAY)
        self.assertFalse(state.increment)
        self.assertEqual(state.address, 5)
        self.assertEqual(state.display_ram[5], 7)

    def test_upd_writing_pictograph_ram_increment_on_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        # followed by a unique byte for all 8 bytes of pictograph ram
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 9))
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_PICTOGRAPH)
        self.assertTrue(state.increment)
        self.assertEqual(state.address, 0) # wrapped around
        self.assertEqual(state.pictograph_ram, data)

    def test_upd_writing_pictograph_ram_increment_off_rewrites_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        cmd = 0b10000000
        cmd |= 5 # address 5
        # address setting command
        # followed by bytes that should be written to address 5 only
        self.client.emulated_upd_send_command([cmd, 1, 2, 3, 4, 5, 6, 7])
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_PICTOGRAPH)
        self.assertFalse(state.increment)
        self.assertEqual(state.address, 5)
        self.assertEqual(state.pictograph_ram[5], 7)

    def test_upd_writing_chargen_ram_increment_on_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        # make unique data for every byte of every character
        data = [] # groups of 7 bytes, one for each character
        for charnum in range(16):
            offset = charnum * 7
            data.append(bytearray(range(offset, offset+7)))
        # write character data in groups of 2 characters per command
        for charnum in range(0, 16, 2):
            # address setting command
            cmd = 0b10000000
            cmd |= charnum # address
            self.client.emulated_upd_send_command(
                bytearray([cmd]) + data[charnum] + data[charnum+1]
                )
        # verify all chargen ram data
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_CHARGEN)
        self.assertTrue(state.increment)
        self.assertEqual(state.address, 0) # wrapped around
        flattened_data = bytearray(itertools.chain.from_iterable(data))
        self.assertEqual(state.chargen_ram, flattened_data)

    def test_upd_writing_chargen_ram_ignores_increment_off_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (ignored)
        self.client.emulated_upd_send_command([cmd])
        # make unique data for every byte of every character
        data = [] # groups of 7 bytes, one for each character
        for charnum in range(16):
            offset = charnum * 7
            data.append(bytearray(range(offset, offset+7)))
        # write character data in groups of 2 characters per command
        for charnum in range(0, 16, 2):
            # address setting command
            cmd = 0b10000000
            cmd |= charnum # address
            self.client.emulated_upd_send_command(
                bytearray([cmd]) + data[charnum] + data[charnum+1]
                )
        # verify all chargen ram data
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_CHARGEN)
        self.assertTrue(state.increment) # should ignore increment off
        self.assertEqual(state.address, 0) # wrapped around
        flattened_data = bytearray(itertools.chain.from_iterable(data))
        self.assertEqual(state.chargen_ram, flattened_data)

    def test_upd_writing_led_ram_increment_on_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00000000 # increment on
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        # followed a byte for the led output latch
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray([42])
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_LED)
        self.assertTrue(state.increment)
        self.assertEqual(state.address, 0) # wrapped around
        self.assertEqual(state.led_ram, data)

    def test_upd_writing_led_ram_ignores_increment_off_writes_data(self):
        self.client.emulated_upd_reset()
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off (ignored)
        self.client.emulated_upd_send_command([cmd])
        # address setting command
        # followed a byte for the led output latch
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray([42])
        self.client.emulated_upd_send_command(bytearray([cmd]) + data)
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.ram_area, avrclient.UPD_RAM_LED)
        self.assertTrue(state.increment) # should ignore increment off
        self.assertEqual(state.address, 0) # wrapped around
        self.assertEqual(state.led_ram, data)

    # uPD16432B Emulator: Dirty RAM Tracking

    def test_upd_writing_display_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_DISPLAY, 0)
        self.assertEqual(state.display_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 0])
        # dirty flag should still be false
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_DISPLAY, 0)

    def test_upd_writing_display_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_DISPLAY, 0)
        self.assertEqual(state.display_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 1])
        # dirty flag should be true
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.display_ram[0], 1)
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_DISPLAY,
            avrclient.UPD_DIRTY_DISPLAY)

    def test_upd_writing_pictograph_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_PICTOGRAPH, 0)
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
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_PICTOGRAPH, 0)

    def test_upd_writing_pictograph_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_PICTOGRAPH, 0)
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
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_PICTOGRAPH,
            avrclient.UPD_DIRTY_PICTOGRAPH)

    def test_upd_writing_chargen_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_CHARGEN, 0)
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
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_CHARGEN, 0)

    def test_upd_writing_chargen_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_CHARGEN, 0)
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
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_CHARGEN,
            avrclient.UPD_DIRTY_CHARGEN)

    def test_upd_writing_led_ram_same_value_doesnt_set_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_LED, 0)
        self.assertEqual(state.led_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 0])
        # dirty flag should still be false
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_LED, 0)

    def test_upd_writing_led_ram_new_value_sets_dirty(self):
        self.client.emulated_upd_reset()
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_LED, 0)
        self.assertEqual(state.led_ram[0], 0)
        # send data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off
        self.client.emulated_upd_send_command([cmd])
        # send address setting command followed by same value
        cmd = 0b10000000
        cmd |= 0 # address 0
        self.client.emulated_upd_send_command([cmd, 1])
        # dirty flag should be true
        state = self.client.emulated_upd_dump_state()
        self.assertEqual(state.led_ram[0], 1)
        self.assertEqual(state.dirty_flags & avrclient.UPD_DIRTY_LED,
            avrclient.UPD_DIRTY_LED)

    # Faceplate

    def test_faceplate_upd_clear_display_returns_error_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_FACEPLATE_UPD_CLEAR_DISPLAY, 1],
            ignore_error=True
            )
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    def test_faceplate_clear_display(self):
        self.client.faceplate_upd_clear_display() # shouldn't raise

    def test_faceplate_upd_send_command_allows_max_spi_data_size_of_32(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_FACEPLATE_UPD_SEND_COMMAND] + [0x80] + ([0] * 31),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 1)

    def test_faceplate_upd_send_command_nak_if_spi_data_size_exceeds_32(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_FACEPLATE_UPD_SEND_COMMAND] + ([0] * 33),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
        self.assertEqual(len(rx_bytes), 1)

    def test_faceplate_upd_send_command(self):
        # Data Setting command: write to display ram
        data = [0x40]
        self.client.faceplate_upd_send_command(data) # shouldn't raise
        # Address Setting command + display data
        data = [0x80, 0, 0, 0x6f, 0x6c, 0x6c, 0x65, 0x48]
        self.client.faceplate_upd_send_command(data) # shouldn't raise

    def test_faceplate_upd_read_key_data_returns_error_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_FACEPLATE_UPD_READ_KEY_DATA, 1],
            ignore_error=True
            )
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    def test_faceplate_upd_read_key_data_returns_4_bytes(self):
        data = self.client.faceplate_upd_read_key_data()
        self.assertEqual(len(data), 4)

    def test_faceplate_upd_dump_state_accepts_no_args(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_FACEPLATE_UPD_DUMP_STATE, 1], ignore_error=True)
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_BAD_ARGS_LENGTH]))

    # TODO more tests for faceplate_upd_dump_state

    # Radio State

    def test_radio_state_returns_error_for_too_few_display_data_bytes(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_RADIO_STATE_PARSE] + ([0] * 10),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
        self.assertEqual(len(rx_bytes), 1)

    def test_radio_state_returns_error_for_too_many_display_data_bytes(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_RADIO_STATE_PARSE] + ([0] * 33),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
        self.assertEqual(len(rx_bytes), 1)

    def test_radio_state_safe_mode(self):
        values = (
            # Premium 4
            (b"     0000  ",    0, 0, OperationModes.SAFE_ENTRY),
            (b"1    1234  ", 1234, 1, OperationModes.SAFE_ENTRY),
            (b"2    5678  ", 5678, 2, OperationModes.SAFE_ENTRY),
            (b"9    9999  ", 9999, 9, OperationModes.SAFE_ENTRY),
            (b"    NO CODE",    0, 0, OperationModes.SAFE_NO_CODE),
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
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.safe_code, safe_code)
            self.assertEqual(state.safe_tries, safe_tries)
            self.assertEqual(state.operation_mode, mode)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_initial(self):
        self.client.radio_state_reset()
        # set up known values
        self.client.radio_state_parse(b"FM161079MHZ")
        self.client.radio_state_parse(b"FM1   MIN  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.ADJUSTING_SOUND_VOLUME)
        # parse display
        self.client.radio_state_parse(b"    INITIAL")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.INITIALIZING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_monsoon_premium_5(self):
        self.client.radio_state_reset()
        # set up known values
        self.client.radio_state_parse(b"FM161079MHZ")
        self.client.radio_state_parse(b"FM1   MIN  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.ADJUSTING_SOUND_VOLUME)
        # parse display
        self.client.radio_state_parse(b"    MONSOON")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.MONSOON)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_diag(self):
        self.client.radio_state_reset()
        # set up known values
        self.client.radio_state_parse(b"FM161079MHZ")
        self.client.radio_state_parse(b"FM1   MIN  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.ADJUSTING_SOUND_VOLUME)
        # parse display
        self.client.radio_state_parse(b"     DIAG  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.DIAGNOSTICS)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_sound_volume(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)

    def test_radio_state_sound_balance(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_BALANCE)
            self.assertEqual(state.sound_balance, balance)

    def test_radio_state_sound_fade(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_FADE)
            self.assertEqual(state.sound_fade, fade)

    def test_radio_state_sound_bass(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_BASS)
            self.assertEqual(state.sound_bass, bass)

    def test_radio_state_sound_treble(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_TREBLE)
            self.assertEqual(state.sound_treble, treble)

    def test_radio_state_sound_midrange_premium_5(self):
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
            self.client.radio_state_parse(b"FM161079MHZ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_MIDRANGE)
            self.assertEqual(state.sound_midrange, mid)

    def test_radio_state_set_option_on_vol(self):
        values = (
            (b"SET ONVOL 0", 0),
            (b"SET ONVOL 1", 1),
            (b"SET ONVOL02", 2),
            (b"SET ONVOL13", 13),
            (b"SET ONVOL63", 63),
            (b"SET ONVOL99", 99),
        )
        for display, on_vol in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.option_on_vol, on_vol)
            self.assertEqual(state.operation_mode,
                OperationModes.SETTING_ON_VOL)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_set_option_cd_mix(self):
        values = (
            (b"SET CD MIX1", 1),
            (b"SET CD MIX6", 6),
        )
        for display, cd_mix in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.option_cd_mix, cd_mix)
            self.assertEqual(state.operation_mode,
                OperationModes.SETTING_CD_MIX)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_set_option_tape_skip(self):
        values = (
            (b"TAPE SKIP N", 0),
            (b"TAPE SKIP Y", 1),
        )
        for display, tape_skip in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.option_tape_skip, tape_skip)
            self.assertEqual(state.operation_mode,
                OperationModes.SETTING_TAPE_SKIP)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_fern(self):
        values = (
            (b"FERN   OFF ", 0),
            (b"FERN   ON  ", 1),
        )
        for display, fern in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.test_fern, fern)
            self.assertEqual(state.operation_mode,
                OperationModes.TESTING_FERN)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_rad(self):
        values = (
            (b"RAD 3CP T7 ", b"3CP T7 "), # Premium 4
            (b"RAD   DE2  ", b"  DE2  "), # Premium 5
            (b"RAD 0123456", b"0123456"),
        )
        for display, rad in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.test_rad, rad)
            self.assertEqual(state.operation_mode,
                OperationModes.TESTING_RAD)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_ver(self):
        values = (
            (b"VER  0702  ", b" 0702  "), # Premium 4
            (b"VersA99CZ23", b"A99CZ23"), # Premium 5
            (b"VER ABCDEFG", b"ABCDEFG"),
        )
        for display, ver in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.test_ver, ver)
            self.assertEqual(state.operation_mode,
                OperationModes.TESTING_VER)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_test_signal_premium5(self):
        values = (
            (b" 5300 2 6 F",  530, 0x026F), # AM 530 KHz
            (b"17100 1 2 3", 1710, 0x0123), # AM 1710 KHz
            (b" 8770 5 3 0",  877, 0x0530), # FM 87.7 MHz
            (b"10770 6 4 0", 1077, 0x0640), # FM 107.7 MHz
            (b"1077A B C D", 1077, 0xABCD),
            (b"1077E F 1 2", 1077, 0xEF12),
            (b"10770 0 0 0", 1077, 0x0000),
            (b"1077F F F F", 1077, 0xFFFF),
        )
        for display, freq, strength in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"FM161079MHZ")
            self.client.radio_state_parse(b"FM1   MIN  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.ADJUSTING_SOUND_VOLUME)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.test_signal_freq, freq)
            self.assertEqual(state.test_signal_strength, strength)
            self.assertEqual(state.operation_mode,
                OperationModes.TESTING_SIGNAL)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_playing(self):
        values = (
            (b"CD 1 TR 01 ", 1, 1),
            (b"CD 6 TR 99 ", 6, 99),
        )
        for display, disc, track in values:
            self.client.radio_state_reset()
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, disc)
            self.assertEqual(state.cd_track, track)
            self.assertEqual(state.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_cue_rev_pos(self):
        values = (
            (b"CUE   000  ", OperationModes.CD_CUE, 5, (0*60)+0),
            (b"CUE   001  ", OperationModes.CD_CUE, 5, (0*60)+1),
            (b"CUE   012  ", OperationModes.CD_CUE, 5, (0*60)+12),
            (b"CUE   123  ", OperationModes.CD_CUE, 5, (1*60)+23),
            (b"CUE  1234  ", OperationModes.CD_CUE, 5, (12*60)+34),
            (b"CUE  9999  ", OperationModes.CD_CUE, 5, (99*60)+99),
            (b"CUE  -002  ", OperationModes.CD_CUE, 5, 0),
            (b"CUE -1234  ", OperationModes.CD_CUE, 5, 0),

            (b"REV   000  ", OperationModes.CD_REV, 5, (0*60)+0),
            (b"REV   001  ", OperationModes.CD_REV, 5, (0*60)+1),
            (b"REV   012  ", OperationModes.CD_REV, 5, (0*60)+12),
            (b"REV   123  ", OperationModes.CD_REV, 5, (1*60)+23),
            (b"REV  1234  ", OperationModes.CD_REV, 5, (12*60)+34),
            (b"REV  9999  ", OperationModes.CD_REV, 5, (99*60)+99),
            (b"REV  -002  ", OperationModes.CD_REV, 5, 0),
            (b"REV -1234  ", OperationModes.CD_REV, 5, 0),

            (b"CD 2  000  ", OperationModes.CD_PLAYING, 2, (0*60)+0),
            (b"CD 2  001  ", OperationModes.CD_PLAYING, 2, (0*60)+1),
            (b"CD 2  012  ", OperationModes.CD_PLAYING, 2, (0*60)+12),
            (b"CD 2  123  ", OperationModes.CD_PLAYING, 2, (1*60)+23),
            (b"CD 2 1234  ", OperationModes.CD_PLAYING, 2, (12*60)+34),
            (b"CD 2 9999  ", OperationModes.CD_PLAYING, 2, (99*60)+99),
            (b"CD 2 -002  ", OperationModes.CD_PLAYING, 2, 0),
            (b"CD 2-1234  ", OperationModes.CD_PLAYING, 2, 0),
        )
        for display, operation_mode, cd_disc, cd_track_pos in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"CD 5 TR 12 ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, 5)
            self.assertEqual(state.cd_track, 12)
            self.assertEqual(state.operation_mode,
                OperationModes.CD_PLAYING)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, cd_disc)
            self.assertEqual(state.cd_track, 12)
            self.assertEqual(state.cd_track_pos, cd_track_pos)
            self.assertEqual(state.operation_mode,
                operation_mode)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_cd_scanning(self):
        values = (
            (b"SCANCD1TR04", 1, 4),
            (b"SCANCD3TR15", 3, 15),
        )
        for display, disc, track in values:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"CD 5 TR 12 ")
            self.client.radio_state_parse(b"CD 5  042  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(state.cd_disc, 5)
            self.assertEqual(state.cd_track, 12)
            self.assertEqual(state.cd_track_pos, 42)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, disc)
            self.assertEqual(state.cd_track, track)
            self.assertEqual(state.cd_track_pos, 0)
            self.assertEqual(state.operation_mode,
                OperationModes.CD_SCANNING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_check_magazine(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"CD 1 TR 03 ")
        self.client.radio_state_parse(b"CD 1  139  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 1)
        self.assertEqual(state.cd_track, 3)
        self.assertEqual(state.cd_track_pos, 99)
        # parse display
        self.client.radio_state_parse(b"CHK MAGAZIN")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_track_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CHECK_MAGAZINE)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_cdx_no_cd(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"CD 1 TR 03 ")
        self.client.radio_state_parse(b"CD 1  139  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 1)
        self.assertEqual(state.cd_track, 3)
        self.assertEqual(state.cd_track_pos, 99)
        # parse display
        self.client.radio_state_parse(b"CD 2 NO CD ") # space in "CD 2"
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 2)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_track_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_CDX_NO_CD)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_cdx_cd_err(self):
        displays = (
            b"CD1 CD ERR ", # Premium 4
            b"CD 1CD ERR ", # Premium 5
        )
        for display in displays:
            # set up known values
            self.client.radio_state_reset()
            self.client.radio_state_parse(b"CD 5 TR 03 ")
            self.client.radio_state_parse(b"CD 5  139  ")
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.CD_PLAYING)
            self.assertEqual(state.cd_disc, 5)
            self.assertEqual(state.cd_track, 3)
            self.assertEqual(state.cd_track_pos, 99)
            # parse display
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.cd_disc, 1)
            self.assertEqual(state.cd_track, 0)
            self.assertEqual(state.cd_track_pos, 0)
            self.assertEqual(state.operation_mode,
                OperationModes.CD_CDX_CD_ERR)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_no_disc(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"CD 5 TR 03 ")
        self.client.radio_state_parse(b"CD 5  139  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 3)
        self.assertEqual(state.cd_track_pos, 99)
        # parse display
        self.client.radio_state_parse(b"    NO DISC")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_track_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_NO_DISC)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_cd_no_changer(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"CD 5 TR 03 ")
        self.client.radio_state_parse(b"CD 5  139  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.CD_PLAYING)
        self.assertEqual(state.cd_disc, 5)
        self.assertEqual(state.cd_track, 3)
        self.assertEqual(state.cd_track_pos, 99)
        # process
        self.client.radio_state_parse(b"NO  CHANGER")
        state = self.client.radio_state_dump()
        self.assertEqual(state.cd_disc, 0)
        self.assertEqual(state.cd_track, 0)
        self.assertEqual(state.cd_track_pos, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.CD_NO_CHANGER)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_load_premium_5(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # parse display
        self.client.radio_state_parse(b"TAPE LOAD  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_LOAD)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_metal_premium_5(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE METAL ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_METAL)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_tape_bls(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE  BLS  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_BLS)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_play_a(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY B")
        self.client.radio_state_parse(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_play_b(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        self.client.radio_state_parse(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_scan_a(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY B")
        self.client.radio_state_parse(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE SCAN A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_SCANNING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_scan_b(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        self.client.radio_state_parse(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        # parse display
        self.client.radio_state_parse(b"TAPE SCAN B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_SCANNING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_ff(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # parse display
        self.client.radio_state_parse(b"TAPE  FF   ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_FF)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_mss_ff(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        # parse display
        self.client.radio_state_parse(b"TAPEMSS FF ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_MSS_FF)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_rew(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # parse display
        self.client.radio_state_parse(b"TAPE  REW  ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_REW)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_mss_rew(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY B")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        # parse display
        self.client.radio_state_parse(b"TAPEMSS REW")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 2)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_MSS_REW)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_error(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # parse display
        self.client.radio_state_parse(b"TAPE ERROR ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 0)
        self.assertEqual(state.operation_mode,
            OperationModes.TAPE_ERROR)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)

    def test_radio_state_tape_no_tape(self):
        # set up known values
        self.client.radio_state_reset()
        self.client.radio_state_parse(b"TAPE PLAY A")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tape_side, 1)
        # parse display
        self.client.radio_state_parse(b"    NO TAPE")
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
            self.client.radio_state_parse(display)
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
        self.client.radio_state_parse(b"FM11 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_band, TunerBands.FM1)
        self.assertEqual(state.tuner_preset, 1)
        # parse display
        self.client.radio_state_parse(b"SCAN 879MHZ")
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
        self.client.radio_state_parse(b"FM21 915MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.tuner_band, TunerBands.FM2)
        self.assertEqual(state.tuner_preset, 1)
        # parse display
        self.client.radio_state_parse(b"SCAN 879MHZ")
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
        # parse display
        self.client.radio_state_parse(b"SCAN 879MHZ")
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
            self.client.radio_state_parse(display)
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
            self.client.radio_state_parse(display)
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
        # set up known values
        self.client.radio_state_parse(b"FM161079MHZ")
        state = self.client.radio_state_dump()
        self.assertEqual(state.operation_mode,
            OperationModes.TUNER_PLAYING)
        self.assertEqual(state.display_mode,
            DisplayModes.SHOWING_OPERATION)
        # blank displays should not change the state
        for display in (b'\x00'*11, b' '*11):
            self.client.radio_state_parse(display)
            state = self.client.radio_state_dump()
            self.assertEqual(state.operation_mode,
                OperationModes.TUNER_PLAYING)
            self.assertEqual(state.display_mode,
                DisplayModes.SHOWING_OPERATION)

    # Converting uPD16432B key data to key codes

    def test_convert_upd_key_data_to_codes_returns_error_for_bad_args_len(self):
        for bad_args in ([], [1,2,3,4,5]):
            cmd = avrclient.CMD_CONVERT_UPD_KEY_DATA_TO_CODES
            rx_bytes = self.client.command(
                data=[cmd] + bad_args,
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_upd_key_data_to_codes_returns_empty_for_no_keys(self):
        key_data = [0, 0, 0, 0]
        key_codes = self.client.convert_upd_key_data_to_codes(key_data)
        self.assertEqual(len(key_codes), 0)

    def test_convert_upd_key_data_to_codes_decodes_all_premium4_keys(self):
        for bytenum_bitnum, key_code in Premium4.KEYS.items():
            bytenum, bitnum = bytenum_bitnum
            key_data = [0, 0, 0, 0]
            key_data[bytenum] |= 1<<bitnum
            key_codes = self.client.convert_upd_key_data_to_codes(key_data)
            self.assertEqual(key_codes, [key_code])

    def test_convert_upd_key_data_to_codes_decodes_2_premium4_keys(self):
        key_data = [0, 3, 0, 0]
        key_codes = self.client.convert_upd_key_data_to_codes(key_data)
        self.assertEqual(
            sorted(key_codes),
            sorted([Keys.TUNE_DOWN, Keys.SOUND_FADE])
            )

    def test_convert_upd_key_data_returns_at_most_2_keys(self):
        key_data = [0xff, 0xff, 0xff, 0xff]
        key_codes = self.client.convert_upd_key_data_to_codes(key_data)
        self.assertEqual(len(key_codes), 2)

    # Converting a key code to uPD16432B key data

    def test_convert_code_to_upd_key_data_returns_error_for_bad_args_length(self):
        for bad_args in ([], [1,2,]):
            cmd = avrclient.CMD_CONVERT_CODE_TO_UPD_KEY_DATA
            rx_bytes = self.client.command(
                data=[cmd] + bad_args,
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_code_to_upd_key_data_returns_error_for_bad_key_codes(self):
        for bad_code in ([0, 0xFF]):
            cmd = avrclient.CMD_CONVERT_CODE_TO_UPD_KEY_DATA
            rx_bytes = self.client.command(
                data=[cmd, bad_code],
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_VALUE)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_code_to_upd_key_data_encodes_all_premium4_keys(self):
        for bytenum_bitnum, key_code in Premium4.KEYS.items():
            bytenum, bitnum = bytenum_bitnum
            expected_key_data = [0, 0, 0, 0]
            expected_key_data[bytenum] |= 1<<bitnum
            key_data = self.client.convert_code_to_upd_key_data(key_code)
            self.assertEqual(key_data, expected_key_data)

    # Converting uPD16432B pictograph data to pictograph codes

    def test_convert_upd_pictograph_data_to_codes_returns_error_for_bad_args_len(self):
        for bad_args in ([], [1,2,3,4,5,6,7,8,9]):
            cmd = avrclient.CMD_CONVERT_UPD_PICTOGRAPH_DATA_TO_CODES
            rx_bytes = self.client.command(
                data=[cmd] + bad_args,
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_upd_pictograph_data_to_codes_returns_empty_for_no_pictographs(self):
        pictograph_data = [0, 0, 0, 0, 0, 0, 0, 0]
        pictograph_codes = self.client.convert_upd_pictograph_data_to_codes(pictograph_data)
        self.assertEqual(len(pictograph_codes), 0)

    def test_convert_upd_pictograph_data_to_codes_decodes_all_premium4_pictographs(self):
        for bytenum_bitnum, pictograph_code in Premium4.PICTOGRAPHS.items():
            bytenum, bitnum = bytenum_bitnum
            pictograph_data = [0, 0, 0, 0, 0, 0, 0, 0]
            pictograph_data[bytenum] |= 1<<bitnum
            pictograph_codes = self.client.convert_upd_pictograph_data_to_codes(pictograph_data)
            self.assertEqual(pictograph_codes, [pictograph_code])

    def test_convert_upd_pictograph_data_to_codes_decodes_7_premium4_pictographs(self):
        pictograph_data = [0, 33, 8, 64, 0, 0, 33, 8]
        pictograph_codes = self.client.convert_upd_pictograph_data_to_codes(pictograph_data)
        expected_codes = [
            Pictographs.PERIOD,
            Pictographs.MIX,
            Pictographs.TAPE_METAL,
            Pictographs.TAPE_DOLBY,
            Pictographs.HIDDEN_MODE_AMFM,
            Pictographs.HIDDEN_MODE_CD,
            Pictographs.HIDDEN_MODE_TAPE,
            ]
        self.assertEqual(
            sorted(pictograph_codes),
            sorted(expected_codes)
            )

    def test_convert_upd_key_data_returns_at_most_7_pictographs(self):
        pictograph_data = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
        pictograph_codes = self.client.convert_upd_pictograph_data_to_codes(pictograph_data)
        self.assertEqual(len(pictograph_codes), 7)

    # Converting a pictograph code to uPD16432B pictograph data

    def test_convert_code_to_upd_pictograph_data_returns_error_for_bad_args_length(self):
        for bad_args in ([], [1,2,]):
            cmd = avrclient.CMD_CONVERT_CODE_TO_UPD_PICTOGRAPH_DATA
            rx_bytes = self.client.command(
                data=[cmd] + bad_args,
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_code_to_upd_pictograph_data_returns_error_for_bad_pictograph_codes(self):
        for bad_code in ([0, 0xFF]):
            cmd = avrclient.CMD_CONVERT_CODE_TO_UPD_PICTOGRAPH_DATA
            rx_bytes = self.client.command(
                data=[cmd, bad_code],
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_VALUE)
            self.assertEqual(len(rx_bytes), 1)

    def test_convert_code_to_upd_pictograph_data_encodes_all_premium4_keys(self):
        for bytenum_bitnum, pictograph_code in Premium4.PICTOGRAPHS.items():
            bytenum, bitnum = bytenum_bitnum
            expected_pictograph_data = [0, 0, 0, 0, 0, 0, 0, 0]
            expected_pictograph_data[bytenum] |= 1<<bitnum
            key_data = self.client.convert_code_to_upd_pictograph_data(pictograph_code)
            self.assertEqual(key_data, expected_pictograph_data)

    # Read Keys command

    def test_read_keys_returns_error_for_bad_args_length(self):
        rx_bytes = self.client.command(
            data=[avrclient.CMD_READ_KEYS, 1],
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
        self.assertEqual(len(rx_bytes), 1)

    # TODO fix test that fails without radio connected
    def _dont_test_read_keys_returns_zeros_for_no_keys(self):
        # assumes no keys are being pressed on the faceplate
        rx_bytes = self.client.command([avrclient.CMD_READ_KEYS])
        self.assertEqual(rx_bytes, bytearray([avrclient.ERROR_OK, 0, 0, 0]))

    # TODO fix test that fails without radio connected
    def _dont_test_high_level_read_keys_returns_empty_list_for_no_keys(self):
        # assumes no keys are being pressed on the faceplate
        self.assertEqual(self.client.read_keys(), [])

    # Load Keys command

    def test_load_keys_returns_error_for_bad_args_length(self):
        for bad_args in ([], [1,2,3,4,]):
            rx_bytes = self.client.command(
                data=bytearray([avrclient.CMD_LOAD_KEYS] + bad_args),
                ignore_error=True
                )
            self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_LENGTH)
            self.assertEqual(len(rx_bytes), 1)

    def test_load_keys_returns_error_if_key_passthru_enabled(self):
        self.client.set_auto_key_passthru(True)
        rx_bytes = self.client.command(
            data=bytearray([avrclient.CMD_LOAD_KEYS, 1, 0, 0]),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BLOCKED_BY_PASSTHRU)
        self.assertEqual(len(rx_bytes), 1)
        self.client.set_auto_key_passthru(False)

    def test_load_keys_returns_error_if_key_count_greater_than_2(self):
        rx_bytes = self.client.command(
            data=bytearray([avrclient.CMD_LOAD_KEYS, 3, 0, 0]),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_VALUE)
        self.assertEqual(len(rx_bytes), 1)

    def test_load_keys_returns_error_for_bad_key_code(self):
        rx_bytes = self.client.command(
            data=bytearray([avrclient.CMD_LOAD_KEYS, 1, 0xFF, 0]),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_BAD_ARGS_VALUE)
        self.assertEqual(len(rx_bytes), 1)

    def test_load_keys_loads_empty(self):
        rx_bytes = self.client.command(
            data=bytearray([avrclient.CMD_LOAD_KEYS, 0, 0, 0]),
            ignore_error=True
            )
        self.assertEqual(rx_bytes[0], avrclient.ERROR_OK)
        self.assertEqual(len(rx_bytes), 1)
