#!/bin/bash
echo "coucou"
echo "$1"
name=$(echo "$1" | jq -r '.ip')
echo $name
hping3 --icmp --spoof $name 172.30.0.4
