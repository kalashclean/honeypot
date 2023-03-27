# Use the osixia/openldap image as the base
FROM osixia/openldap:1.5.0
RUN apt update && apt install -y rsyslog net-tools 
RUN mkdir /var/log/service && chmod 777 /var/log/service
COPY add_user.ldif  create_parent.ldif logging.ldif  start_ldap.sh /
COPY process.sh /container/service/slapd/process.sh
# Set environment variables for LDAP configuration
ENV LDAP_ORGANISATION=$LDAP_ORGANISATION \
    LDAP_DOMAIN=$LDAP_DOMAIN \
    LDAP_BASE_DN=$LDAP_BASE_DN \
    LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD \
    LDAP_CONFIG_PASSWORD=$LDAP_CONFIG_PASSWORD \
    LDAP_READONLY_USER=$LDAP_READONLY_USER\
    LDAPIP=$LDAPIP

