# VW Radios

![Photo](https://user-images.githubusercontent.com/52712/38045152-b4fae3bc-3270-11e8-9463-c228bd5f6f46.jpg)

This repository is all about the Volkswagen Premium 4 and 5 car radios.  This all started when my radio broke and I bought a used replacement that didn't come with the security code.  I reverse engineered the radio to unlock it.  Things have snowballed from there.

The Premium 4 radio (shown above) was made by Clarion and used in North America between about 1998-1999.  The Premium 5 was made by Delphi (Delco) and used in North America between about 2000-2001.  The Premium 5 was the last single DIN size radio used in North America.  Although they are externally similar, the Premium 4 and 5 are completely different inside.  

Please note that VW used different radios in Europe for the same years.  Those radios are not called "Premium".  They had other names like "Gamma" and were made by different manufacturers.  The information here does not apply to them.

## Projects

- [`faceplate_emulator`](./faceplate_emulator/): Faceplate emulator (NEC [µPD16432B](http://6502.org/documents/datasheets/nec/nec_upd16432b_2000_dec.pdf)).  It plugs into the Premium 4 radio in place of the faceplate and allows the radio to be controlled over serial.  It can also simultaneously control a real faceplate.

- [`kwp1281_tool`](./kwp1281_tool/):  Diagnostics protocol tool (Volkswagen [KWP1281](https://translate.google.com/translate?hl=en&sl=de&tl=en&u=https%3A%2F%2Fde.wikipedia.org%2Fwiki%2FKWP1281)).  It can send arbitrary KWP1281 commands to a module.  It is reliable with both the Premium 4 and 5 radios and probably works with other modules as well.

- [`tape_emulator`](./tape_emulator/): Cassette tape emulator (Philips TDA3612).  It plugs into the Premium 4 radio in place of the SCA4.4/TDA3612 cassette tape assembly and fools the radio into thinking a tape is playing.

- [`volume_monitor`](./volume_monitor/): Volume monitor (Mitsubishi [M62419FP](https://web.archive.org/web/20180328173343/http://pdf.datasheetcatalog.com/datasheet/MitsubishiElectricCorporation/mXrwwyx.pdf)).
It connects in parallel with the M62419FP sound controller used in the Premium 4 radio and sends updates over serial whenever the sound registers are changed.

- [`reverse_engineering`](./reverse_engineering/): Notes about the Premium 4 and 5 radios from reverse engineering, including commented disassembly listings of radio firmware.  This repository does not contain any original firmware binaries.

## Discoveries

Here are some of the more interesting discoveries I made about the radios:

- Both the Premium 4 and 5 radios have hidden KWP1281 functionality.  There are significant differences but both have backdoors that allow the SAFE code to be read.  Both support reading the microcontroller's RAM or ROM, and for reading the serial EEPROM.  In the Premium 5, there is also support for writing the serial EEPROM.

- The Delco "N60 FLASH" microcontroller in the Premium 5 radio is actually an NEC µPD78F0831Y.  This part is undocumented but it is similar to the [µPD78F0833Y](https://web.archive.org/web/20180328161019/https://www.renesas.com/en-us/doc/DocumentServer/021/U13892EJ2V0UM00.pdf).  It has flash for program memory.  I have successfully dumped the firmware, made changes to it, and reprogrammed it.

- Premium 4 contains a hidden mode where the SAFE code can be changed via the faceplate.  The SAFE code can also be disabled so no code is required at all.  Entering this mode requires pressing keys that do not exist on the faceplate.  I assume this is a manufacturing function and a special faceplate was used in the factory.  The mode can be entered even if the radio is locked in SAFE mode.

- Both the Premium 4 and 5 radios can be cracked using brute force by entering all SAFE codes on the faceplate.  VW only [seems to use](https://gist.github.com/mnaberez/1d1b206e0b585b1b89d1) codes 0000-1999, which takes a maximum of 42 days at 2 tries per hour.

## Spin-offs

I also developed several other projects as a side effect of this work:

- [f2mc8dump](https://github.com/mnaberez/f2mc8dump): Exploit to dump the internal ROM of Fujitsu F2MC-8L microcontrollers with external bus capability

- [f2mc8dasm](https://github.com/mnaberez/f2mc8dasm): Fujitsu F2MC-8 disassembler that generates output compatible with the [asf2mc8](http://shop-pdp.net/ashtml/asf2mc.htm) assembler

- [language-f2mc8](https://github.com/mnaberez/language-f2mc8): Fujitsu F2MC-8 assembly language syntax highlighting for the [Atom](https://atom.io) text editor

## Author

[Mike Naberezny](https://github.com/mnaberez)
