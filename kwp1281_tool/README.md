# KWP1281 Tool

![Photo](https://user-images.githubusercontent.com/52712/38381999-6bfcfcd8-38bd-11e8-9d4d-7412bfac2cb3.jpg)

## Overview

This is an ATmega1284 project that implements the [KWP1281](https://translate.google.com/translate?hl=en&sl=de&tl=en&u=https%3A%2F%2Fde.wikipedia.org%2Fwiki%2FKWP1281) diagnostics protocol.  It has two serial ports.  The first serial port uses an [L9637D](https://web.archive.org/web/20180405180225/http://www.st.com/content/ccc/resource/technical/document/datasheet/4a/80/83/26/e0/78/4d/18/CD00000234.pdf/files/CD00000234.pdf/jcr:content/translations/en.CD00000234.pdf) transceiver to connect to the K-line on the car's OBD-II port.  It can also be connected to the K-line on a module outside of the car, such as the radio shown above.  The second serial port connects to a host computer and shows debug messages.

When I reverse engineered the firmware for the Premium 4 radio, I found that it responds to several hidden KWP1281 commands.  I wanted to send these commands but I had no way to do so.  The scan tool I normally use does not provide any access to the
underlying communications.  I built this project so I could directly interact with the Premium 4 radio using the raw KWP1281 protocol.  I have since used it successfully on other radios as well.

## Features

 - Capable of sending and receiving raw KWP1281 blocks
 - Outputs a transcript of all KWP1281 blocks sent and received
 - Checks for errors whenever possible, during both transmit and receive

## Design

KWP1281 is asynchronous serial, typically at 9600 or 10400 baud.  It should be possible to communicate with a module over KWP1281 using any computer with a serial port.  However, doing so is problematic for two reasons.  The first is that before communication starts, the module must be woken up with "slow init" by sending its address at a nonstandard baud rate (5 baud).  The second is that modules are often very sensitive to timing.  Modules may require a delay of a few milliseconds before each byte is transmitted.  However, if the transmission is delayed by a few milliseconds too long, it may cause the module to disconnect.

This project solves those issues by doing all communications using an AVR.  It first bit-bangs the 5 baud init, then uses the hardware UART for the 9600 or 10400 baud communication.  The AVR ensures that consistent delays are inserted between bytes and after blocks.  As it runs, it outputs debugging messages to its second UART with all the raw KWP1281 blocks sent and received.

## Usage

Build the hardware as described in [`hardware/`](./hardware/).  Modify the [`main.c`](./firmware/main.c) file in the firmware for the KWP1281 communications you want to perform.  Build and flash the firmware.  Connect the board to the module.  When the board is powered up, it will begin KWP1281 communications immediately.  Use any terminal program to view the debug output.

Example code for `main.c`:
```
kwp_connect(0x56, 9600);
kwp_send_login_block(0x0672, 0x01, 0x869f);
kwp_receive_block_expect(KWP_ACK);
```

Corresponding debug output (complement bytes omitted):
```
INIT 0x56

BEGIN SEND BLOCK: LOGIN
TX: 08
TX: 70
TX: 2B
TX: 06
TX: 72
TX: 01
TX: 86
TX: 9F
RX: 03
END SEND BLOCK: LOGIN

BEGIN RECEIVE BLOCK
RX: 03
RX: 71
RX: 09
RX: 03
END RECEIVE BLOCK
```

## Compatibility

The tool reliably communicates with these radios:

 - Premium 4 (Clarion)
 - Premium 5 (Delco)
 - Gamma 5 (TechniSat)

It is likely to work with more radios and other modules as well.
