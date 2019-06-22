# Fault Codes

This is a modification of the "SOFTWARE 23" firmware that is used for testing
a scan tool's ability to retrieve fault codes over KWP1281.  Each time faults
are queried, four new fault codes are returned (in ascending order).  A fault
code is a 16-bit number.  If faults are queried enough times, it will wrap
around.  See the code at the bottom of the assembly listing for the changes.
