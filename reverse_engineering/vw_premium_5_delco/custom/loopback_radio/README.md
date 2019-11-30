# Serial Loopback (Radio Firmware)

This is a modification fo the "SOFTWARE 23" radio firmware.  The KWP1281 functionality has been completely
bypassed.  On reset, this firmware configures UART0 for 38400bps, 8N1.  While the radio performs its normal
functions, any bytes received on UART0 are received on interrupt and echoed back.
