# Parts

|Delco      | Actual          | Description                                       |
|----------|------------------|---------------------------------------------------|
|09370082 N60 FLASH | NEC uPD78F0831Y  | 78K0 Microcontroller similar to uPD78F0833Y *[1]*  |
|16246476  | Philips TEA6840H | New In Car Entertainment (NICE) Car Radio *[2]*     |
|16181209  | Philips HEF40106BT| Hex inverting Schmitt trigger *[3]*     |
|9355092   | ST M24C04        | 512 Byte I2C EEPROM *[4]*                           |

*Note 1*:
I had the 09370082 ("N60 FLASH") chip decapsulated and the part number "D78F0831Y" was marked on the die.  The '831Y is undocumented but there is a reference to it in the change history of the '833Y datasheet.  Also, there are '831Y device definition files for RA78K0 assembler package and the PG-FP3 flash programmer.  The FL-PR3 identifies it as D78F0831Y and can reprogram it.

*Note 2*:
I had the 16246476 chip decapsulated but there was no part number marked on the die.  Using many Philips datasheets, I suspected it was a TEA6840H after comparing the package size along with the power, ground, and crystal pins. I then installed a TEA6840H into the radio and it was fully functional.  I then had a TEA6840H chip decapsulated.  I compared those die photos to the photos of the 16246476 and they were the same.

*Note 3*:
In two radios, serial numbers VWZ4Z7X7040815 and VWZ4Z7X5050891, I found this chip with the real part number on the outside of the package (HEF40106BT).  All other radios I looked at had the Delco number on this chip.

*Note 4*:
M24C04 is a guess.  The EEPROM reads and writes in a device programmer as an M24C04.  In SOFTWARE23, the subroutine `sub_2cdf` checks that an EEPROM address for read or write is within 0x0000-0x01FF (512 bytes), which consistent with a M24C04.
