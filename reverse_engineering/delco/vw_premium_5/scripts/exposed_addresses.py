#!/usr/bin/env python3
#
# Print the range of accessible addresses around each address in the 
# exposed_addresses table, then combine them to print all contiguous
# areas in memory that can be accessed.
#

# address words in the exposed_addresses table at 0xB190 in software23.asm
exposed_addresses = sorted(set([
    0xB190,
    0xB1B5,
    0xAF70,
    0xAF70,
    0xFE30,
    0xAF70,
    0xFB56,
    0xF225,
    0xFE57,
    0xF257,
    0xFE43,
    0xFBAC,
    0xF1B3,
    0xAF70,
    0xF1B9,
    0xFE4C,
    0xFE44,
    0xFC75,
]))

# find all accessible addresses around each exposed address 
# and mark them as exposed in the 64K memory space
memory = [False] * 65536
for exposed_address in exposed_addresses:
    lowest_address = exposed_address - 128
    highest_address = exposed_address + 127

    print("%04X: %04X - %04X" % (exposed_address, lowest_address, highest_address))

    for address in range(lowest_address, highest_address+1, 1):
        memory[address] = True # exposed
print()

# find all contiguous areas in memory that can be accessed
ranges = []
current_range = None
for address, exposed in enumerate(memory):
    if exposed:
        if current_range is None:
            current_range = [address, address] # low, high 
            ranges.append(current_range)
        else:
            current_range[1] = address
    else:
        current_range = None 

for r in ranges:
    print("%04X - %04X" % (r[0], r[1]))
