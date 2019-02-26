# Reverse Engineering

I studied the firmware for various radios with a focus on the On-Board Diagnostics (OBD) functionality.  All of the radios studied here communicate via the K-line using the KWP1281 protocol.  My primary interest has been to document the KWP1281 commands supported by each radio and to identify any hidden commands.

A special case is the [VW Premium 5](./vw_premium_5_delco) radio made by Delco.  This is the radio in my own car so I have spent
more time with it than the others.  I have also developed some custom firmware for it.

## Models

| Radio                                 | Manufacturer | Market        | ROM  | EEPROM | OBD Crack   | Status   |
| ------                                | ------------ | ------        | ---- | ------ | --------- | -------- |
| [VW Premium 4](./vw_premium_4_clarion)| Clarion      | North America | Yes  | Yes    | Yes     | Done     |
| [VW Premium 5](./vw_premium_5_delco)  | Delco        | North America | Yes  | Yes    | Yes     | Done     |
| [VW Gamma 5](./vw_gamma_5_technisat)  | Technisat    | Europe        | Yes  | Yes    | Yes     | Done     |
| [VW Rhapsody](./vw_rhapsody_technisat)| Technisat    | Europe        | Yes  | Yes    | Yes     | Done     |
| [Seat Liceo](./seat_liceo_delco)      | Delco        | Europe        | No   | Yes    | Yes     | Done     |

Legend:

 - ROM: The firmware has been extracted from the radio and at least partially disassembled to assembly language.  The KWP1281 commands supported by the radio have been documented.

 - EEPROM: The layout of the onboard EEPROM (usually a 93Cxx or 24Cxx) has been partially mapped, at least to the point where the locations containing the SAFE code are known.  The radio can be unlocked by reading its EEPROM contents.  Physically opening the radio is required.

 - OBD Crack: A method has been found to read the SAFE code of the radio via On-Board Diagnostics (the K-line).  This is usually via the KWP1281 protocol but not always.  The radio can be unlocked by sending the appropriate commands to it.  Physically opening the radio is not required.
