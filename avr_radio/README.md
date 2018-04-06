# Faceplate Emulator

![Photo](https://user-images.githubusercontent.com/52712/38438414-51397070-398f-11e8-9e25-50ecb827c07f.jpg)

## Overview

This is an ATmega1284 project that emulates the faceplate of the Premium 4 radio, which is based on the NEC [µPD16432B](http://6502.org/documents/datasheets/nec/nec_upd16432b_2000_dec.pdf).  It plugs into the radio in place of the real faceplate and provides remote control of the radio over serial.  It can also simultaneously control the real faceplate ([man in the middle](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)).

Originally, I created the emulator as a way to [brute force](https://en.wikipedia.org/wiki/Brute-force_attack) the Premium 4 radio's security code.
I was going to set it up to try entering codes unattended.  I didn't end up using it for brute force.  Instead, I used it to [fuzz](https://en.wikipedia.org/wiki/Fuzzing) the key scan by sending all possible key codes for varying durations.  I found that the Premium 4 radio responds to keys not found on the normal faceplate.  Sending these keys allows the security code to be disabled or changed to a new code.  These keys were probably part of a special faceplate used during manufacturing.

I built two versions of this project: an external one (shown above) and one that was built entirely inside a Premium 4 radio.  After I had finished cracking, I was going to use the emulator to add new features to the radio.  I abandoned this effort to focus on the Premium 5 radio instead.  Unlike the Premium 4 which has its firmware in mask ROM, the Premium 5 stores its firmware in flash.  It can be reprogrammed instead of controlling it through the faceplate interface.

## Features

- Fully emulates µPD16432B display and key matrix scan
- Provides remote control of the Premium 4 radio over serial with a Python API
- Parses radio state from display (mode, tuner frequency, CD track, etc.)
- Simultaneously controls a real faceplate, either as pass-through or independently

## Design

The µPD16432B is an SPI peripheral.  Using the AVR's hardware SPI and careful programming, the AVR is able to emulate it even though the radio controls the SPI clock.  The radio continuously sends multi-byte SPI commands to update the display and scan the key matrix.  The AVR's hardware SPI receiver is used to receive each byte, which is handled by an interrupt service routine.  The radio is slow enough that the ISR has just enough time to do its work before the radio sends the next byte.  In the case of a key scan command, the ISR loads key data into the hardware SPI transmitter immediately.  For all other commands, the bytes are placed into a circular buffer.  Code in the main loop interprets commands from the buffer while the ISR continues to receive commands.

One of the AVR's two USARTs is used for a serial connection to a host computer.  A binary protocol is implemented where the host can send multi-byte requests and the AVR will respond with multi-byte responses.  Both transmit and receive are buffered and happen on  interrupt.  All commands are processed in the main loop.  Commands can read or change the state of the emulated µPD16432B.  The operating state of the radio (e.g. tuner frequency) is continuously parsed from the display data and can also be read on command.  

The other USART is used as an SPI master connected to a real faceplate.  By default, the behavior is pass-through.  Whenever the state of the emulated µPD16432B is changed, code running in the main loop sends an update to the real faceplate.  If pass-through is disabled, the real faceplate can be controlled by the host while the emulated µPD16432B independently controls the radio.

## Notes

This project could control other radios that use the µPD16432B, as long as the AVR is able to keep up with the SPI.  Since each radio has its own LCD layout and key matrix, those details would need to be implemented.
