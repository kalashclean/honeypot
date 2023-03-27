FROM linton/docker-snort
RUN apt update && apt install -y rsyslog
RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc
RUN mkdir /var/log/service && chmod 777 /var/log/service
COPY local.rules /etc/snort/rules/local.rules
COPY start_snort.sh /
CMD ["snort", "-i", "eth0", "-c", "/etc/snort/etc/snort.conf", "-A", "console"]
#build docker image
#docker build -t test_snort .
#run it
#docker run --net=host my_snort_image
