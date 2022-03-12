# MFSW (Multi-Function Steering Wheel)

| Button     |Code|Complete Packet        |
|------------|----|-----------------------|
|Volume Down |0x00| 0x41  0xE8  0x00  0xFF|
|Volume Up   |0x80| 0x41  0xE8  0x80  0x7F|
|Down        |0x50| 0x41  0xE8  0x50  0xAF|
|Up          |0xD0| 0x41  0xE8  0xD0  0x2F|

All codes 0x00-0xFF were tried and only the ones listed above had any noticeable effect on the radio.

The "Up" and "Down" buttons perform the version of "seek" for each mode:

|Button| AM/FM Mode |  CD Mode   |Tape Mode |
|------|------------|------------|----------|
|Down  | Seek Down  | Track Down | MSS REW  |
|Up    | Seek Up    | Track Up   | MSS FF   |

In CD mode, "Track Down" works like the faceplate.  Pressing it once returns to 0:00 on the current track.  Pressing it again quickly performs track down.
