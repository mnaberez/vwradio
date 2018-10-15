# Remote

This is a modification of the "SOFTWARE 23" firmware to give remote control of the radio.  It changes and expands the manufacturing mode KWP1281 commands on address 0x7C.  It has the following changes:

 - 5K of filler bytes at the end of the ROM has been removed.  The area now contains various modifications.  The NEC toolchain will automatically fill any unused bytes in the area with 0xFF.

 - The build process now calculates the ROM checksum automatically and writes it into the binary.

 - Address 0x7C block title and handler tables have been moved to the end of the ROM and modified.
