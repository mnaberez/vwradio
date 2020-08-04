# Serial Loopback (Interrupts)

On reset, this firmware configures the UART0 for 38400bps, 8N1.  It then sits in a loop doing nothing while any bytes received are echoed back on interrupt.
