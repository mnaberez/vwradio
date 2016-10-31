import itertools
import unittest
try:
    from StringIO import StringIO
except ImportError: # python 3
    from io import StringIO
from vwradio.decode import Upd16432b

class TestUpd16432b(unittest.TestCase):
    def test_ctor_initializes_ram_areas(self):
        emu = Upd16432b(stdout=StringIO())
        names_and_sizes = (
            ('display_ram', 0x19),
            ('pictograph_ram', 0x08),
            ('chargen_ram', 0x70),
            ('led_ram', 0x01),
            ('key_data_ram', 0x04),
        )
        for name, size in names_and_sizes:
            ram = getattr(emu, name)
            self.assertEqual(ram, bytearray(size))

    def test_ctor_initializes_ram_pointers(self):
        emu = Upd16432b(stdout=StringIO())
        self.assertTrue(emu.current_ram is None)
        self.assertEqual(emu.address, 0)
        self.assertFalse(emu.increment)

    def test_process_ignores_empty_spi_command(self):
        emu = Upd16432b(stdout=StringIO())
        emu.process([]) # should not raise

    # Data Setting Command

    def test_upd_data_setting_sets_display_ram_area_increment_off(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.display_ram)
        self.assertFalse(emu.increment)

    def test_upd_data_setting_sets_display_ram_area_increment_on(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.display_ram)
        self.assertTrue(emu.increment)

    def test_upd_data_setting_sets_pictograph_ram_area_increment_off(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.pictograph_ram)
        self.assertFalse(emu.increment)

    def test_upd_data_setting_sets_chargen_ram_area_increment_on(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.chargen_ram)
        self.assertTrue(emu.increment)

    def test_upd_data_setting_sets_chargen_ram_area_ignores_increment_off(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (should be ignored)
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.chargen_ram)
        self.assertTrue(emu.increment) # should ignore increment off

    def test_upd_data_setting_sets_led_ram_area_increment_on(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.led_ram)
        self.assertTrue(emu.increment)

    def test_upd_data_setting_sets_led_ram_area_ignores_increment_off(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off (should be ignored)
        emu.process([cmd])
        self.assertTrue(emu.current_ram is emu.led_ram)
        self.assertTrue(emu.increment) # should ignore increment off

    def test_upd_data_setting_unrecognized_ram_area_sets_none(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        emu.process([cmd])
        self.assertTrue(emu.current_ram is None)
        self.assertEqual(emu.address, 0)
        self.assertEqual(emu.increment, True)

    def test_upd_data_setting_unrecognized_ram_area_ignores_increment_off(self):
        emu = Upd16432b(stdout=StringIO())
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000111 # not a valid ram area
        cmd |= 0b00001000 # increment off (should be ignored)
        emu.process([cmd])
        self.assertTrue(emu.current_ram is None)
        self.assertEqual(emu.address, 0)
        self.assertTrue(emu.increment) # should ignore increment off

    # Address Setting Command

    def test_upd_address_setting_unrecognized_ram_area_sets_zero(self):
        emu = Upd16432b(stdout=StringIO())
        self.assertTrue(emu.current_ram is None)
        cmd  = 0b10000000 # address setting command
        cmd |= 0b00000011 # address 0x03
        emu.process([cmd])
        self.assertEqual(emu.address, 0)

    def test_upd_address_setting_sets_addresses_for_each_ram_area(self):
        tuples = (
            ('display_ram',     0b00000000, 0,       0), # min
            ('display_ram',     0b00000000, 0x18, 0x18), # max
            ('display_ram',     0b00000000, 0x19,    0), # out of range

            ('pictograph_ram',  0b00000001,    0,    0), # min
            ('pictograph_ram',  0b00000001, 0x07, 0x07), # max
            ('pictograph_ram',  0b00000001, 0x08,    0), # out of range

            ('chargen_ram',     0b00000010,    0,    0), # min
            ('chargen_ram',     0b00000010, 0x0f, 0x69), # max
            ('chargen_ram',     0b00000010, 0x10,    0), # out of range

            ('led_ram',         0b00000011,    0,    0), # min
            ('led_ram',         0b00000011,    0,    0), # max
            ('led_ram',         0b00000011,    1,    0), # out of range
        )
        for ram_area, ram_select_bits, address, expected_address in tuples:
            emu = Upd16432b(stdout=StringIO())
            # data setting command
            cmd  = 0b01000000 # data setting command
            cmd |= ram_select_bits
            emu.process([cmd])
            self.assertTrue(emu.current_ram is getattr(emu, ram_area))
            # address setting command
            cmd = 0b10000000
            cmd |= address
            emu.process([cmd])
            # address should be as expected
            self.assertEqual(emu.address, expected_address)

    # Writing Data

    def test_upd_writing_no_ram_area_ignores_data(self):
        emu = Upd16432b(stdout=StringIO())
        old_ram = emu.dump_ram()
        # address setting command
        # followed by bytes that should be ignored
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 8))
        emu.process(bytearray([cmd]) + data)
        self.assertEqual(emu.dump_ram(), old_ram)

    def test_upd_writing_display_ram_increment_on_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        # address setting command
        # followed by a unique byte for all 25 bytes of display ram
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 26))
        emu.process(bytearray([cmd]) + data)
        self.assertTrue(emu.current_ram is emu.display_ram)
        self.assertEqual(emu.increment, True)
        self.assertEqual(emu.address, 0) # wrapped around
        self.assertEqual(emu.display_ram, data)

    def test_upd_writing_display_ram_increment_off_rewrites_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000000 # display ram
        cmd |= 0b00001000 # increment off
        emu.process([cmd])
        # address setting command
        cmd = 0b10000000
        cmd |= 5 # address 5
        # address setting command
        # followed by bytes that should be written to address 5 only
        emu.process([cmd, 1, 2, 3, 4, 5, 6, 7])
        self.assertTrue(emu.current_ram is emu.display_ram)
        self.assertEqual(emu.increment, False)
        self.assertEqual(emu.address, 5)
        self.assertEqual(emu.display_ram[5], 7)

    def test_upd_writing_pictograph_ram_increment_on_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        # address setting command
        # followed by a unique byte for all 8 bytes of pictograph ram
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray(range(1, 9))
        emu.process(bytearray([cmd]) + data)
        self.assertTrue(emu.current_ram is emu.pictograph_ram)
        self.assertEqual(emu.increment, True)
        self.assertEqual(emu.address, 0) # wrapped around
        self.assertEqual(emu.pictograph_ram, data)

    def test_upd_writing_pictograph_ram_increment_off_rewrites_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000001 # pictograph ram
        cmd |= 0b00001000 # increment off
        emu.process([cmd])
        # address setting command
        cmd = 0b10000000
        cmd |= 5 # address 5
        # address setting command
        # followed by bytes that should be written to address 5 only
        emu.process([cmd, 1, 2, 3, 4, 5, 6, 7])
        self.assertTrue(emu.current_ram is emu.pictograph_ram)
        self.assertEqual(emu.increment, False)
        self.assertEqual(emu.address, 5)
        self.assertEqual(emu.pictograph_ram[5], 7)

    def test_upd_writing_chargen_ram_increment_on_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
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
            emu.process(
                bytearray([cmd]) + data[charnum] + data[charnum+1]
                )
        # verify all chargen ram data
        self.assertTrue(emu.current_ram is emu.chargen_ram)
        self.assertTrue(emu.increment)
        self.assertEqual(emu.address, 0) # wrapped around
        flattened_data = bytearray(itertools.chain.from_iterable(data))
        self.assertEqual(emu.chargen_ram, flattened_data)

    def test_upd_writing_chargen_ram_ignores_increment_off_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000010 # chargen ram
        cmd |= 0b00001000 # increment off (ignored)
        emu.process([cmd])
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
            emu.process(
                bytearray([cmd]) + data[charnum] + data[charnum+1]
                )
        # verify all chargen ram data
        self.assertTrue(emu.current_ram is emu.chargen_ram)
        self.assertTrue(emu.increment) # should ignore increment off
        self.assertEqual(emu.address, 0) # wrapped around
        flattened_data = bytearray(itertools.chain.from_iterable(data))
        self.assertEqual(emu.chargen_ram, flattened_data)

    def test_upd_writing_led_ram_increment_on_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00000000 # increment on
        emu.process([cmd])
        # address setting command
        # followed a byte for the led output latch
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray([42])
        emu.process(bytearray([cmd]) + data)
        self.assertTrue(emu.current_ram is emu.led_ram)
        self.assertEqual(emu.increment, True)
        self.assertEqual(emu.address, 0) # wrapped around
        self.assertEqual(emu.led_ram, data)

    def test_upd_writing_led_ram_ignores_increment_off_writes_data(self):
        emu = Upd16432b(stdout=StringIO())
        # data setting command
        cmd  = 0b01000000 # data setting command
        cmd |= 0b00000011 # led output latch
        cmd |= 0b00001000 # increment off (ignored)
        emu.process([cmd])
        # address setting command
        # followed a byte for the led output latch
        cmd = 0b10000000
        cmd |= 0 # address 0
        data = bytearray([42])
        emu.process(bytearray([cmd]) + data)
        self.assertTrue(emu.current_ram is emu.led_ram)
        self.assertEqual(emu.increment, True) # should ignore increment off
        self.assertEqual(emu.address, 0) # wrapped around
        self.assertEqual(emu.led_ram, data)

