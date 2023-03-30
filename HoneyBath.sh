#!/bin/bash

chmod -R 777 log
#crontab for docker cp
SCRIPT_PATH=$(pwd)"/log.sh"
echo "$SCRIPT_PATH"
CRON_JOB="* * * * * ${SCRIPT_PATH}"

if crontab -l | grep -q "${CRON_JOB}"; then
  echo "The cron job is already installed."
else
  (crontab -l 2>/dev/null; echo "${CRON_JOB}") | crontab -
  echo "The cron job has been installed."
fi
openssl genrsa -out web/src/privateKey.key 2048
openssl req -new -x509 -key web/src/privateKey.key -out web/src/certificate.crt -days 365
#tcpdump
tcpdump -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}') -i eth0 -G 20 -w log/pcap/capture-%Y%m%d-%H%M%S.pcap &
#run client 
python3 honeyd/main.py &
# docker-compose
docker network create streetshares_network
sudo docker-compose build
sudo docker-compose up
