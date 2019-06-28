# VW Radios

![Photo](https://user-images.githubusercontent.com/52712/38045152-b4fae3bc-3270-11e8-9463-c228bd5f6f46.jpg)

This repository is all about reverse engineering older Volkswagen car radios, like the Premium 4
radio shown above.  The radios studied here are over fifteen years old and are the single-DIN
size.  Despite their age, they are intelligent and support
on-board diagnostics (using VW's KWP1281 protocol on the K-line).  You'll find notes about protocols and hardware here, along with partial disassembles of firmware, but no original binaries of firmware or EEPROMs.

VW radios from this era require a four digit security code often referred to as the "SAFE code". The radios usually store the SAFE code in a serial EEPROM like a 93C46 or a 24C04. The SAFE code can be found by opening up the radio, desoldering the EEPROM, reading it, and then soldering the EEPROM back in. I wanted to know if there was an easier way.

I disassembled the firmware for these radios: Premium 4 (Clarion), Premium 5 (Delco), Gamma 5 (TechniSat), and Rhapsody (TechniSat).  I found that all of them have backdoors to read the SAFE code via on-board diagnostics.  Reading the code this way means the radio does not need to be opened and may not even need to be removed from the car.  Since this information is not published anywhere and I couldn't find any tool that could do it, I built my own tool.

## Projects

- [`kwp1281_tool`](./kwp1281_tool/):  Diagnostics protocol tool (Volkswagen [KWP1281](https://translate.google.com/translate?hl=en&sl=de&tl=en&u=https%3A%2F%2Fde.wikipedia.org%2Fwiki%2FKWP1281)).  It can send arbitrary commands to a radio, or any other module, using the KWP1281 protocol.  It can also send commands using a proprietary protocol found in TechniSat radios.  Finally, it can automatically retrieve the SAFE code for any of the radios listed above.

- [`faceplate_emulator`](./faceplate_emulator/): Faceplate emulator (NEC [µPD16432B](http://6502.org/documents/datasheets/nec/nec_upd16432b_2000_dec.pdf)).  It plugs into the Premium 4 radio in place of the faceplate and allows the radio to be controlled over serial.  It can also simultaneously control a real faceplate.

- [`tape_emulator`](./tape_emulator/): Cassette tape emulator (Philips TDA3612).  It plugs into the Premium 4 radio in place of the SCA4.4/TDA3612 cassette tape assembly and fools the radio into thinking a tape is playing.

- [`volume_monitor`](./volume_monitor/): Volume monitor (Mitsubishi [M62419FP](https://web.archive.org/web/20180328173343/http://pdf.datasheetcatalog.com/datasheet/MitsubishiElectricCorporation/mXrwwyx.pdf)).
It connects in parallel with the M62419FP sound controller used in the Premium 4 radio and sends updates over serial whenever the sound registers are changed.

- [`reverse_engineering`](./reverse_engineering/): Notes about the radios from reverse engineering, including commented disassembly listings of radio firmware.  This repository does not contain any original firmware or EEPROM binaries.

## Discoveries

Here are some of the more interesting discoveries I made about the radios:

- All of the radios studied support a common set of KWP1281 diagnostics functions on the normal radio address of 0x56.  Some radios (not all) also have protected KWP1281 commands on this same address.  The protected commands available vary by model but may include the ability to read the microcontroller's RAM or RAM, and to read/write serial EEPROM(s).  Accessing the protected commands requires sending a login block based on the SAFE code and also performing a group reading of a hidden group.

- VW Premium 4 (Clarion) has an unprotected KWP1281 command 0xF0 that returns the SAFE code.  It also contains a hidden mode where the SAFE code can be changed via the faceplate.  Entering this mode requires pressing keys that do not exist on the faceplate.  I assume there was a special manufacturing faceplate used by the factory.

- VW Premium 5 (Delco) and Seat Liceo (Delco) respond to a different set of KWP1281 commands on address 0x7C.  These commands require authentication using a hardcoded login block.  Once authenticated, commands are available to read and write the EEPROM, which can be used to retrieve the SAFE code.

- VW Gamma 5 (TechniSat) and Rhapsody (TechniSat) have a proprietary, non-KWP protocol on address 0x7C.  It is unlike anything that I have found documented and was likely made by TechniSat just for manufacturing of the radio.  It has commands to read and write the EEPROM, which can be used to retrieve the SAFE code.  The SAFE code area of the EEPROM is normally filtered from these commands, but another command disables the filtering.

## Spin-offs

I also developed several other projects as a side effect of this work:

- [f2mc8dump](https://github.com/mnaberez/f2mc8dump): Exploit to dump the internal ROM of Fujitsu F2MC-8L microcontrollers with external bus capability

- [f2mc8dasm](https://github.com/mnaberez/f2mc8dasm): Fujitsu F2MC-8 disassembler that generates output compatible with the [asf2mc8](http://shop-pdp.net/ashtml/asf2mc.htm) assembler

- [language-f2mc8](https://github.com/mnaberez/language-f2mc8): Fujitsu F2MC-8 assembly language syntax highlighting for the [Atom](https://atom.io) text editor

- [k0dasm](https://github.com/mnaberez/k0dasm): NEC 78K0 disassembler that generates output compatible with the [as78k0](http://shop-pdp.net/ashtml/as78k0.htm) assember

- [m740dasm](https://github.com/mnaberez/m740dasm): Mitsubishi 740 disassembler that generates output compatible with the [as740](http://shop-pdp.net/ashtml/as740.htm) assember

## Author

[Mike Naberezny](https://github.com/mnaberez)
