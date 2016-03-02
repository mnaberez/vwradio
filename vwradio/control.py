import time
from vwradio import avrclient
from vwradio import faceplates


class Controller(object):
    def __init__(self, client, faceplate):
        self.client = client
        self.faceplate = faceplate

    def clear(self):
        self.client.faceplate_upd_clear_display()

    def read_keys(self):
        key_data = self.client.faceplate_upd_read_key_data()
        keys = self.faceplate.decode_keys(key_data)
        return keys

    def write(self, text, pos=0):
        char_codes = [ self.faceplate.char_code(c) for c in text ]
        self.write_char_codes(char_codes, pos)

    def write_char_codes(self, char_codes, pos=0):
        display_addresses = self.faceplate.DISPLAY_ADDRESSES

        if len(char_codes) > (len(display_addresses) - pos):
            raise ValueError("Data %r exceeds visible range from pos %d" %
                (char_codes, pos))

        # build dict of display data to write
        char_codes_by_address = {}
        for i, char_code in enumerate(char_codes):
            address = display_addresses[i + pos]
            char_codes_by_address[address] = char_code

        # find groups of contiguous addresses that need to be written
        addresses = char_codes_by_address.keys()
        address_groups = self._split_into_contiguous_groups(addresses)

        # send Data Setting command: write to display ram
        self.client.faceplate_upd_send_command([0x40])

        # send Address Setting command plus data for each contiguous group
        for addresses in address_groups:
            start_address = addresses[0]
            codes = [ char_codes_by_address[a] for a in addresses ]
            self.client.faceplate_upd_send_command([0x80 + start_address] + codes)

    def _split_into_contiguous_groups(self, integers):
        '''[2,1,7,6,5,10] -> [[1,2], [5,6,7], [10]]'''
        groups = []
        last = None
        for i in sorted(integers):
            if (last is not None) and (i == last + 1):
                groups[-1].append(i)
            else:
                groups.append([i])
            last = i
        return groups

    def define_char(self, index, data):
        if index not in range(16):
            raise ValueError("Character number %r is not 0-15", index)
        if len(data) != 7:
            raise ValueError("Character data length %r is not 7" % len(data))
        # Data Setting command: write to chargen ram
        self.client.faceplate_upd_send_command([0x4a])
        # Address Setting command, data
        self.client.faceplate_upd_send_command([0x80 + index] + list(data))


class Demonstrator(object):
    def __init__(self, controller):
        self.controller = controller

    def show_charset(self):
        for i in range(0, 0x100, 7):
            self.controller.write('0x%02X' % i, pos=0)
            data = [0x20] * 7 # 7 chars, default blank spaces
            for j in range(len(data)):
                code = i + j
                if code > 0xFF: # past end of charset
                    break
                data[j] = code
            self.controller.write_char_codes(data, pos=4)
            time.sleep(1)
        self.controller.clear()

    def show_rom_charset_comparison(self):
        def read_char_data(charset, index):
            start = i * 7
            end = start + 7
            return charset[start:end]

        for i in range(0x10, 0x100):
            # refine character 0 with the rom pattern
            data = read_char_data(self.controller.faceplate.ROM_CHARSET, i)
            self.controller.define_char(0, data)

            # first four chars: display character code in hex
            self.controller.write('0x%02X' % i, pos=0)

            # all other chars: alternate between rom and programmable char 0
            for blink in range(6):
                for code in (0, i):
                    self.controller.write_char_codes([code]*7, pos=4)
                    time.sleep(0.2)
        self.controller.clear()

    def show_keys(self):
        self.controller.clear()
        self.controller.write('Hit Key', pos=4)
        while True:
            keys = self.controller.read_keys()
            names = [ self.controller.faceplate.get_key_name(k) for k in keys ]
            if names:
                print("%r" % names)
                msg = names[0][:11].ljust(11)
                self.controller.write(msg)
        time.sleep(0.1)

    def clock(self):
        self.controller.clear()
        self.controller.write("Time", pos=0)
        while True:
            clock = time.strftime("%I:%M%p").lower()
            if clock[0] == '0':
                clock = ' ' + clock[1:]
            self.controller.write(clock, pos=4)
            time.sleep(0.5)


def main():
    client = avrclient.make_client()
    faceplate = faceplates.Premium4()
    try:
        client.pass_emulated_upd_display_to_faceplate(False)
        client.pass_faceplate_keys_to_emulated_upd(False)
        controller = Controller(client, faceplate)
        controller.clear()
        demo = Demonstrator(controller)
#        demo.clock()
        demo.show_charset()
#        demo.show_rom_charset_comparison()
#        demo.show_keys()
    except KeyboardInterrupt:
        # if a command is in process, let it finish
        time.sleep(0.1)
    finally:
        client.pass_emulated_upd_display_to_faceplate(True)
        client.pass_faceplate_keys_to_emulated_upd(True)


if __name__ == '__main__':
    main()
