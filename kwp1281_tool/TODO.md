## Block Title 0

In all radio firmware studied, block title 0 sends the same 0xF6 blocks that are sent during the initial connection.  Tomáš Kováčik found different behavior in his Audi instrument cluster (4B0919880G).  Block title 0 sends different information.

I observed in the log from Tomáš that the VAG Number sent during the initial connection has bit 7 of the first byte high.  If this byte is masked off, the VAG Number becomes correct (4B0919880G).  This bit may be a flag indicating that block title 0 will send different information.

 - Strip bit 7 when displaying VAG Number
 - Store flag or set message indicating more info is available
 - `_receive_all_ident_blocks()` should not overwrite VAG Number and Component
 - Investigate 0x54 ETX byte in Component, also not seen from other modules

```
CONNECT 97: 55 01 8A 75
RECV: 0F 01 F6 B4 42 30 39 31 39 38 38 30 47 20 20 03
PERFORM ACK
SEND: 03 02 09 03
RECV: 0F 03 F6 43 35 2D 4B 4F 4D 42 49 49 4E 53 54 03
PERFORM ACK
SEND: 03 04 09 03
RECV: 0E 05 F6 52 2E 20 56 44 4F 20 44 30 33 20 03
PERFORM ACK
SEND: 03 06 09 03
RECV: 08 07 F6 00 28 50 00 00 03
PERFORM ACK
SEND: 03 08 09 03
RECV: 03 09 09 03
VAG Number: "�B0919880G  "
Component:  "C5-KOMBIINSTR. VDO D03 ␃"
PERFORM READ IDENTIFICATION
SEND: 03 0A 00 03
RECV: 0F 0B F6 49 4D 4D 4F 2D 49 44 45 4E 54 4E 52 03
PERFORM ACK
SEND: 03 0C 09 03
RECV: 0F 0D F6 3A 20 41 55 5A 37 5A 30 57 30 33 35 03
PERFORM ACK
SEND: 03 0E 09 03
RECV: 0E 0F F6 39 39 36 30 20 20 20 20 20 20 20 03
PERFORM ACK
SEND: 03 10 09 03
RECV: 03 11 09 03
VAG Number: "IMMO-IDENTNR"
Component:  ": AUZ7Z0W0359960       ␃"
```
