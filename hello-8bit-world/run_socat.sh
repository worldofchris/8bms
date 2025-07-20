#!/bin/bash

set -e

MODE=${1:-vice_receiver}  # Default to vice as receiver
VICE_HOME=/Applications/vice-arm64-gtk3-3.9/bin

echo "🔌 Creating virtual serial ports with socat..."

PORT1=/tmp/ttyS0
PORT2=/tmp/ttyS1
SOCAT_LOG=./logs/socat.log

socat -d -d -d -v pty,raw,echo=0,link=$PORT1 pty,raw,echo=0,link=$PORT2 2> "$SOCAT_LOG" &

SOCAT_PID=$!
C64_CODE=./rec_bas.d64

sleep 1  # Wait for ports to settle

VICE_PORT="$PORT1"
HOST_PORT="$PORT2"

echo "🧭 Mode: Python sender → VICE receiver"
echo "📄 Writing .env for Python sender..."
echo "HOST_PORT=$HOST_PORT" > .env

echo "🚀 Launching VICE as receiver on ${VICE_PORT}..."
$VICE_HOME/x64sc -userportdevice 2 -rsdev1 "$VICE_PORT" -rsdev1baud 1200 -rsuserbaud 1200 -autoload $C64_CODE &

read -n 1 -s -r -p "Press any key once VICE is ready..."; echo

echo "🐍 Launching Python sender..."
poetry run python hello_8bit_world/host.py

echo "🧹 Cleaning up socat..."
kill $SOCAT_PID
