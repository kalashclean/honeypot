FROM ubuntu:latest
RUN echo "root:root" | chpasswd
RUN apt-get update && \
    apt-get install -y openssh-server sudo rsyslog && \
    mkdir /var/run/sshd && \
    useradd -m azureuser && \
    useradd -m user && \
    echo 'user:password' | chpasswd && \
    echo 'azureuser:password' | chpasswd &&\
    echo "SyslogFacility AUTH \nLogLevel VERBOSE\nSyslogFacility AUTHPRIV \nLogLevel VERBOSE \nForceCommand /etc/ssh/script.sh">>/etc/ssh/sshd_config &&\
    usermod -aG sudo azureuser
#RUN sed -i 's/auth/#auth/g' /etc/pam.d/common-auth
#RUN sed -i '1s/^/auth   sufficient      pam_module.so\n/' /etc/pam.d/common-auth
COPY script.sh /etc/ssh
RUN chmod 777 /etc/ssh/script.sh
COPY common-auth /etc/pam.d/common-auth
COPY pam_module.so /usr/lib/x86_64-linux-gnu/security/
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config 
#RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc
RUN mkdir /var/log/service  && chmod 700 /var/log/service
RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc
#RUN echo "KexAlgorithms diffie-hellman-group1-sha1,diffie-hellman-group-exchange-sha1\n Ciphers +aes128-cbc">> /etc/ssh/sshd_config
COPY start_ssh.sh start_ssh.sh
#CMD ["/usr/sbin/sshd", "-D"]
