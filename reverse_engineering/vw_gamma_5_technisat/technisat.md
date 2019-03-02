# TechniSat Protocol

On address 0x7C, the radio supports a proprietary protocol used for manufacturing test.

## Slow Init

After sending address 0x7c at 5 baud, the radio does not send the usual 55 01 8A, instead it sends these unknown 5 bytes:

```text
10 01 5E 00 90
            ^^ looks like (sum of previous 4 bytes)^0xff
```

After addressing the radio once on 0x7C, it will not send the
sequence again unless it is power cycled or the volume knob
is pushed twice (once to turn off, once again to turn back on).
