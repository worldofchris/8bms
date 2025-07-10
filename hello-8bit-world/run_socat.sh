#!/bin/bash

set -e

echo "Starting socat to create virtual serial ports..."

SOCAT_LOG=$(mktemp)
socat -d -d pty,raw,echo=0 pty,raw,echo=0 2> "$SOCAT_LOG" &
SOCAT_PID=$!

# Wait for the ports to appear
sleep 1

# Extract the device names
PORTS=($(grep -o '/dev/ttys[0-9]*' "$SOCAT_LOG"))

if [ "${#PORTS[@]}" -ne 2 ]; then
  echo "Error: Expected 2 serial ports, got ${#PORTS[@]}"
  cat "$SOCAT_LOG"
  kill $SOCAT_PID
  exit 1
fi

SENDER_PORT="${PORTS[0]}"
RECEIVER_PORT="${PORTS[1]}"

echo "SENDER_PORT=$SENDER_PORT"
echo "RECEIVER_PORT=$RECEIVER_PORT"

# Write .env file
cat <<EOF > .env
SENDER_PORT=$SENDER_PORT
RECEIVER_PORT=$RECEIVER_PORT
EOF

BASE_DIR=hello_8bit_world

# Start the receiver in a new terminal window
osascript <<EOF
tell application "Terminal"
    do script "cd $(pwd); poetry run python ${BASE_DIR}/rec.py"
end tell
EOF

# Run the sender in the current terminal
poetry run python $BASE_DIR/send.py

# Cleanup when done
kill $SOCAT_PID
