# -*- coding: utf-8 -*-

import re
import unittest
from vwradio import charsets

class _TestCharsetMixin():
    def test_text_has_correct_offset_labels(self):
        matches = re.findall('0x..:', self.TEXT)
        for i in range(256):
            self.assertEqual(matches[i], '0x%02X:' % i)
        self.assertEqual(len(matches), 256)

    def test_text_patterns_have_expected_format(self):
        lines = [ l for l in self.TEXT.splitlines() if (u'·' or u'▊') in l ]
        for line in lines:
            groups = line.split()
            self.assertEqual(len(groups), 8)
            for charline in groups:
                subbed = re.sub(u'[^\·▊]', '', charline)
                self.assertEqual(subbed, charline)
                self.assertEqual(len(charline), 5)
        self.assertEqual(len(lines), (256 * 7) // 8)

    def test_charset_has_exact_size(self):
        self.assertEqual(len(self.CHARSET), 7 * 256)

    def test_charset_has_line_num_in_upper_3_bits(self):
        line = 0
        for byte in self.CHARSET:
            encoded_line = (byte & 0b11100000) >> 5
            self.assertEqual(encoded_line, line)
            line += 1
            if line == 7:
                line = 0

class TestVW_PREMIUM_4(unittest.TestCase, _TestCharsetMixin):
    TEXT = charsets._VW_PREMIUM_4
    CHARSET = charsets.VW_PREMIUM_4

class TestVW_PREMIUM_5(unittest.TestCase, _TestCharsetMixin):
    TEXT = charsets._VW_PREMIUM_5
    CHARSET = charsets.VW_PREMIUM_5
