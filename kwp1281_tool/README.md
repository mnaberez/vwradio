# KWP1281 Tool

![Photo](https://user-images.githubusercontent.com/52712/38381999-6bfcfcd8-38bd-11e8-9d4d-7412bfac2cb3.jpg)

## Overview

This is an ATmega1284 project that implements the [KWP1281](https://translate.google.com/translate?hl=en&sl=de&tl=en&u=https%3A%2F%2Fde.wikipedia.org%2Fwiki%2FKWP1281) diagnostics protocol.  It has two serial ports.  The first serial port uses an [L9637D](https://web.archive.org/web/20180405180225/http://www.st.com/content/ccc/resource/technical/document/datasheet/4a/80/83/26/e0/78/4d/18/CD00000234.pdf/files/CD00000234.pdf/jcr:content/translations/en.CD00000234.pdf) transceiver to connect to the K-line on the car's on-board diagnostics port.  It can also be connected to the K-line on a module outside of the car, such as the radio shown above.  The second serial port connects to a host computer and shows debug messages.

When I reverse engineered the firmware for the VW Premium 4 radio, I found that it responds to several hidden KWP1281 commands.  I wanted to send these commands but I had no way to do so.  The commerical scan tool that I was using at the time did not provide any access to the underlying communications.  I built this project so I could directly interact with the Premium 4 radio using the raw KWP1281 protocol.  I have since used it successfully on other modules as well.

There are other open source projects that implement KWP1281 but this code is not based on any of them.  Therefore, this code may have different features or problems than those other implementations.  VW did not release documentation on KWP1281 to the public.  I had to make various assumptions and best guesses based on my own reverse engineering and what I could find posted by others online.

## Features

 - Automatically detects the baud rate of the module
 - Capable of sending and receiving raw KWP1281 blocks
 - Outputs a transcript of all KWP1281 blocks sent and received
 - Checks for errors whenever possible, during both transmit and receive
 - Reliably maintains a connection for long periods with modules tested

## Design

KWP1281 is asynchronous serial, typically 9600 or 10400 baud.  Most computers are able to communicate with a module using only a serial port and a "dumb" electrical interface to the K-line.  However, this has a few issues:

 - Before communication starts, the module must be woken up with "slow init" by sending its address at a nonstandard baud rate (5 baud).

 - The protocol is designed for automatic baud rate detection.  After a module wakes up, it sends a sync byte (0x55) so that the receiver can measure its baud rate.  To detect the baud rate reliably, a timer with microsecond precision is needed.  A workaround is to blindly try connecting at different baud rates but this increases connection time.

 - Modules are sensitive to timing.  Once a connection is established, modules typically require a delay of one millisecond before each byte in a block is transmitted.  However, if the byte is delayed by too many milliseconds, the module may return "no acknowledge" or may abort the connection entirely.  Delays caused by the computer's operating system multitasking, or by latencies when using a USB to serial adapter, can cause the KWP1281 connection to be unreliable.

This project is an "intelligent" interface that solves those issues by doing all communications using an Atmel AVR microcontroller.  It bit-bangs the 5 baud init, uses a hardware timer to measure the baud rate, and then uses a hardware UART for serial communications.  It ensures that consistent delays are inserted and that the connection to the module is always kept alive.  In testing with several different modules, it has been able to maintain a connection for hours without retrying or reconnecting.  As it runs, it outputs debugging messages to a second UART with all the raw KWP1281 blocks sent and received.

## Usage

Build the hardware as described in [`hardware/`](./hardware/).  Modify the [`main.c`](./firmware/main.c) file in the firmware for the KWP1281 communications you want to perform.  Build and flash the firmware.  Connect the board to the module.  When the board is powered up, it will begin KWP1281 communications immediately.  Use any terminal program to view the debug output.

Example code for `main.c`:
```
kwp_result_t result = kwp_connect(KWP_RADIO);
kwp_panic_if_error(result);

result = kwp_read_group(1);
kwp_panic_if_error(result);
```

Corresponding debug output:
```
CONNECT 56
BAUD: 10400 (DETECTED 10482)
KWRECV: 01 8A
KWSEND: 75
RECV: 0F AD F6 31 4A 30 30 33 35 31 38 30 42 20 20 03
PERFORM ACK
SEND: 03 AE 09 03
RECV: 0F AF F6 20 52 61 64 69 6F 20 44 45 32 20 20 03
PERFORM ACK
SEND: 03 B0 09 03
RECV: 0E B1 F6 20 20 20 20 20 20 20 30 30 30 31 03
PERFORM ACK
SEND: 03 B2 09 03
RECV: 08 B3 F6 00 03 21 86 9F 03
PERFORM ACK
SEND: 03 B4 09 03
RECV: 03 B5 09 03
VAG Number: "1J0035180B  "
Component:  " Radio DE2         0001"
PERFORM GROUP READ
SEND: 04 B6 29 01 03
RECV: 0F B7 E7 25 00 00 06 5F 80 17 64 00 25 00 87 03
MEAS: GROUP=01 CELL=01 FORMULA=25 VALUE=0000
MEAS: GROUP=01 CELL=02 FORMULA=06 VALUE=5F80
MEAS: GROUP=01 CELL=03 FORMULA=17 VALUE=6400
MEAS: GROUP=01 CELL=04 FORMULA=25 VALUE=0087
```

## Compatibility

The tool reliably communicates with these radios:

 - VW Premium 4 (Clarion)
 - VW Premium 5 (Delco)
 - VW Gamma 5 (Sony)
 - VW Gamma 5 (TechniSat)
 - VW Rhapsody (TechniSat)

It also reliably communicates with this engine control module:

 - VW Golf/Jetta Mk3 ABA 2.0L Motronic M5.9 (Bosch)

It is likely to work with other modules as well.
