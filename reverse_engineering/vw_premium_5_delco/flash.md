# Flash Programming

## Hardware

![Flash Connections](photos/flpr3-connections.jpg)

| FL-PR3 Probe  | uPD78F0831Y "N60 FLASH"  |
|---------------|--------------------------|
| SCK (White)   | Pin 48 P22/SCK31         |
| SO (Yellow)   | Pin 46 P20/SI31          | TODO verify me
| SI (Blue)     | Pin 47 P21/SO31          | TODO verify me
| RESET (Green) | Pin 64 /RESET            |
| VPP (Green)   | Pin 65 IC/VPP            |
| VDD (Red)     | Pin 69 VDD               |
| VSS (Black)   | Pin 27 VSS               |

Notes:

 - The 16181209 (16-pin SOIC package near the L9673D) must be temporarily
   desoldered during flash programming.

 - VSS (GND) can also be obtained by clipping onto pin 8 of the TA2025P
   (16-pin DIP package).

## FL-PR3 Settings

![FL-PR3 Connections](photos/flpr3-settings.png)

![FL-PR3 Signature](photos/flpr3-signature.png)
