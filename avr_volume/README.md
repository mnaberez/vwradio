# M62419FP Monitor

![Photo](https://user-images.githubusercontent.com/52712/38273422-bed866be-3740-11e8-880b-c5b14daa2f4f.png)

This is an ATmega1284 project that passively monitors SPI commands sent to a Mitsubishi [M62419FP](https://web.archive.org/web/20180403231443/https://www.renesas.com/en-us/doc/products/assp/rej03f0207_m62419fpds.pdf) sound controller, which is used in the Premium 4 radio.  As SPI commands are sent to the M62419FP, the AVR receives them and tracks what should be the state of the M62419FP internal registers.  It then sends that data out its UART to a host computer.

A small Python script runs on the host computer and continuously displays the current state of the M62419FP.  As the user turns the volume knob on the Premium 4 radio or changes the fade or balance, the Python script updates its display.  Note that the Premium 4 does not use the bass or treble registers of the M62419FP.  This project will track changes to those registers but they will always show as 0 with the Premium 4.
