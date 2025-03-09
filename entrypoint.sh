#!/bin/bash

set -e

# PostgreSQL setup
echo "Starting PostgreSQL..."
service postgresql start

# Initialize Metasploit database (msfdb) in the background
echo "Initializing Metasploit database..."
msfdb init > /dev/null 2>&1 &

# VNC setup
echo "Setting up VNC..."
mkdir -p /root/.vnc/

# Generate a random VNC password if none is provided
if [ -z "$VNCPWD" ]; then
  echo "VNCPWD not set, generating a random password..."
  VNCPWD=$(openssl rand -base64 16)  # Generate a 16-byte random password
  echo "Generated VNC password: $VNCPWD"
fi

echo "$VNCPWD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Determine if VNC should be exposed or run locally
VNC_ARGS=":0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH"
if [ "$VNCEXPOSE" != "1" ]; then
  VNC_ARGS="$VNC_ARGS -localhost"
fi

# Start VNC server in the background
echo "Starting VNC server with arguments: $VNC_ARGS"
vncserver $VNC_ARGS > /var/log/vncserver.log 2>&1 &

# noVNC setup (optional)
if [ "$VNCWEB" = "1" ]; then
  echo "Starting noVNC proxy..."
  /usr/share/novnc/utils/novnc_proxy \
    --listen "$NOVNCPORT" --vnc "localhost:$VNCPORT" > /var/log/novnc.log 2>&1 &
  echo "noVNC web interface available at: http://localhost:$NOVNCPORT/vnc.html"
fi

# Final message
echo "Setup complete."
echo "VNC server is running. Connect using a VNC client to port $VNCPORT."

# Enable VNC copypasting
#   Run this in the shell til I discover how to do it automatically
#autocutsel -fork

/bin/bash
