# SCA4.4 / TDA3612 Emulator

![Photo](https://user-images.githubusercontent.com/52712/53686389-34a14780-3cdb-11e9-87e8-421329c67d35.jpg)

## Overview

This is a partial emulator for the SCA4.4 cassette module, which is used in the [Premium 4](../reverse_engineering/vw_premium_4_clarion) radio.  The main IC on the SCA4.4 is the Philips TDA3612, which is undocumented (no datasheet available).

The purpose of this emulator is to trick the Premium 4 into thinking that a cassette is playing so that it switches on the cassette audio input.  This allows the SCA4.4 to be completely removed from the radio while the cassette audio input can be used with another audio source.

## Status

Play and Stop are both working.  Fast Forward and Rewind are not implemented.  

This project was built as a proof-of-concept.  I replaced the Premium 4 in my car with the [Premium 5](../reverse_engineering/vw_premium_5_delco).  Unlike the Premium 4 which has code in mask ROM that can't be changed, the Premium 5 has code in flash that can be rewritten.  Custom firmware can be developed for the Premium 5, so hacks like this cassette emulator are not needed.
