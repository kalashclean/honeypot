FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y openssh-server sudo rsyslog && \
    mkdir /var/run/sshd && \
    useradd -m azureuser && \
    echo 'azureuser:password' | chpasswd &&\
    echo "SyslogFacility AUTH \nLogLevel VERBOSE\nSyslogFacility AUTHPRIV \nLogLevel VERBOSE">>/etc/ssh/sshd_config &&\
    usermod -aG sudo azureuser &&  echo "password\npassword"|adduser sshuser && addgroup sshgroup
 
RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc
RUN mkdir /var/log/service &&chown sshuser:sshgroup /var/log/service && chmod 700 /var/log/service
RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc
RUN echo "KexAlgorithms diffie-hellman-group1-sha1,diffie-hellman-group-exchange-sha1\n Ciphers +aes128-cbc">> /etc/ssh/sshd_config
COPY start_ssh.sh start_ssh.sh
#CMD ["/usr/sbin/sshd", "-D"]
