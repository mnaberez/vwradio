import unittest
try:
    from StringIO import StringIO
except ImportError: # python 3
    from io import StringIO
from vwradio.decode import Upd16432b

class TestUpd16432b(unittest.TestCase):
    def test_process_ignores_empty_spi_command(self):
        emu = Upd16432b(stdout=StringIO())
        emu.process([]) # should not raise
