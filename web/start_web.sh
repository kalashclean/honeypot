#! /bin/bash
#systemctl restart rsyslog
npm start
rm /var/run/rsyslogd*.pid
rsyslogd -i /var/run/rsyslogd.pid -n ||true
tail -f /dev/null
