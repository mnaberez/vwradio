import sys
from serialtest import make_client
ser = make_client().serial

while True:
    numbytes = ser.in_waiting
    if numbytes:
        sys.stdout.write(ser.read(numbytes))
        sys.stdout.flush()
