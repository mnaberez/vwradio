#!/usr/bin/env python
import struct
import serial # pyserial

CMD_SET_LED = 0x01
CMD_ECHO = 0x02
CMD_PASS_RADIO_COMMANDS_TO_EMULATED_UPD = 0x03
CMD_PASS_EMULATED_UPD_DISPLAY_TO_FACEPLATE = 0x04
CMD_PASS_FACEPLATE_KEYS_TO_EMULATED_UPD = 0x05
CMD_EMULATED_UPD_DUMP_STATE = 0x10
CMD_EMULATED_UPD_SEND_COMMAND = 0x11
CMD_EMULATED_UPD_RESET = 0x12
CMD_EMULATED_UPD_LOAD_KEY_DATA = 0x13
CMD_RADIO_STATE_PROCESS = 0x21
CMD_RADIO_STATE_DUMP = 0x22
CMD_RADIO_STATE_RESET = 0x23
CMD_FACEPLATE_UPD_DUMP_STATE = 0x30
CMD_FACEPLATE_UPD_SEND_COMMAND = 0x31
CMD_FACEPLATE_UPD_CLEAR_DISPLAY = 0x32
CMD_FACEPLATE_UPD_READ_KEY_DATA = 0x33
ACK = 0x06
NAK = 0x15
LED_GREEN = 0x00
LED_RED = 0x01
UPD_RAM_NONE = 0xFF
UPD_RAM_DISPLAY = 0
UPD_RAM_PICTOGRAPH = 1
UPD_RAM_CHARGEN = 2
UPD_DIRTY_NONE = 0
UPD_DIRTY_DISPLAY = 1<<UPD_RAM_DISPLAY
UPD_DIRTY_PICTOGRAPH = 1<<UPD_RAM_PICTOGRAPH
UPD_DIRTY_CHARGEN = 1<<UPD_RAM_CHARGEN

class Client(object):
    def __init__(self, ser):
        self.serial = ser

    # High level

    def echo(self, data):
        rx_bytes = self.command(bytearray([CMD_ECHO]) + bytearray(data))
        return rx_bytes[1:]

    def pass_radio_commands_to_emulated_upd(self, enabled):
        self.command([CMD_PASS_RADIO_COMMANDS_TO_EMULATED_UPD, int(enabled)])

    def pass_emulated_upd_display_to_faceplate(self, enabled):
        self.command([CMD_PASS_EMULATED_UPD_DISPLAY_TO_FACEPLATE, int(enabled)])

    def pass_faceplate_keys_to_emulated_upd(self, enabled):
        self.command([CMD_PASS_FACEPLATE_KEYS_TO_EMULATED_UPD, int(enabled)])

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

    def radio_state_process(self, display_ram):
        data = bytearray([CMD_RADIO_STATE_PROCESS]) + bytearray(display_ram)
        self.command(data)

    # Low level

    def command(self, data, ignore_nak=False):
        self._flush_rx() # discard rx if a previous command was interrupted
        self.send(data)
        return self.receive(ignore_nak)

    def send(self, data):
        self.serial.write(bytearray([len(data)] + list(data)))
        self._flush_tx()

    def receive(self, ignore_nak=False):
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

        # check ack/nak byte
        if rx_bytes[0] not in (ACK, NAK):
            raise Exception("Invalid: First byte not ACK/NAK: %r" % rx_bytes)
        elif (rx_bytes[0] == NAK) and (not ignore_nak):
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
        self.ram_area = data[0]
        self.ram_size = data[1]
        self.address = data[2]
        self.increment = bool(data[3])
        self.dirty_flags = data[4]
        self.display_ram = data[5:30]
        self.pictograph_ram = data[30:38]
        self.chargen_ram  = data[38:150]

    def __repr__(self):
        return '<%s: %s> ' % (self.__class__.__name__, repr(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


class RadioState(object):
    def __init__(self, data):
        assert len(data) == 30
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
        self.cd_cue_pos = (data[13] + (data[14] << 8))
        self.tuner_freq = (data[15] + (data[16] << 8))
        self.tuner_preset = data[17]
        self.tuner_band = data[18]
        self.display = data[19:30]

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
