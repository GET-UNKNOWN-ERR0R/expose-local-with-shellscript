#!/bin/bash

read -p "Enter the link (with http:// or https://) you want to expose: " LINK

# Extract the protocol, hostname, and port from the link
PROTOCOL=$(echo $LINK | awk -F[/:] '{print $1}')
HOSTNAME=$(echo $LINK | awk -F[/:] '{print $4}')
PORT=$(echo $LINK | awk -F[/:] '{print $5}')

read -p "Enter the port number to expose (default is $PORT): " CUSTOM_PORT
CUSTOM_PORT=${CUSTOM_PORT:-$PORT}

if [[ $PROTOCOL == "https" ]]; then
    CUSTOM_PORT=${CUSTOM_PORT:-8443}
else
    CUSTOM_PORT=${CUSTOM_PORT:-8080}
fi

echo "Protocol: $PROTOCOL"
echo "Hostname: $HOSTNAME"
echo "Port: $CUSTOM_PORT"

# Check if Serveo is installed and prompt the user to install if not
if ! command -v ssh &> /dev/null; then
    echo "SSH command not found. Please install OpenSSH client first."
    exit 1
fi

if [[ $HOSTNAME == "localhost" ]] || [[ $HOSTNAME == "127.0.0.1" ]]; then
  
    echo "Exposing local service at http://localhost:$CUSTOM_PORT..."
    ssh -R 8080:localhost:$CUSTOM_PORT serveo.net
else
    echo "Exposing remote service at $HOSTNAME on port $CUSTOM_PORT..."
    ssh -R 8080:$HOSTNAME:$CUSTOM_PORT serveo.net
fi
