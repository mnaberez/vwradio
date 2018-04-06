# VW Radios

![Photo](https://user-images.githubusercontent.com/52712/38045152-b4fae3bc-3270-11e8-9463-c228bd5f6f46.jpg)

This repository is all about the Volkswagen Premium 4 and 5 car radios.  This all started when my radio broke and I bought a used replacement that didn't come with the security code.  I reverse engineered the radio to unlock it.  Things have snowballed from there.

The Premium 4 radio (shown above) was made by Clarion and used in North America between about 1998-1999.  The Premium 5 was made by Delphi (Delco) and used in North America between about 2000-2001.  The Premium 5 was the last single DIN size radio used in North America.  Although they are externally similar, the Premium 4 and 5 are completely different inside.  

Please note that VW used different radios in Europe for the same years.  Those radios are not called "Premium".  They had other names like "Gamma" and were made by different manufacturers.  The information here does not apply to them.

## Projects

- [`avr_kwp1281`](./avr_kwp1281/):  Diagnostics protocol tool (Volkswagen [KWP1281](https://translate.google.com/translate?hl=en&sl=de&tl=en&u=https%3A%2F%2Fde.wikipedia.org%2Fwiki%2FKWP1281)).  It can send arbitrary KWP1281 commands to a module.  It is reliable with both the Premium 4 and 5 radios and probably works with other modules as well.

- [`avr_radio`](./avr_radio/): Faceplate emulator (NEC [µPD16432B](http://6502.org/documents/datasheets/nec/nec_upd16432b_2000_dec.pdf)).  It plugs into the Premium 4 radio in place of the faceplate and allows the radio to be controlled over serial.  It can also simultaneously control a real faceplate.

- [`avr_tape`](./avr_tape/): Cassette tape emulator (Philips TDA3612).  It plugs into the Premium 4 radio in place of the SCA4.4/TDA3612 cassette tape assembly and fools the radio into thinking a tape is playing.

- [`avr_volume`](./avr_volume/): Volume monitor (Mitsubishi [M62419FP](https://web.archive.org/web/20180328173343/http://pdf.datasheetcatalog.com/datasheet/MitsubishiElectricCorporation/mXrwwyx.pdf)).
It connects in parallel with the M62419FP sound controller used in the Premium 4 radio and sends updates over serial whenever the sound registers are changed.

- [`docs`](./docs/): Notes about the Premium 4 and 5 radios from reverse engineering.  This includes commented disassembly listings of radio firmware.  The original binaries extracted from the chips are not in this repository.

## Discoveries

Here are some of the more interesting discoveries I made about the radios:

- Premium 4 supports hidden KWP1281 commands 0x01 Read RAM, 0x03 Read ROM, 0x19 Read EEPROM, and a special command 0xF0 that can read the SAFE code.  I have successfully executed all of these commands.

- Premium 4 contains a hidden mode where the SAFE code can be changed via the faceplate.  The SAFE code can also be disabled so no code is required at all.  Entering this mode requires pressing keys that do not exist on the faceplate.  I assume this is a manufacturing function and a special faceplate was used in the factory.  The mode can be entered even if the radio is locked in SAFE mode.  

- Premium 5 microcontroller, Delco "N60 Flash", is actually an NEC µPD78F0831Y.  This part is undocumented but seems very similar to the [µPD78F0833Y](https://web.archive.org/web/20180328161019/https://www.renesas.com/en-us/doc/DocumentServer/021/U13892EJ2V0UM00.pdf).  It has flash for program memory.  I have successfully dumped the firmware, made changes to it, and reprogrammed it.

- Both the Premium 4 and 5 radios can be cracked using brute force by entering all SAFE codes on the faceplate.  VW only [seems to use](https://gist.github.com/mnaberez/1d1b206e0b585b1b89d1) codes 0000-1999, which takes a maximum of 42 days at 2 tries per hour.

## Spin-offs

I also developed several other projects as a side effect of this work:

- [f2mc8dump](https://github.com/mnaberez/f2mc8dump): Exploit to dump the internal ROM of Fujitsu F2MC-8L microcontrollers with external bus capability

- [f2mc8dasm](https://github.com/mnaberez/f2mc8dasm): Fujitsu F2MC-8 disassembler that generates output compatible with the [asf2mc8](http://shop-pdp.net/ashtml/asf2mc.htm) assembler

- [language-f2mc8](https://github.com/mnaberez/language-f2mc8): Fujitsu F2MC-8 assembly language syntax highlighting for the [Atom](https://atom.io) text emulator

## Author

[Mike Naberezny](https://github.com/mnaberez)
