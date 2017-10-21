import sys

filenames = sys.argv[1:3]

class Entry(object):
    time = None
    txrx = None
    byte = None
    comment = None
    reflection = False

    def __repr__(self):
        return "<Entry %0.06f %s 0x%02x>" % (self.time, self.txrx, self.byte)

    @property
    def source(self):
        if self.txrx == 'TX':
            return 'TX (RADIO)'
        elif self.txrx == 'RX':
            return 'RX (TESTER) '
        else:
            return self.txrx

class Directions(object):
    RADIO_AS_MASTER = 0
    TESTER_AS_MASTER = 1

class States(object):
    READING_BLOCK_LENGTH = 0
    READING_BLOCK_COUNTER = 1
    READING_BLOCK_TITLE = 2
    READING_BLOCK_DATA = 3
    READING_BLOCK_END = 4

BlockTitles = {
    0x04: "Actuator/Output Test",
    0x05: "Clear Faults",
    0x06: "End Session",
    0x07: "Read Faults",
    0x08: "Single Reading",         # always NAKs
    0x09: "Acknowlege",
    0x0A: "No Acknowledge",
    0x10: "Recoding",
    0x21: "Adaptation",             # always NAKs
    0x28: "Basic Setting",          # always NAKs
    0x29: "Group Reading",
    0x2B: "Login",

    0xE7: "Response to Group Reading",
    0xF0: "Response to Login",
    0xF5: "Response to Actuator/Output Tests",
    0xF6: "Response with ASCII Data/ID code",
    0xFC: "Response to Read Faults",
}


# parse files into entries
entries = []
for filename in filenames:
    with open(filename) as f:
        for line in f.readlines()[1:]:
            if "error" not in line.lower():
                cols = line.split(",")
                entry = Entry()
                entry.time = float(cols[0])
                entry.txrx = cols[1]
                entry.byte = int(cols[2], 16)
                entries.append(entry)
entries = sorted(entries, key=lambda entry: entry.time)

# detection and remove rx bytes that are reflections of tx bytes
last_entry = None
for i, entry in enumerate(entries):
    if i > 0:
        assert entry.time >= last_entry.time
        if (entry.time - last_entry.time) < 0.0001:
            if (entry.txrx == 'RX') and (entry.txrx != last_entry.txrx):
                if entry.byte == last_entry.byte:
                    entry.reflection = True
    last_entry = entry
entries = list(filter(lambda e: not e.reflection, entries))

# find the sync sequence
sync_index = None
for i, entry in enumerate(entries):
    seq = map(lambda e: (e.txrx, e.byte), entries[i:i+4])
    if seq == [('TX', 0x55), ('TX', 0x01), ('TX', 0x8a), ('RX', 0x75)]:
        sync_index = i
        break
if sync_index is None:
    raise Exception("sync not found")

blocks_start_index = sync_index + 4
direction = Directions.RADIO_AS_MASTER

state = States.READING_BLOCK_LENGTH

blocks = []
current_block = []

block_length = None
block_bytes_received = 0

i = blocks_start_index
while i < len(entries):
    entry = entries[i]
    current_block.append(entry)

    if state == States.READING_BLOCK_LENGTH:
        entry.comment = "Block length"
        state = States.READING_BLOCK_COUNTER
        block_length = entry.byte
        block_bytes_received = 1
        i += 2
    elif state == States.READING_BLOCK_COUNTER:
        entry.comment = "Block counter"
        state = States.READING_BLOCK_TITLE
        block_bytes_received += 1
        i += 2
    elif state == States.READING_BLOCK_TITLE:
        entry.comment = "Block title (%s)" % BlockTitles.get(entry.byte, "???")
        state = States.READING_BLOCK_DATA
        block_bytes_received += 1
        if block_bytes_received == block_length:
            state = States.READING_BLOCK_END
        i += 2
    elif state == States.READING_BLOCK_DATA:
        if (entry.byte >= ord(' ')) and (entry.byte <= ord('z')):
            entry.comment = repr(chr(entry.byte))
        block_bytes_received += 1
        if block_bytes_received == block_length:
            state = States.READING_BLOCK_END
        i += 2
    elif state == States.READING_BLOCK_END:
        entry.comment = "Block end"
        blocks.append((direction, current_block,))
        current_block = []

        i += 1
        state = States.READING_BLOCK_LENGTH
        if direction == Directions.RADIO_AS_MASTER:
            direction = Directions.TESTER_AS_MASTER
        else:
            direction = Directions.RADIO_AS_MASTER


for direction, entries in blocks:
    if direction == Directions.RADIO_AS_MASTER:
        print("\nRadio -> TESTER\n")
    else:
        print("\nTESTER -> Radio\n")

    last_block_counter = None

    for i, entry in enumerate(entries):
        line = "%00.012f, %s, 0x%02X" % (entry.time, entry.source, entry.byte,)
        if entry.comment is not None:
            line += ' %s' % entry.comment

        print line
