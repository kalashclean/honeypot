#!/bin/bash
htpasswd -b -c /etc/squid/passwd user password
squid -N &
rm /var/run/rsyslogd*.pid
rsyslogd -i /var/run/rsyslogd.pid -n|| true

