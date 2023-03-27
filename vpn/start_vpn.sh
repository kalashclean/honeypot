#!/bin/sh
#tail -f /dev/null
sed -i 's/tls-auth/#tls-auth/' /etc/openvpn/openvpn.conf
echo "Setting up OpenVPN server configuration..."
ovpn_genconfig -u udp://$1
echo "Initializing OpenVPN server PKI..."
echo -e "yes\npassword\npassword" | ovpn_initpki nopass
echo "Generating client certificate..."
printf "password\npassword\n" | easyrsa --batch build-client-full $2
echo "Exporting client configuration..."
ovpn_getclient $2 > $2.ovpn
echo "Starting OpenVPN server..."
exec ovpn_run
echo "fini"
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT

rsyslogd -n
tail -f /dev/null
