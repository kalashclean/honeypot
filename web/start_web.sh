#! /bin/bash
systemctl restart rsyslog
npm start
tail -f /dev/null
