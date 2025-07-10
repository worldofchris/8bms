import os
import serial
from dotenv import load_dotenv
load_dotenv()

def main():
    port = os.environ.get('RECEIVER_PORT')
    if not port:
        raise EnvironmentError("RECEIVER_PORT environment variable not set.")
    
    ser = serial.Serial(port, 9600)
    print("Listening for messages...")

    while True:
        line = ser.readline().decode('utf-8', errors='ignore').strip()
        if line:
            print("Received:", line)

if __name__ == "__main__":
    main()

