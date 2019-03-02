# SCA4.4 / TDA3612 Emulator

![Photo](https://user-images.githubusercontent.com/52712/53686389-34a14780-3cdb-11e9-87e8-421329c67d35.jpg)

## Overview

This is an ATmega1284 project that partially emulates for the SCA4.4 cassette tape module, which is used in the [Premium 4](../reverse_engineering/vw_premium_4_clarion) radio.  The main IC on the SCA4.4 is the Philips TDA3612, which is undocumented (no datasheet available).

The purpose of this emulator is to trick the Premium 4 into thinking that a cassette is playing so that it switches on the cassette audio input.  This allows the SCA4.4 to be completely removed from the radio while the cassette audio input can be used with another audio source.

## Operation

There is a switch on the cassette transport.  When a cassette is inserted or removed, it passes by the switch and causes it to toggle momentarily.  The radio watches for these pulses to detect the presence of a cassette.

To play a cassette, the radio sends commands to the TDA3612.  The TDA3612 is an SPI peripheral with enable, data, and clock lines.  The data is unidirectional (from the radio to the TDA3612 only).  

The clock line is bidirectional.  When enable is asserted, the clock line is an input used to clock in the SPI bits.  When enable is not asserted, the clock line is a tachometer output.  It pulses as the cassette tape rotates and the radio monitors the speed to detect tape problems.  

## Design

The emulator fakes the switch output to make the radio think a cassette is inserted.  A pin change interrupt monitors the enable line and configures the clock line as either an input (SPI clock) or an output (tachometer).  When enable is asserted, the AVR hardware SPI is used to receive the TDA3612 commands.  The commands have not been fully reverse engineered, but are understood enough to make Play and Stop work.  When the emulator receives the Play command, it pulses the clock line (tachometer) so that the radio thinks the cassette is playing.  When it receives the Stop command, it stops pulsing the clock line.

## Usage

The Premium 4 will automatically start playing a tape when one is inserted.  There is a button on the emulator board that fakes tape insertion.  Power up the radio and then push the button.  The radio will think that a tape has been inserted and will show `TAPE PLAY A` to indicate that a tape is playing.  The audio multiplexer has now selected the cassette audio and the radio will continue to display `TAPE PLAY A` indefinitely.

Play and Stop are both working.  If the `STOP` button on the radio is pressed, or another source button like `FM` is pressed, the emulator will stop playing the tape.  Press the `TAPE` button on the radio to start playing again.  Fast Forward and Rewind are not implemented by the emulator and will show a `TAPE ERROR` message on the radio display.

The emulator will output debug messages on its UART at 115200-N-8-1.  It will show the SPI data received from the radio and its current state (faking insertion, playing, or stopped).

## Status

This project was built as a proof-of-concept and is no longer developed.  I replaced the Premium 4 in my car with the [Premium 5](../reverse_engineering/vw_premium_5_delco).  Unlike the Premium 4 which has code in mask ROM that can't be changed, the Premium 5 has code in flash that can be rewritten.  Custom firmware can be developed for the Premium 5, so hacks like this emulator are not needed.
