# Serial Loopback (Polling)

On reset, this firmware configures the UART0 for 38400bps, 8N1.  It then sits in a polling loop and echoes back any bytes it receives.
