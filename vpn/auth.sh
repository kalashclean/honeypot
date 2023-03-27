#!/bin/bash
echo "$1:$2"
# Check if the username and password are correct
if grep -q "^$1:$2$" /etc/openvpn/vpn-users.txt; then
    exit 0  # Authentication successful
else
    exit 1  # Authentication failed
fi
