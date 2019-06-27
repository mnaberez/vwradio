# VW Rhapsody (TechniSat)

The VW Rhapsody is a single-disc CD radio for the European market manufactured by TechniSat.  It was very likely
derived from an earlier TechniSat cassette radio, the [Gamma 5](../vw_gamma_5_technisat).  Both have similar PCB layouts
and use the Renesas (Mitsubishi) [M38869FFAHP](http://archive.6502.org/datasheets/renesas_3886_group_users_manual.pdf) microcontroller.

## Firmware

Since the M38869FFAHP has no code protection, the firmware can be dumped by several hardware methods that are documented in the datasheet.  One of these modes allows the M38869FFAHP to read like an M5M28F101 flash memory.  I used this method (see the notes for the Gamma 5).  Unlike Gamma 5, I have not found a way to dump the Rhapsody firmware via the K-line.  Desoldering the microcontroller is the only way I know to dump it.

## KWP1281 Protocol

The Rhapsody firmware is generally quite similar to the Gamma 5, but the KWP1281 commands have been reduced.  Several protected KWP1281 commands that are supported on Gamma 5 have been changed to unconditionally return NAK on Rhapsody.  Notably, Gamma 5 supports reading memory (including the firmware) via KWP1281 but the data returned is encrypted.  Rhapsody doesn't allow reading memory at all.

Rhapsody has an interesting KWP1281 bug not found in the Gamma 5.  The Gamma 5, and all other radios I've studied, always return consecutive block counter numbers for the entire session.  Rhapsody usually does this, but not always.  It sometimes returns a block counter out of sequence.  An earlier version of my KWP1281 tool didn't like this, so I changed it to be more forgiving about the block counter.  I found that a commercial scan tool communicates fine with the Rhapsody, so perhaps other modules have this behavior as well.

## TechniSat Protocol

Rhapsody supports the special "TechniSat Protocol" on address 0x7C that I discovered on the Gamma 5.  However, TechniSat changed it so it is less easily discovered.  After receiving the 5 baud init, Gamma 5 will enter the TechniSat protocol mode and will immediately send a "hello" message.  Rhapsody does not do this.  After receiving the 5 baud init, Rhapsody enters the TechniSat protocol mode but does not send any response.  The scan tool must send a "hello"
message to the Rhapsody before it will respond.  Otherwise, the TechniSat protocol works the same as Gamma 5.  The exact command sequence used to retrieve the SAFE code on Gamma 5 also works for Rhapsody.
