# Remote

This is a modification of the "SOFTWARE 23" firmware to give remote control of the radio.  It changes and expands the manufacturing mode KWP1281 commands on address 0x7C.  It has the following changes:

 - The 5K filler area at the end of the ROM has been removed.  This area contained 0xBF (BRK instruction) and then the checksum as the last two bytes.  The NEC toolchain will automatically fill unused bytes in the ROM with 0xFF.

 - The build process now calculates the ROM checksum automatically and writes it into the binary.
