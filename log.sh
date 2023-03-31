#!/bin/bash
DATE=$(date +"%Y-%m-%d-%H%M%S")
mkdir /home/kalash/HoneyBath/log/container/$DATE
echo "$DATE"
sudo docker cp rsyslog:/var/log/service /home/kalash/HoneyBath/log/container/$DATE
