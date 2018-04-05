# M62419FP Monitor

![Photo](https://user-images.githubusercontent.com/52712/38273422-bed866be-3740-11e8-880b-c5b14daa2f4f.png)

## Overview

This is an ATmega1284 project that passively monitors SPI commands sent to a Mitsubishi [M62419FP](https://web.archive.org/web/20180405163918/https://www.renesas.com/en-us/doc/products/assp/rej03f0207_m62419fpds.pdf) sound controller, which is used in the Premium 4 radio.  As SPI commands are sent to the M62419FP, the AVR receives them and tracks what should be the state of the M62419FP internal registers.  It then sends that data out its UART to a host computer.  Software runs on the host computer that continuously displays the current state of the M62419FP.  

## Features

 - Clips onto the M62419FP with two wires (SPI clock and data)
 - Interprets all documented SPI commands
 - Tracks attenuation, balance, fade, bass, treble, and input selection
 - Sends all its state out its UART after any SPI command is received

## Usage

The firmware is written completely in AVR assembly using the  [AVRA](http://avra.sourceforge.net/) assembler.  At the time of writing, AVRA does not support the ATmega1284 as a target.  My [patched version of AVRA](https://github.com/mnaberez/avra) is required to build the source.

Build the hardware as described in [`hardware/`](./hardware/) and flash the firmware.
Connect the two clips to the SPI lines of the M62419FP.  Reset the board first and then the radio.  As soon as the board receives an SPI command, it will interpret the command and send the current state of the M62419FP out its UART using a binary protocol.

Run the host software:

```
$ python3 host/monitor.py

CH0/R=0 dB (L=0,I=FM)  CH1/L=0 dB (L=0,I=FM)  FADER=0 dB (F)  BASS=0 dB  TREB=0 dB
```

Make a sound adjustment on the radio such as turning the volume knob.  The radio will send an SPI command to the M62419FP, the board will capture it and send data to the host, then status line on the host will update.

## Notes

- The M62419FP doesn't have a chip select or reset line that could be used for synchronization.  It only has SPI clock and data lines.  If the board is disconnected from the M62419FP while the target is running, the board and
the target need to be reset or else sync will be lost and SPI commands will not be received correctly.

- The Premium 4 radio uses the M62419FP for attenuation, fade, balance, and input selection.  It doesn't use the bass or treble registers of the M62419FP.  Those registers are tracked but they will always show as 0.

- The board has only been tested with the Premium 4 radio.  It can likely be used to monitor other devices that use an M62419FP as well, if the SPI clock rate is slow enough.  SPI receive is done in software ("bit banging") because the ATmega1284 hardware SPI is not capable of receiving the M62419FP's 14-bit commands.
