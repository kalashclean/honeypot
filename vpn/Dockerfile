FROM kylemanna/openvpn
COPY start_vpn.sh /
RUN mkdir /var/log/service && chmod 777 /var/log/service && echo -e "verb 5 \nlog-append /var/log/service/openvpn.log">>/etc/openvpn/openvpn.conf
RUN echo -e "auth-user-pass-verify /etc/openvpn/auth.sh via-env \nscript-security 3"
COPY auth.sh vpn-users.txt /etc/openvpn/
RUN apk update --no-cache
RUN apk add rsyslog --no-cache
