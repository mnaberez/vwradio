# SCA4.4 / TDA3612 Emulator

This is a partial emulator for the SCA4.4 cassette module, which is used in
the Premium 4 radio.  The main IC on the SCA4.4 is the Philips TDA3612, which
is undocumented (no datasheet found).

The purpose of this emulator is to trick the Premium 4 into thinking that a
cassette is playing so that it switches on the cassette audio input.  This
allows the SCA4.4 to be completely removed from the radio while the cassette
audio input can be used with another audio source.

Play and Stop are both working.  Fast Forward and Rewind are not implemented.
