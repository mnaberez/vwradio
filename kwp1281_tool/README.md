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
kwp_result_t result = kwp_autoconnect(KWP_RADIO);
kwp_panic_if_error(result);

result = kwp_login_safe(1866);
kwp_panic_if_error(result);

result = kwp_read_ram(0, 0xffff, 32);
kwp_panic_if_error(result);
```

Corresponding debug output:
```
CONNECT 56: 55 01 8A 75
RECV: 0F E8 F6 31 4A 30 30 33 35 31 38 30 42 20 20 03
PERFORM ACK
SEND: 03 E9 09 03
RECV: 0F EA F6 20 52 61 64 69 6F 20 44 45 32 20 20 03
PERFORM ACK
SEND: 03 EB 09 03
RECV: 0E EC F6 20 20 20 20 20 20 20 30 30 30 31 03
PERFORM ACK
SEND: 03 ED 09 03
RECV: 08 EE F6 00 03 21 86 9F 03
PERFORM ACK
SEND: 03 EF 09 03
RECV: 03 F0 09 03
PERFORM LOGIN
SEND: 08 F1 2B 07 4A 01 86 9F 03
RECV: 03 F2 09 03
PERFORM GROUP READ
SEND: 04 F3 29 19 03
RECV: 04 F4 0A F4 03
PERFORM READ xx MEMORY
SEND: 06 F5 01 20 00 00 03
RECV: 23 F6 FE 88 0D 75 0D 75 0D 93 59 CC 3E CC 3A 75 0D 04 59 ...
```

## Compatibility

The tool reliably communicates with these radios:

 - VW Premium 4 (Clarion)
 - VW Premium 5 (Delco)
 - VW Gamma 5 (Sony)
 - VW Gamma 5 (TechniSat)
 - VW Rhapsody (TechniSat)

It is likely to work with more radios and other modules as well.
