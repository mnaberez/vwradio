#!/bin/bash
avrdude -c avrisp2 -p m1284p -U flash:w:led.hex
