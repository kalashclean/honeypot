FROM ubuntu:latest
RUN mkdir /var/log/service && chmod 777 /var/log/service
RUN apt-get update && apt-get install -y squid  apache2-utils rsyslog
COPY squid.conf /etc/squid/
RUN chown proxy:proxy /var/log/squid/
RUN touch /var/log/squid/access.log && chown proxy:proxy /var/log/squid/access.log
COPY blocksite /etc/squid/blocksite
COPY start_proxy.sh /
