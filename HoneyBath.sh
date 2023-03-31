#!/bin/bash

chmod -R 777 log
#crontab for docker cp
SCRIPT_PATH=$(pwd)"/log.sh"
echo "$SCRIPT_PATH"
CRON_JOB="0 0 * * * ${SCRIPT_PATH}"

if crontab -l | grep -q "${CRON_JOB}"; then
  echo "The cron job is already installed."
else
  (crontab -l 2>/dev/null; echo "${CRON_JOB}") | crontab -
  echo "The cron job has been installed."
fi
openssl genrsa -out web/src/privateKey.key 2048
openssl req -new -x509 -key web/src/privateKey.key -out web/src/certificate.crt -days 365
#tcpdump
tcpdump -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}')  -G 86400 -w log/pcap/capture-%Y%m%d-%H%M%S.pcap &
#run client 
python3 honeyd/main.py &
# docker-compose
# The name of the Docker network interface you want to create
NETWORK_NAME="streetshares_network"

# Check if the Docker network interface exists
if ! docker network ls --filter name="^${NETWORK_NAME}$" --format "{{.Name}}" | grep -q "^${NETWORK_NAME}$"; then
  # If the network interface does not exist, create it
  docker network create "${NETWORK_NAME}"
  echo "Docker network '${NETWORK_NAME}' created."
else
  # If the network interface exists, print a message
  echo "Docker network '${NETWORK_NAME}' already exists."
fi
sudo docker-compose build
#tcpdump -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}')  -G 86400 -w log/pcap/capture-%Y%m%d-%H%M%S.pcap &
sudo docker-compose up
