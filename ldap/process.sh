#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n $LDAP_NOFILE
echo "$LDAP_ORGANISATION"
# Call hostname to determine the fully qualified domain name. We want OpenLDAP to listen
# to the named host for the ldap:// and ldaps:// protocols.
FQDN="$(/bin/hostname --fqdn)"
HOST_PARAM="ldap://$FQDN:$LDAP_PORT ldaps://$FQDN:$LDAPS_PORT"
echo "avant"
exec /usr/sbin/slapd -h "$HOST_PARAM ldapi:///" -u openldap -g openldap -d "$LDAP_LOG_LEVEL" &
echo "run"
while ! netstat -tln | grep  '389'; do
  sleep 1
done
ldapmodify -x -D "cn=admin,cn=config" -w $LDAP_CONFIG_PASSWORD -f logging.ldif
echo "port1"
ldapdelete -x -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD -H ldap://$LDAPIP ||true
echo "entre1"
ldapdelete -x -D "$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD -H ldap://$LDAPIP ||true
echo "port1"
ldapsearch -x -H ldap://$LDAPIP -b "ou=users,$LDAP_BASE_DN" -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD ||true
echo "port"
ldapadd -x -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD -H ldap://$LDAPIP -f create_parent.ldif ||true
echo "entre"
ldapadd -x -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD -H ldap://$LDAPIP -f add_user.ldif ||true
echo "fin"
#ldapsearch -x -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD -H ldap://$LDAPIP -b "ou=users,$LDAP_BASE_DN" ||true
#ldapsearch -x -H ldap://$LDAPIP -b "ou=users,$LDAP_BASE_DN" -D "cn=admin,$LDAP_BASE_DN" -w $LDAP_ADMIN_PASSWORD ||true


rsyslogd -n
tail -f /dev/null
