# Dump RAM

This is a small modification to the "SOFTWARE 23" firmware to aid in reverse engineering.  The reset vector has been changed so that on reset, a small routine dumps the contents of all RAM out the UART.  Reset then continues as it normally would.  A program running on the host computer (`monitor.py`) receives RAM dumps and displays them.  Differences between the current dump and the previous one are highlighted.

![Screenshot](https://user-images.githubusercontent.com/52712/46922830-c249f800-cfc3-11e8-93db-45d9a4579b3e.png)
