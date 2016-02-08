#!/usr/bin/env python
import time
import serial # pyserial

CMD_SET_LED = 0x01
LED_GREEN = 0x00
LED_RED = 0x01
ACK = 0x06
NAK = 0x15

class Client(object):
    def __init__(self, ser):
        self.serial = ser

    def send_command(self, data):
        num_bytes = len(data)
        self.serial.write(bytearray([num_bytes]))
        self.serial.write(bytearray(data))
        self.serial.flush()
        num_bytes = ord(self.serial.read(1))
        rx_bytes = bytearray(self.serial.read(num_bytes))
        if rx_bytes[0] != ACK:
            raise Exception("Bad response: %r" % rx_bytes)
        if len(rx_bytes) != num_bytes:
            raise Exception("Timeout")
        return rx_bytes

    def set_led(self, led_num, led_state):
        self.send_command([CMD_SET_LED, led_num, int(led_state)])

def main():
    ser = serial.Serial(
        port='/dev/cu.usbserial-FTHKH0VE', baudrate=57600, timeout=2)
    client = Client(ser)

    try:
        while 1:
            client.set_led(LED_GREEN, True)
            client.set_led(LED_RED, False)
            time.sleep(0.1)
            client.set_led(LED_GREEN, False)
            client.set_led(LED_RED, True)
            time.sleep(0.1)
    except:
        ser.close()
        raise

if __name__ == '__main__':
    main()
