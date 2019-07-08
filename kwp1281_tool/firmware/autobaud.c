/*
 *                         Sync Byte (0x55)
 *
 *   Idle   Start  0   1   2   3   4   5   6   7  Stop     Idle
 *
 *   ------------+   +---+   +---+   +---+   +---+   +---------
 *               |   |   |   |   |   |   |   |   |   |
 *               |   |   |   |   |   |   |   |   |   |
 *               +---+   +---+   +---+   +---+   +---+
 *            0    1   0   1   0   1   0   1   0   1
 *
 *               |<->|
 *                 A = Negative edge to positive edge (1 bit)
 *
 *               |<----->|
 *                 B = Negative edge to negative edge (2 bits)
 *
 *         |<----------- Total (10 bits) ----------->|
 *
 *
 *              A          B            Total
 *  1200 baud   833.33 us  1666.66 us   8333.30 us
 *  2400 baud   416.67 us   833.34 us   4166.70 us
 *  4800 baud   208.33 us   416.66 us   2083.30 us
 *  9600 baud   104.17 us   208.34 us   1041.70 us
 * 10400 baud    96.15 us   192.30 us    961.50 us
 */
