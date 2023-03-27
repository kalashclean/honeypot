#!/bin/bash
#snort -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}') -c /etc/snort/etc/snort.conf -A console &
snort -c /etc/snort/etc/snort.conf -l /var/log/service/snort.log -A console  -i $(ip addr show | grep -E 'inet .*172\.30\.0\.' | awk '{print $NF}')  -e -q -k none -N -s >> /dev/null &
rsyslogd  -n ||true
