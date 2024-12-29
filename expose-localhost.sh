#!/bin/bash


read -p "Enter the link (with http:// or https://) you want to expose: " LINK

PROTOCOL=$(echo $LINK | awk -F[/:] '{print $1}')
HOSTNAME=$(echo $LINK | awk -F[/:] '{print $4}')
PORT=$(echo $LINK | awk -F[/:] '{print $5}')

# If no port is specified, default to 80 for HTTP and 443 for HTTPS
if [[ $PROTOCOL == "https" ]]; then
    PORT=${PORT:-443}
else
    PORT=${PORT:-80}
fi

echo "Protocol: $PROTOCOL"
echo "Hostname: $HOSTNAME"
echo "Port: $PORT"

# Create Serveo tunnel for exposing the service
if [[ $HOSTNAME == "localhost" ]] || [[ $HOSTNAME == "127.0.0.1" ]]; then
   
    ssh -R 80:localhost:$PORT serveo.net
else
  
    ssh -R 80:$HOSTNAME:$PORT serveo.net
fi
