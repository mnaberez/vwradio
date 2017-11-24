import struct
import time
import serial # pyserial

CMD_SET_LED = 0x01
CMD_ECHO = 0x02
CMD_SET_RUN_MODE = 0x03
CMD_SET_AUTO_DISPLAY_PASSTHRU = 0x04
CMD_SET_AUTO_KEY_PASSTHRU = 0x05
CMD_EMULATED_UPD_DUMP_STATE = 0x10
CMD_EMULATED_UPD_SEND_COMMAND = 0x11
CMD_EMULATED_UPD_RESET = 0x12
CMD_EMULATED_UPD_LOAD_KEY_DATA = 0x13
CMD_FACEPLATE_UPD_DUMP_STATE =  0x20
CMD_FACEPLATE_UPD_SEND_COMMAND = 0x21
CMD_FACEPLATE_UPD_CLEAR_DISPLAY = 0x22
CMD_FACEPLATE_UPD_READ_KEY_DATA = 0x23
CMD_RADIO_STATE_DUMP = 0x30
CMD_RADIO_STATE_PARSE = 0x31
CMD_RADIO_STATE_RESET = 0x32
CMD_CONVERT_UPD_KEY_DATA_TO_CODES = 0x40
CMD_CONVERT_CODE_TO_UPD_KEY_DATA = 0x41
CMD_CONVERT_UPD_PICTOGRAPH_DATA_TO_CODES = 0x42
CMD_CONVERT_CODE_TO_UPD_PICTOGRAPH_DATA = 0x43
CMD_READ_KEYS = 0x44
CMD_LOAD_KEYS = 0x45

ERROR_OK = 0x00
ERROR_NO_COMMAND = 0x01
ERROR_BAD_COMMAND = 0x02
ERROR_BAD_ARGS_LENGTH = 0x03
ERROR_BAD_ARGS_VALUE = 0x04
ERROR_BLOCKED_BY_PASSTHRU = 0x05

RUN_MODE_STOPPED = 0
RUN_MODE_RUNNING = 1

LED_GREEN = 0x00
LED_RED = 0x01

UPD_RAM_NONE = 0xFF
UPD_RAM_DISPLAY = 0
UPD_RAM_PICTOGRAPH = 1
UPD_RAM_CHARGEN = 2
UPD_RAM_LED = 3
UPD_DIRTY_NONE = 0
UPD_DIRTY_DISPLAY = 1<<UPD_RAM_DISPLAY
UPD_DIRTY_PICTOGRAPH = 1<<UPD_RAM_PICTOGRAPH
UPD_DIRTY_CHARGEN = 1<<UPD_RAM_CHARGEN
UPD_DIRTY_LED = 1<<UPD_RAM_LED


class Client(object):
    def __init__(self, ser):
        self.serial = ser

    # High level ==============================================================

    def echo(self, data):
        rx_bytes = self.command(bytearray([CMD_ECHO]) + bytearray(data))
        return rx_bytes[1:]

    def set_run_mode(self, mode):
        self.command([CMD_SET_RUN_MODE, int(mode)])

    def set_auto_display_passthru(self, enabled):
        self.command([CMD_SET_AUTO_DISPLAY_PASSTHRU, int(enabled)])

    def set_auto_key_passthru(self, enabled):
        self.command([CMD_SET_AUTO_KEY_PASSTHRU, int(enabled)])

    def set_led(self, led_num, led_state):
        self.command([CMD_SET_LED, led_num, int(led_state)])

    def emulated_upd_reset(self):
        self.command([CMD_EMULATED_UPD_RESET])

    def emulated_upd_dump_state(self):
        data = self.command([CMD_EMULATED_UPD_DUMP_STATE])
        return UpdEmulatorState(data[1:])

    def emulated_upd_send_command(self, spi_bytes):
        data = bytearray([CMD_EMULATED_UPD_SEND_COMMAND]) + bytearray(spi_bytes)
        self.command(data)

    def emulated_upd_load_key_data(self, key_bytes):
        data = bytearray([CMD_EMULATED_UPD_LOAD_KEY_DATA]) + bytearray(key_bytes)
        self.command(data)

    def faceplate_upd_send_command(self, spi_bytes):
        data = bytearray([CMD_FACEPLATE_UPD_SEND_COMMAND]) + bytearray(spi_bytes)
        self.command(data)

    def faceplate_upd_dump_state(self):
        data = self.command([CMD_FACEPLATE_UPD_DUMP_STATE])
        return UpdEmulatorState(data[1:])

    def faceplate_upd_clear_display(self):
        self.command([CMD_FACEPLATE_UPD_CLEAR_DISPLAY])

    def faceplate_upd_read_key_data(self):
        data = self.command([CMD_FACEPLATE_UPD_READ_KEY_DATA])
        return data[1:]

    def radio_state_reset(self):
        self.command([CMD_RADIO_STATE_RESET])

    def radio_state_dump(self):
        data = self.command([CMD_RADIO_STATE_DUMP])
        return RadioState(data[1:])

    def radio_state_parse(self, display):
        data = bytearray([CMD_RADIO_STATE_PARSE]) + bytearray(display)
        self.command(data)

    def convert_upd_key_data_to_codes(self, key_data):
        data = (bytearray([CMD_CONVERT_UPD_KEY_DATA_TO_CODES]) +
                bytearray(key_data))
        rx_bytes = self.command(data)
        num_keys_pressed = rx_bytes[1]
        return list(rx_bytes[2:2+num_keys_pressed])

    def convert_code_to_upd_key_data(self, key_code):
        rx_bytes = self.command([CMD_CONVERT_CODE_TO_UPD_KEY_DATA, key_code])
        return list(rx_bytes[1:])

    def convert_upd_pictograph_data_to_codes(self, pictograph_data):
        data = (bytearray([CMD_CONVERT_UPD_PICTOGRAPH_DATA_TO_CODES]) +
                bytearray(pictograph_data))
        rx_bytes = self.command(data)
        num_pictographs_displayed = rx_bytes[1]
        return list(rx_bytes[2:2+num_pictographs_displayed])

    def convert_code_to_upd_pictograph_data(self, pictograph_code):
        rx_bytes = self.command([CMD_CONVERT_CODE_TO_UPD_PICTOGRAPH_DATA, pictograph_code])
        return list(rx_bytes[1:])

    def read_keys(self):
        '''Read keys pressed on the real faceplate and return a list of
        key codes (KEY_ constants).  If no keys are pressed, the list will
        be empty.  At most 2 keys can be pressed at once, so up to 2 key
        codes may be returned.'''
        rx_bytes = self.command([CMD_READ_KEYS])
        num_keys_pressed = rx_bytes[1]
        return list(rx_bytes[2:2+num_keys_pressed])

    def load_keys(self, key_codes):
        '''send key presses to the radio'''
        count = len(key_codes)
        data = [CMD_LOAD_KEYS, count, 0, 0]
        if count > 0:
            data[2] = key_codes[0]
        if count > 1:
            data[3] = key_codes[1]
        if count > 2:
            raise ValueError(
                'Tried to press %d keys, but only 0, 1, or 2 keys '
                'can be pressed at once' % count
                )
        self.command(data)

    def hit_key(self, key, secs=0.15):
        '''TODO implement this on the AVR side instead'''
        self.load_keys([key]) # hit key
        time.sleep(secs)
        self.load_keys([]) # release all keys
        time.sleep(secs)

    def read_lcd(self):
        '''TODO implement this on the AVR side instead'''
        from vwradio.faceplates import Premium4 # XXX hack, premium 4 only
        faceplate = Premium4()
        display_ram = self.emulated_upd_dump_state().display_ram
        text = ''

        for addr in faceplate.VISIBLE_DISPLAY_ADDRESSES:
            char_code = display_ram[addr]
            char = faceplate.CHARACTERS[char_code]
            text += char
        return text

    # Low level ===============================================================

    def command(self, data, ignore_error=False):
        self._flush_rx() # discard rx if a previous command was interrupted
        self.send(data)
        return self.receive(ignore_error)

    def send(self, data):
        self.serial.write(bytearray([len(data)] + list(data)))
        self._flush_tx()

    def receive(self, ignore_error=False):
        # read number of bytes to expect
        head = self.serial.read(1)
        if len(head) == 0:
            raise Exception("Timeout: No reply header byte received")
        expected_num_bytes = ord(head)

        # read bytes expected, or more if available
        num_bytes_to_read = expected_num_bytes
        if self.serial.in_waiting > num_bytes_to_read: # unexpected extra data
            num_bytes_to_read = self.serial.in_waiting
        rx_bytes = bytearray(self.serial.read(num_bytes_to_read))

        # sanity checks on reply length
        if len(rx_bytes) < expected_num_bytes:
            raise Exception(
                "Timeout: Expected reply of %d bytes, got only %d bytes: %r" %
                (expected_num_bytes, len(rx_bytes), rx_bytes)
                )
        elif len(rx_bytes) > expected_num_bytes:
            raise Exception(
                "Invalid: Too long: expected %d bytes, got %d bytes: %r " %
                (expected_num_bytes, len(rx_bytes), rx_bytes)
            )
        elif len(rx_bytes) == 0:
            raise Exception("Invalid: Reply had header byte but not ack/nak")

        # check error code byte
        if (rx_bytes[0] != ERROR_OK) and (not ignore_error):
            raise Exception("Received NAK response: %r" % rx_bytes)

        return rx_bytes

    def _flush_rx(self):
        num_bytes = self.serial.in_waiting
        if num_bytes:
            self.serial.read(num_bytes)

    def _flush_tx(self):
        self.serial.flush()


class UpdEmulatorState(object):
    def __init__(self, data):
        assert len(data) == 151
        self.ram_area = data[0]
        self.ram_size = data[1]
        self.address = data[2]
        self.increment = bool(data[3])
        self.dirty_flags = data[4]
        self.display_ram = data[5:30]
        self.pictograph_ram = data[30:38]
        self.chargen_ram = data[38:150]
        self.led_ram = data[150:151]

    def __repr__(self):
        return '<%s: %s> ' % (self.__class__.__name__, repr(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


class RadioState(object):
    def __init__(self, data):
        assert len(data) == 52
        self.operation_mode = data[0]
        self.display_mode = data[1]
        self.safe_tries = data[2]
        self.safe_code = (data[3] + (data[4] << 8))
        self.sound_bass =     struct.unpack('b', bytearray([data[5]]))[0]
        self.sound_treble =   struct.unpack('b', bytearray([data[6]]))[0]
        self.sound_midrange = struct.unpack('b', bytearray([data[7]]))[0]
        self.sound_balance =  struct.unpack('b', bytearray([data[8]]))[0]
        self.sound_fade =     struct.unpack('b', bytearray([data[9]]))[0]
        self.tape_side = data[10]
        self.cd_disc = data[11]
        self.cd_track = data[12]
        self.cd_track_pos = (data[13] + (data[14] << 8))
        self.tuner_freq = (data[15] + (data[16] << 8))
        self.tuner_preset = data[17]
        self.tuner_band = data[18]
        self.display = data[19:30]
        self.option_on_vol = data[30]
        self.option_cd_mix = data[31]
        self.option_tape_skip = data[32]
        self.test_fern = data[33]
        self.test_rad = data[34:41]
        self.test_ver = data[41:48]
        self.test_signal_freq = (data[48] + (data[49] << 8))
        self.test_signal_strength = (data[50] + (data[51] << 8))

    def __repr__(self):
        return '<%s: %s> ' % (self.__class__.__name__, repr(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


def make_serial():
    from serial.tools.list_ports import comports
    names = [ x.device for x in comports() if 'Bluetooth' not in x.device ]
    if not names:
        raise Exception("No serial port found")
    return serial.Serial(port=names[0], baudrate=115200, timeout=2)

def make_client(serial=None):
    if serial is None:
        serial = make_serial()
    return Client(serial)
