# EPROM

The EEPROM is marked with Delco part number 9355092 but it is actually an ST M24C04 (512 bytes).

0x0014 SAFE code BCD, high byte
0x0015 SAFE code BCD, low byte
  ...
0x0058 mem_f1f9 Soft coding in binary, high byte
0x0059 mem_f1fa Soft coding in binary, low byte
0x005a mem_f1fb Workshop code, high byte
0x005b mem_f1fc Workshop code, low byte
0x005c mem_f1fd Coding related(?)
0x005d mem_f1fe Coding related(?)
0x005e mem_f1ff Coding related(?)
0x005f mem_f200 Coding related(?)
0x0060 mem_f201 Coding related(?)
0x0061          Calculation based on contents of 0x0058-0x0060
0x0062          Calculation based on contents of 0x0058-0x0061
