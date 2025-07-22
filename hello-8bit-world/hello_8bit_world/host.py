import os
import serial
import time
import threading
from dotenv import load_dotenv
load_dotenv()

def read_loop(ser):
    print("📥 Listening for incoming data...")
    while True:
        if ser.in_waiting:
            data = ser.read(ser.in_waiting).decode(errors='replace')
            print(f"👾 Received: {data}", end='', flush=True)
        time.sleep(0.1)

def write_loop(ser):
    print("📤 Ready to send data. Type and press Enter.")
    while True:
        msg = input()
        ser.write(msg.encode())

def main():

    port = os.environ.get('HOST_PORT')
    if not port:
        raise EnvironmentError("HOST_PORT environment variable not set.")
    
    baud = os.environ.get('BAUD')
    if not port:
        raise EnvironmentError("BAUD environment variable not set.")

    with serial.Serial(port, baud, timeout=1) as ser:

        print("Please wait...")
        time.sleep(10)
        print("Ready")
    
        reader = threading.Thread(target=read_loop, args=(ser,), daemon=True)
        reader.start()
        write_loop(ser)  # Blocks

if __name__ == "__main__":
    main()    

