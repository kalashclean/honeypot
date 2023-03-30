#!/bin/bash


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

#tcpdump
tcpdump -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}') -i eth0 -G 20 -w log/pcap/capture-%Y%m%d-%H%M%S.pcap &
#run client 
python3 honeyd/main.py &
# docker-compose
sudo docker-compose build
sudo docker-compose up