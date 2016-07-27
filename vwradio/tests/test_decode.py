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
