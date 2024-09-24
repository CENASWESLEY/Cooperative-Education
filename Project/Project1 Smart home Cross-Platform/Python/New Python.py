from machine import Pin, PWM, ADC, I2C, UART, Timer
from umqtt.simple import MQTTClient
from time import sleep, sleep_ms, sleep_us
import network
from dht import DHT11
from mfrc522 import MFRC522
from pico_i2c_lcd import I2cLcd
import ujson
import struct
import utime

# Initialize components
# Power
slide = Pin(12, Pin.IN, Pin.PULL_DOWN)

# Led
led = Pin(1, Pin.OUT)

# Servo Motor
servo = PWM(Pin(13))
servo.freq(50)

# Water level
sensor = ADC(28)

# RFID
reader = MFRC522(spi_id=0, sck=2, miso=4, mosi=3, cs=0, rst=5)

#LCD
i2c = I2C(1, sda=Pin(14), scl=Pin(15), freq=400000)
I2C_ADDR = i2c.scan()[0]
lcd_device = I2cLcd(i2c, I2C_ADDR, 2, 16)

# DHT
dht11 = DHT11(Pin(20))

# Potentiometer
pot = ADC(26)

# Joystick
button = Pin(17, Pin.IN, Pin.PULL_UP)
adc_x = ADC(26)
adc_y = ADC(27)

# Ultrasonic
trigger = Pin(19, Pin.OUT)
echo = Pin(18, Pin.IN)

# Meter & Wind Speed
RX = 17
TX = 16

uart1 = UART(0, baudrate=4800, tx=TX, rx=RX)
uart1.init(bits=8, parity=None, stop=1)

RX2 = 9
TX2 = 8
uart = UART(1, baudrate=4800, tx=TX2, rx=RX2)
uart.init(bits=8, parity=None, stop=1)

sent_values = {}

# Wi-Fi credentials
SSID = 'Miz’iphone'
PASSWORD = 'miz77444477'

# MQTT parameters
SERVER = 'test.mosquitto.org'
CLIENT_ID = b'PICO'
mqtt_client = None
last_sent_values = {}

# Function to connect to MQTT broker
def mqtt_connect():
    global mqtt_client
    mqtt_client = MQTTClient(CLIENT_ID, SERVER, keepalive=3600)
    mqtt_client.set_callback(on_message)
    try:
        mqtt_client.connect()
        print('Connected to %s MQTT Broker' % SERVER)
    except Exception as e:
        print('Failed to connect to MQTT Broker:', e)
        mqtt_client.reconnect()

# Function to reconnect to MQTT broker
def mqtt_reconnect():
    print('Failed to connect to the MQTT Broker. Reconnecting...')
    sleep(5)
    machine.reset()

# Callback function for MQTT subscriptions
def on_message(topic, msg):
    print("Received message:", msg.decode())
    if topic == b'Games Room : Power':
        check_slide()
    elif topic == b'Living Room : Light':
        led_control(msg)


# Function to check slide state
def check_slide():
    if slide.value():
        print("Power : on")
        mqtt_client.publish(b'Games Room : Power', b'true')
    else:
        print("Power : off")
        mqtt_client.publish(b'Games Room : Power', b'false')

# Interrupt handler for slide
def slider_callback(pin):
    check_slide()

slide.irq(trigger=Pin.IRQ_FALLING | Pin.IRQ_RISING, handler=slider_callback)

# Function to control LED
def led_control(msg):
    if msg == b'true':
        led.value(1)
    elif msg == b'false':
        led.value(0)

# Function to get distance from ultrasonic sensor
def get_distance():
    trigger.low()
    sleep_us(2)
    trigger.high()
    sleep_us(5)
    trigger.low()
    while echo.value() == 0:
        pass
    start = utime.ticks_us()
    while echo.value() == 1:
        pass
    finish = utime.ticks_us()
    distance_cm = (finish - start) / 58.0
    max_distance_cm = 300.00
    digital_distance = int((distance_cm / max_distance_cm) * 65535)
    digital_distance = min(max(digital_distance, 0), 65535)
    print(f"Distance: {distance_cm:.2f} cm")
    return digital_distance

# Function to set servo angle
def set_servo_angle(angle):
    duty = 2.5 + (angle / 180) * 10
    servo.duty_u16(int(duty * 65535 / 100))

# Function to send data via UART
def send_data():
    msgfs = bytearray([0x01, 0x03, 0x00, 0x00, 0x00, 0x01, 0x84, 0x0A])
    uart.write(msgfs)
    print("\nRS-FS-N01  =>  SEND DATA")
    for i, byte in enumerate(msgfs):
        print(f"[{i}] => {byte:02X} ", end='')
    print()

# Function to receive data via UART
def receive_data():
    data = uart.read(8)
    if data:
        print("\nDATA RECEPTION  =>  RS-FS-N01")
        for i, byte in enumerate(data):
            print(f"[{i}] => {byte:02X} ", end='')
        print()
        ByteData = data[3] * 256 + data[4]
        print("\nREGISTERS HEX")
        print(ByteData)
        winds = ByteData * 0.1
        print("\nRS-FS-N01 => Result")
        print("Wind Speed = {:.1f} m/s\n".format(winds))
        mqtt_publish('Weather : Wind', winds)

# Function to publish MQTT messages only if the value has changed and is not None
def mqtt_publish(topic, value):
    if value is not None:
        mqtt_client.publish(topic.encode(), str(value).encode())
        last_sent_values[topic] = value


# RFID interrupt function
def rfid_interrupt(timer):
    try:
        reader.init()
        (stat, tag_type) = reader.request(reader.REQIDL)
        if stat == reader.OK:
            (stat, uid) = reader.SelectTagSN()
            if stat == reader.OK:
                card = int.from_bytes(bytes(uid), "little", False)
                print("CARD ID: " + str(card))
                if card == 3642141095:
                    print("Card ID: " + str(card) + " PASS: Open door")
                    mqtt_publish('Security : Door', "true")
                    lcd_device.move_to(0, 0)
                    lcd_device.putstr("Security")
                    lcd_device.move_to(0, 1)
                    lcd_device.putstr("Door : Opened")
                else:
                    print("Card ID: " + str(card) + " UNKNOWN CARD! Lock door")
                    mqtt_publish('Security : Door', "false")
                    lcd_device.move_to(0, 0)
                    lcd_device.putstr("Security")
                    lcd_device.move_to(0, 1)
                    lcd_device.putstr("Door : Closed")
    except Exception as e:
        print("Error in RFID interrupt:", e)

# Function to communicate with the meter via UART
def sdm120ct():
    command = b'\x02\x04\x00\x00\x00\x4C\xF1\xCC'
    for byte in command:
        uart1.write(byte.to_bytes(1, 'big'))
        utime.sleep_us(10)
    utime.sleep_us(800)
    uart1.flush()
    if uart1.any():
        data1 = uart1.readline()
        print(data1)
        if len(data1) >= 5:
            print("Meter => result")
            hex_data1 = ' '.join([hex(byte_value) for byte_value in data1])
            print(f"Hex Data1: {hex_data1}")
            return hex_data1
        else:
            print("No data1 received from UART")
    return None

# Function to parse hexadecimal string to float
def parse_float(hex_str):
    if hex_str.startswith("0x"):
        hex_str = hex_str[2:]
    try:
        int_val = int(hex_str, 16)
        byte_array = int_val.to_bytes(4, 'big')
        return struct.unpack('!f', byte_array)[0]
    except (ValueError, struct.error) as e:
        print(f"Invalid hex string: {e}")
        return None

# Function to prepare data for meter values
def data_prepare(data):
    data_dict = {
        "0": "00", "1": "01", "2": "02", "3": "03",
        "4": "04", "5": "05", "6": "06", "7": "07",
        "8": "08", "9": "09", "A": "0A", "B": "0B",
        "C": "0C", "D": "0D", "E": "0E", "F": "0F"
    }
    return data_dict.get(data, data)

# Function to process payload from the meter
# Function to process payload from the meter
def process_payload(payload):
    parts = payload.split(' 0x')
    def get_data(part_index):
        return parts[part_index] if part_index < len(parts) else "0"
    meter_values = [
        "0x" + data_prepare(get_data(3)) + data_prepare(get_data(4)) + data_prepare(get_data(5)) + data_prepare(get_data(6)),
        "0x" + data_prepare(get_data(15)) + data_prepare(get_data(16)) + data_prepare(get_data(17)) + data_prepare(get_data(18)),
        "0x" + data_prepare(get_data(27)) + data_prepare(get_data(28)) + data_prepare(get_data(29)) + data_prepare(get_data(30)),
        "0x" + data_prepare(get_data(39)) + data_prepare(get_data(40)) + data_prepare(get_data(41)) + data_prepare(get_data(42)),
        "0x" + data_prepare(get_data(51)) + data_prepare(get_data(52)) + data_prepare(get_data(53)) + data_prepare(get_data(54)),
        "0x" + data_prepare(get_data(63)) + data_prepare(get_data(64)) + data_prepare(get_data(65)) + data_prepare(get_data(66)),
        "0x" + data_prepare(get_data(143)) + data_prepare(get_data(144)) + data_prepare(get_data(145)) + data_prepare(get_data(146)),
        "0x" + data_prepare(get_data(147)) + data_prepare(get_data(148)) + data_prepare(get_data(149)) + data_prepare(get_data(150))
    ]
    parsed_values = [parse_float(value) for value in meter_values]
    for idx, val in enumerate(parsed_values):
        topic = f'External : Meter_Value_{idx+1}'
        if val is not None:
            if val < 0 or val > 10000:
                val = 0
            mqtt_publish(topic, val)
            print(f"{topic} = {val}")
        else:
            print(f"Failed to parse meter value {idx+1}")


# Main function to initialize and run the program
def main():
    try:
        connect_to_wifi()
        mqtt_connect()
        subscribe_to_topics()
        setup_rfid_timer()
        run_main_loop()
    except OSError as e:
        mqtt_reconnect()

# Function to connect to Wi-Fi
def connect_to_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(SSID, PASSWORD)
    while not wlan.isconnected():
        pass
    print('Connected to Wi-Fi')
    print(wlan.ifconfig())

# Function to subscribe to MQTT topics
def subscribe_to_topics():
    topics = [b'Living Room : Light']
    for topic in topics:
        mqtt_client.subscribe(topic)

# Function to setup RFID timer interrupt
def setup_rfid_timer():
    rfid_timer = Timer()
    rfid_timer.init(period=500, mode=Timer.PERIODIC, callback=rfid_interrupt)

# Function to handle the main loop operations
def run_main_loop():
    while True:
        try:
            print("\n===== MQTT messages ===== \n")
            mqtt_client.check_msg()
            sleep(0.5)
            handle_potentiometer()
            handle_water_level()
            handle_dht_sensor()
            handle_ultrasonic_sensor()
            handle_wind_speed()
            handle_meter()
        except Exception as e:
            print("Error in main loop:", e)
            continue

# Function to handle potentiometer
def handle_potentiometer():
    value_pot = pot.read_u16()
    mqtt_publish('Sensor : Pump', value_pot)
    print(f"Potentiometer value : {value_pot}/65535")
    sleep(1)

# Function to handle water level sensor
def handle_water_level():
    value_water = sensor.read_u16()
    print(f"Water Level: {value_water}/65535")
    mqtt_publish('Sensor : Water Level', value_water)
    sleep(1)

# Function to handle DHT sensor
def handle_dht_sensor():
    dht11.measure()
    temp = dht11.temperature()
    hum = dht11.humidity()
    print('Temperature:', temp, 'C', 'Humidity:', hum, '%')
    mqtt_client.publish('Weather : Temperature'.encode(), str(temp).encode())
    mqtt_client.publish('Weather : Humidity'.encode(), str(hum).encode())
    sleep(1)

# Function to handle ultrasonic sensor
def handle_ultrasonic_sensor():
    distance = get_distance()
    if distance is not None:
        print(f"Distance: {distance}/65535")
        mqtt_publish('Sensor : Ultrasonic', distance)
        if distance < 20000:
            set_servo_angle(0)
        else:
            set_servo_angle(90)
    else:
        print("Failed to get distance")
    sleep(1)

# Function to handle wind speed sensor
def handle_wind_speed():
    send_data()
    sleep(1)
    receive_data()
    sleep(2)

# Function to handle meter data
def handle_meter():
    payload = sdm120ct()
    if payload:
        process_payload(payload)
    sleep(5)

# Run the main function
main()

