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
            ('led_output_ram', 0x01),
            ('key_data_ram', 0x04),
        )
        for name, size in names_and_sizes:
            ram = getattr(emu, name)
            self.assertEqual(ram, [0] * size)

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

    def test_upd_upd_data_setting_sets_chargen_ram_area_increment_on(self):
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
        self.assertTrue(emu.increment)

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
        self.assertEqual(emu.increment, True)

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
