# Serial Loopback (Radio Firmware)

This is a modification of the "SOFTWARE 23" radio firmware.  The KWP1281 functionality has been completely bypassed.  On reset, this firmware configures UART0 for 38400bps, 8N1.  While the radio performs its normal functions, any bytes received on UART0 are handled on interrupt and echoed back.

## Patches

Throughout the original firmware, any writes to the following have been `NOP`ed out to prevent them from interfering with the new UART0 operations.

 - `asim0`
 - `asis0`
 - `brgc0`
 - `rxb0_txs0`
 - `mk0h.1`
 - `mk0h.2`
 - `mk0h.3`
 - `pr0h.1`
 - `pr0h.2`
 - `pr0h.3`
 - `pm2.4`
 - `pm2.5`
 - `pu2.4`
 - `pu2.5`
 - `p2.4`
 - `p2.5`
 - `shadow_p2.5`

The old serial interrupt handlers have been bypassed and replaced with new routines:

 - `intser0_32df` → `irq_intser0`
 - `intsr0_30e8` → `irq_intsr0`
 - `intst0_307e` → `irq_intst0`

The reset vector has been changed to a new routine, `new_reset`, that sets up UART0 and then
jumps to the original reset code (`rst_d088`).

