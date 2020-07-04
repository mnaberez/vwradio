# Reverse Engineering

I studied the firmware for various radios with a focus on the On-Board Diagnostics (OBD) functionality.  All of the radios studied here communicate via the K-line using the KWP1281 protocol.  My primary interest has been to document the KWP1281 commands supported by each radio and to identify any hidden commands.  My secondary interest has been to understand how each radio implements the security lockout mechanism (the four digit "SAFE code") and to determine which radios have backdoors that allow them to be unlocked using KWP1281.

The radios studied here are over fifteen years old.  This repository contains notes about protocols and hardware, along with partial disassemblies of firmware.  It does not contain any original binaries of firmware or EEPROMs.

## Models

The [VW Premium 5](./vw_premium_5_delco) is special in the list of models below because it is the radio in my own car.  As such, I've done more reverse engineering work on it than most of the others.

| Radio                                 | Manufacturer | Market        | Firmware  | EEPROM | OBD Crack | Status   |
| ------                                | ------------ | ------        | ----      | ------ | --------- | -------- |
| [VW Premium 4](./vw_premium_4_clarion)| Clarion      | North America | ✓         | ✓      | ✓         | Done     |
| [VW Premium 5](./vw_premium_5_delco)  | Delco        | North America | ✓         | ✓      | ✓         | Done     |
| [VW SAM 2002](./vw_sam_2002_delco)    | Delco        | Europe        |           | ✓      | ✓         | In Progress |
| [Seat Liceo](./seat_liceo_delco)      | Delco        | Europe        | ✓         | ✓      | ✓         | Done     |
| [VW Gamma 5](./vw_gamma_5_sony)       | Sony         | Europe        |           |        |           | In Progress |
| [VW Gamma 5](./vw_gamma_5_technisat)  | TechniSat    | Europe        | ✓         | ✓      | ✓         | Done     |
| [VW Rhapsody](./vw_rhapsody_technisat)| TechniSat    | Europe        | ✓         | ✓      | ✓         | Done     |

Legend:

 - Firmware: The firmware has been extracted and partially disassembled to assembly language.  The KWP1281 commands supported have been documented.

 - EEPROM: The layout of the onboard EEPROM (usually a 93Cxx or 24Cxx) has been partially mapped, at least to the point where the locations containing the SAFE code are known.  The radio can be unlocked by reading its EEPROM contents.  Physically opening the radio is required.

 - OBD Crack: A method has been found to read the SAFE code of the radio via On-Board Diagnostics (the K-line).  This is usually via the KWP1281 protocol but not always.  The radio can be unlocked by sending the appropriate commands to it.  My [KWP1281 tool](../kwp1281_tool/README.md) can be used to unlock these radios.  Physically opening the radio is not required.
