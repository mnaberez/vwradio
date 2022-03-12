# MFSW (Multi-Function Steering Wheel)

| Button     |Code|Complete Packet        |
|------------|----|-----------------------|
|Volume Down |0x00| 0x82  0x17  0x00  0xFF|
|Volume Up   |0x01| 0x82  0x17  0x01  0xFE|
|Down        |0x0a| 0x82  0x17  0x0a  0xF5|
|Up          |0x0b| 0x82  0x17  0x0b  0xF4|

All codes 0x00-0xFF were tried and only the ones listed above had any noticeable effect on the radio.

The "Up" and "Down" buttons perform the version of "seek" for each mode:

|Button| AM/FM Mode |  CD Mode   |Tape Mode |
|------|------------|------------|----------|
|Down  | Seek Down  | Track Down | MSS REW  |
|Up    | Seek Up    | Track Up   | MSS FF   |

In CD mode, "Track Down" works like the faceplate.  Pressing it once returns to 0:00 on the current track.  Pressing it again quickly performs track down.
