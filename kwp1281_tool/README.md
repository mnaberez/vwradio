# KWP1281 Tool

![Photo](./hardware/photos/board.jpg)

## Overview

This is a USB interface that connects to the K-line of a vehicle's OBD port or to the K-line of a control module on a bench.  It uses a microcontroller that has been programmed to implement the [KWP1281](https://de.wikipedia.org/wiki/KWP1281) protocol.

When I reverse engineered the firmware for the VW Premium 4 radio, I found that it responds to several hidden KWP1281 commands.  I wanted to send these commands but I had no way to do so.  The commercial scan tool that I was using at the time did not provide any access to the underlying communications.  I built this project so I could directly interact with the Premium 4 radio using the raw KWP1281 protocol.  I have since used it successfully on other modules as well.

There are other open source projects that implement KWP1281 but this project is not based on any of them.  Therefore, it may have different features or problems than those other implementations.  VW did not release any documentation on KWP1281 to the public and I do not have any non-public information.  My implementation is based on my own [reverse engineering](../reverse_engineering/) of the diagnostics routines in several car radios, along with unofficial information posted by others online.

## Features

 - Galvanic isolation between the USB port and the OBD port
 - Automatically detects the baud rate of the module
 - Capable of sending and receiving raw KWP1281 blocks
 - Outputs a transcript of all KWP1281 blocks sent and received
 - Checks for errors whenever possible, during both transmit and receive
 - Reliably maintains a connection for long periods with modules tested

## Design

This project uses its own hardware based on a microcontroller.  It is not compatible with a "dumb" cable, "KKL" cable, or any commercial cable.  Please do not ask me to add support for any other cables.

When I started out on this project, I tried several "dumb" interfaces but found that communication was often unreliable due to timing problems, especially when transferring a lot of data or trying to communicate over long periods of time.  Here are some issues with "dumb" cables:

 - A module must be woken up with "slow init" by sending its address at a nonstandard baud rate (5 baud).  Since the computer must bit-bang the address byte when using a "dumb" cable, timing can be an issue.  The module may fail to recognize its address if any unexpected delays occur on the computer during bit-banging.

 - The protocol is designed for automatic baud rate detection.  After a module wakes up, it sends a sync byte (0x55) so that the receiver can measure its baud rate.  To detect the baud rate reliably, a timer with microsecond precision is needed.  This can't be done with a "dumb" cable so either the user has to pre-select a baud rate or various baud rates have to be blindly tried until one works.

 - Modules are sensitive to timing between bytes.  Once a connection is established, modules typically require a delay of one millisecond before each byte in a block is transmitted.  However, if the byte is delayed by too many milliseconds, the module may return "no acknowledge" or may abort the connection entirely.  Delays between the bytes caused by the computer's operating system multitasking or the USB to serial adapter can cause the KWP1281 connection to be unreliable when using a "dumb" cable.

This project uses a microcontroller to solve the above issues, which is how most commercial interfaces are implemented as well.  Again, please do not ask me to support other cables.

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

The tool has been tested successfully with over twenty different modules (mostly car radios).  It has been extensively tested with the the VW Premium 5 radio (Delco) and the VW Golf/Jetta Mk3 ABA 2.0L Motronic M5.9 ECU (Bosch).  It can maintain a connection reliably with these modules for hours.

## Pass-through Mode

Pass-through mode allows the host PC to directly control the K-line so that software written for "dumb" cables can be used with this interface.  Although I do not generally recommend this due to the issues with "dumb" cables noted above, the pass-through mode can be used if you need to run a piece of software that only supports "dumb" cables.

Enable the pass-through mode:

```
passthru_enable();
while(1);
```

In pass-through mode, the TXD and RXD of the onboard FT232RL are connected directly to the K-line via the L9637D.  The microcontroller's UARTs will still be able to receive data from the host PC and the K-line but they can't transmit to either.

Pass-through mode is also activated if the microcontroller is not installed or is held in reset.
