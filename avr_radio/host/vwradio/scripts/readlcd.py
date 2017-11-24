#!/usr/bin/env python3 -u
import sys
from vwradio.avrclient import make_client

client = make_client()
ser = client.serial

while True:
    text = client.read_lcd()
    sys.stdout.write("\r" + text)
    sys.stdout.flush()
