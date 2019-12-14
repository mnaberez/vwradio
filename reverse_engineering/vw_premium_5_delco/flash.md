# Flash Programming

## Internal / External

| FL-PR3 Probe  | Connection                | Method               |
|---------------|---------------------------|----------------------|
| SCK (White)   | TODO CDC port CLK (Black) | Plug                 | TODO verify me
| SO (Yellow)   | TODO CDC port DI (Green)  | Plug                 | TODO verify me
| SI (Blue)     | TODO CDC port DO (Blue)   | Plug                 | TODO verify me
| VSS (Black)   | TODO CDC port GND (Black) | Plug                 |
| RESET (Green) | uPD78F0831Y Pin 64 /RESET | Solder               |
| VPP (Green)   | uPD78F0831Y Pin 65 IC/VPP | Solder               |
| VDD (Red)     | TDAxxxx Pin xx VDD        | Clip                 |

Internal / external requires:

 - Plugging into 4 connections on the CDC port (SCK, SO, SI, VSS)
 - Soldering 2 connections to vias or the uPD78F0831Y (RESET, VPP)
 - Clipping 1 connection on the TDAxxxx DIP package (VSS)
 - Does not require desoldering the HEFxxx chip

# Internal Only

| FL-PR3 Probe  | Connection                   | Method         |
|---------------|------------------------------|----------------|
| SCK (White)   | uPD78F0831Y Pin 48 P22/SCK31 | Solder         |
| SO (Yellow)   | uPD78F0831Y Pin 46 P20/SI31  | Solder         | TODO verify me internal
| SI (Blue)     | uPD78F0831Y Pin 47 P21/SO31  | Solder         | TODO verify me internal
| RESET (Green) | uPD78F0831Y Pin 64 /RESET    | Solder         |
| VPP (Green)   | uPD78F0831Y Pin 65 IC/VPP    | Solder         |
| VSS (Black)   | TDAxxxx Pin xx VSS           | Clip           | TODO TDA verify me
| VDD (Red)     | TDAxxxx Pin xx VDD           | Clip           | TODO TDA verify me

Internal only requires:

 - Soldering 5 connections to vias or the uPD78F0831Y (SCK, SO, SI, RESET, VPP)
 - Clipping 2 connections at the TDAxxxx DIP package (VSS, VDD)
 - Desoldering the HEFxxx chip

