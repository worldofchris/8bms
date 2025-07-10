import os
import serial
import time
from dotenv import load_dotenv
load_dotenv()

def main():
    port = os.environ.get('SENDER_PORT')
    if not port:
        raise EnvironmentError("SENDER_PORT environment variable not set.")
    
    ser = serial.Serial(port, 9600)
    time.sleep(2)

    while True:
        msg = input("Send: ")
        ser.write((msg + "\n").encode('utf-8'))
        print("Message sent.")

if __name__ == "__main__":
    main()

