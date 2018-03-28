# VW Radios

![Photo](https://user-images.githubusercontent.com/52712/38045152-b4fae3bc-3270-11e8-9463-c228bd5f6f46.jpg)

This repository is all about the Volkswagen Premium 4 and 5 car radios.  This all started when my radio broke and I bought a used replacement that didn't come with the security code.  I reverse engineered the radio to unlock it.  Things have snowballed from there.

The Premium 4 radio (shown above) was made by Clarion and used in North America between about 1998-1999.  The Premium 5 was made by Delphi (Delco) and used in North America between about 2000-2001.  The Premium 5 was the last single DIN size radio used in North America.  Although they are externally similar, the Premium 4 and 5 are completely different inside.  

Please note that VW used different radios in Europe for the same years.  Those radios are not called "Premium".  They had other names like "Gamma" and were made by different manufacturers.  The information here does not apply to them.

## Projects

- [`avr_kwp1281`](./avr_kwp1281/): Atmel ATmega1284 project (GCC) with two serial ports: one for KWP1281 (OBD-II port) and one for a PC.  It can be used to send any KWP1281 blocks to a radio.  It is reliable with both the Premium 4 and 5 radios and will likely work with other KWP1281 devices as well.  

- [`avr_radio`](./avr_radio/): Atmel ATmega1284 project (GCC) that emulates a radio faceplate (NEC [uPD16432B](https://web.archive.org/web/20180328161019/https://www.renesas.com/en-us/doc/DocumentServer/021/U13892EJ2V0UM00.pdf)).  It plugs into the radio in place of the original faceplate.  It has a serial port that allows the radio to be remotely controlled via a PC.  It can also simultaneously control a real faceplate (man-in-the-middle).  It has been tested on the Premium 4 only.

- [`avr_tape`](./avr_tape/): Atmel ATmega1284 project (GCC) that emulates the undocumented TDA3612 cassette tape controller found in the Premium 4.  It plugs into the radio in place of the original cassette daughterboard.  Play and Stop are both working.  Fast Forward and Rewind are not implemented.

- [`avr_volume`](./avr_volume/): Atmel ATmega1284 project (assembly) that monitors the Mitsubishi [M62419FP](https://web.archive.org/web/20180328173343/http://pdf.datasheetcatalog.com/datasheet/MitsubishiElectricCorporation/mXrwwyx.pdf) sound controller in the Premium 4.  It connects in parallel to the M62419FP's SPI lines and has a serial port to connect to a PC.  It sends updates out its serial port whenever the M62419FP state is changed.

- [`docs`](./docs/): Notes about the Premium 4 and 5 radios from reverse engineering.  This includes commented disassembly listings of radio firmware.  The original binaries extracted from the chips are not in this repository.

## Discoveries

Here are some of the more interesting discoveries I made about the radios:

- Premium 4 supports hidden KWP1281 commands 0x01 Read RAM, 0x03 Read ROM, 0x19 Read EEPROM, and a special command 0xF0 that can read the SAFE code.  I have successfully executed all of these commands.

- Premium 4 contains a hidden mode where the SAFE code can be changed via the faceplate.  The SAFE code can also be disabled so no code is required at all.  Entering this mode requires pressing keys that do not exist on the faceplate.  I assume this is a manufacturing function and a special faceplate was used in the factory.  The mode can be entered even if the radio is locked in SAFE mode.  

- Premium 5 microcontroller, Delco "N60 Flash", is actually an NEC uPD78F0831Y.  This part is undocumented but seems very similar to the [uPD78F0833Y](https://web.archive.org/web/20180328161019/https://www.renesas.com/en-us/doc/DocumentServer/021/U13892EJ2V0UM00.pdf).  It has flash for program memory.  I have successfully dumped the firmware, made changes to it, and reprogrammed it.

- Both the Premium 4 and 5 radios can be cracked using brute force by entering all SAFE codes on the faceplate.  VW only [seems to use](https://gist.github.com/mnaberez/1d1b206e0b585b1b89d1) codes 0000-1999, which takes a maximum of 42 days at 2 tries per hour.

## Spin-offs

I also developed several other projects as a side effect of this work:

- [f2mc8dump](https://github.com/mnaberez/f2mc8dump): Exploit to dump the internal ROM of Fujitsu F2MC-8L microcontrollers with external bus capability

- [f2mc8dasm](https://github.com/mnaberez/f2mc8dasm): Fujitsu F2MC-8 disassembler that generates output compatible with the [asf2mc8](http://shop-pdp.net/ashtml/asf2mc.htm) assembler

- [language-f2mc8](https://github.com/mnaberez/language-f2mc8): Fujitsu F2MC-8 assembly language syntax highlighting for the [Atom](https://atom.io) text emulator

## Author

[Mike Naberezny](https://github.com/mnaberez)
