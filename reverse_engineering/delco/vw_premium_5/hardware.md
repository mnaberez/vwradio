# uPD78F0831Y ("N60 FLASH")

| Pin   | Name        | Usage                                         |
|-------|-------------|-----------------------------------------------|
|Pin  1 |P70/PCL      |Unknown input/output                           |
|Pin  2 |P71/SDA0     |I2C SDA (see i2c.md file)                      |
|Pin  3 |P72/SCL0     |I2C SCL (see i2c.md file)                      |
|Pin  4 |P73/TO01     |Unknown input/output                           |
|Pin  5 |P74/TI001    |Unknown input/output                           |
|Pin  6 |P75/TI011    |Unknown input                                  |
|Pin  7 |P00/INTP0    |INTP0: MFSW (inverted)                         |
|Pin  8 |P01/INTP1    |INTP1: Unknown input                           |
|Pin  9 |P02/INTP2    |INTP2: Unknown input                           |
|Pin 10 |P03/INTP3    |Unknown input (not used as INTP3)              |
|Pin 12 |P80/ANI01    |Unknown output (some kind of 12V power control)|
|Pin 13 |P81/ANI11    |Unknown output                                 |
|Pin 14 |P82/ANI21    |Monsoon amplifier power 12V out (0=off, 1=on)  |
|Pin 15 |P83/ANI31    |Unknown input                                  |
|Pin 16 |P84/ANI41    |Unknown input                                  |
|Pin 17 |P85/ANI51    |Unknown input                                  |
|Pin 18 |P86/ANI61    |Unknown input                                  |
|Pin 19 |P87/ANI71    |Unknown input/output                           |
|Pin 21 |P40          |Unknown input                                  |
|Pin 22 |P41          |Unknown input                                  |
|Pin 23 |P42          |Unknown input                                  |
|Pin 24 |P43          |Unknown output                                 |
|Pin 25 |P44          |FIS ENA out                                    |
|Pin 26 |P45          |Unknown input                                  |
|Pin 27 |P46          |uPD16432B /LCDOFF                              |
|Pin 28 |P47          |uPD16432B STB                                  |
|Pin 29 |P30/SI30     |uPD16432B DAT in                               |
|Pin 30 |P31/SO30     |uPD16432B DAT out                              |
|Pin 31 |P32/SCK30    |uPD16432B CLK                                  |
|Pin 33 |P33          |Alarm LED                                      |
|Pin 34 |P34/TO00     |Unknown output                                 |
|Pin 35 |P35/TI000    |Unknown input                                  |
|Pin 36 |P36/TI010    |Unknown input/output                           |
|Pin 37 |PTI010       |                                               |
|Pin 38 |P50          |                                               |
|Pin 39 |P51          |                                               |
|Pin 40 |P52          |                                               |
|Pin 41 |P53          |                                               |
|Pin 42 |P54          |                                               |
|Pin 43 |P55          |                                               |
|Pin 44 |P56          |                                               |
|Pin 45 |P57          |CDC DO (TODO inverted or not?)                 |
|Pin 46 |P20/SI31     |CDC DI (inverted)                              |
|Pin 47 |P21/SO31     |                                               |
|Pin 48 |P22/SCK31    |CDC CLK (inverted)                             |
|Pin 49 |P04/INTP4    |INTP4: POWER key (0=pressed)                   |
|Pin 50 |P05/INTP5    |uPD16432B KEYREQ (not used in firmware)        |
|Pin 51 |P06/INTP6    |INTP6: STOP/EJECT key (0=pressed)              |
|Pin 52 |P07/INTP7    |INTP7: Unknown input                           |
|Pin 53 |P23          |Tape METAL sense (1=metal)                     |
|Pin 54 |P24/RxD0     |L9637D RX (K-line)                             |
|Pin 55 |P25/TxD0     |L9637D TX (K-line)                             |
|Pin 56 |P26          |K-line resistor (0=disconnected, 1=connected)  |
|Pin 57 |P27/TI51/TO51|Unknown output                                 |
|Pin 72 |P90/ANI00    |Unknown input                                  |
|Pin 73 |P91/ANI10    |Unknown input (used as analog; mem_fca2)       |
|Pin 74 |P92/ANI20    |Illumination analog input (0=off, 0xff=full)   |
|Pin 75 |P93/ANI30    |Unknown input                                  |
|Pin 76 |P94/ANI40    |Unknown output                                 |
|Pin 77 |P95/ANI50    |Unknown input (used as analog; mem_fca4)       |
|Pin 78 |P96/ANI60    |Unknown input                                  |
|Pin 79 |P97/ANI70    |Unknown output                                 |

Operation of the S-contact:
  When the key is not inserted or has been inserted but not turned,
  the S-contact is off.  When the key is turned one click to the
  accessory position, the S-contact turns on it.  It will remain on
  if the key is turned again to the ignition position.  Once the
  S-contact is turned on, it will remain on until the key is removed
  from the ignition, even if the key is turned all the way back.
