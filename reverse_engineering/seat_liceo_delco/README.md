# Seat Liceo (Delco)

![Photo](./photos/front.jpg)

The Seat Liceo is a single-disc CD radio for the European market manufactured by Delco.  The radio
uses an unknown NEC microcontroller with the 78K0 instruction set.

## Microcontroller

The microcontroller only has a Delco part number on the package and I have not decapsulated it,
so the exact part is unknown.  The firmware allows reading memory addresses 0x0000-EFDF via KWP1281.  This returns a large amount of data that disassembles cleanly as 78K0 machine code, but the microcontroller is likely not the NEC uPD78F0831Y like [Premium 5](../vw_premium_5_delco).  In the I/O address range of 0xFF00-FFFF, the Liceo firmware uses all the same locations as the Premium 5 firmware, and also these:

 - 0xFF71
 - 0xFF75
 - 0xFF7A
 - 0xFF7B
 - 0xFF84

Therefore, the microcontroller seems to be a superset of the '831Y.  Searching the NEC datasheets or the device definition files used by the NEC tools might help identify a match.
