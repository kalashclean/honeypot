#!/bin/bash
DATE=$(date +"%Y-%m-%d-%H%M%S")
mkdir $HOME/HoneyBath/log/container/$DATE
echo "$DATE"
docker cp rsyslog:/var/log/service $HOME/log/container/$DATE
