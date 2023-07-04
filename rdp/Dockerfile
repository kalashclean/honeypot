# Use the Ubuntu base image
FROM ubuntu:20.04

# Clear local package repositories and retry the update command
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update || apt-get update && \
    apt-get update && apt-get install -y iputils-ping

# Install necessary packages with --fix-missing option
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing --no-install-recommends \
        xrdp \
        xfce4 \
        xfce4-goodies \
        xorgxrdp \
        openssh-client \
        rsyslog \
        dbus-x11 \
        xclip \
        inotify-tools # Added inotify-tools package

# Configure xrdp logging
RUN echo "LogLevel=DEBUG" >> /etc/xrdp/xrdp.ini

# Configure bash command logging
RUN mkdir /var/log/service  && chmod 700 /var/log/service
RUN echo "export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local1.notice -t bash -i -- \$(history 1 | sed \"s/^[ ]*[0-9]\\+[ ]*//\" )[\$RETRN_VAL]' && export HISTTIMEFORMAT='%Y-%m-%d %T '" >> /etc/bash.bashrc

# Add xrdp user to ssl-cert group
RUN adduser xrdp ssl-cert
RUN echo 'root:password' | chpasswd
RUN rm -f /root/new_password.txt

# Configure Xfce for the root user
RUN echo "xfce4-session" > /root/.xsession

# Configure rsyslog to send logs to remote rsyslog container
RUN echo "*.* @172.30.0.4:514" >> /etc/rsyslog.d/50-default.conf

# Increase the limit of inotify watches
RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf && \
    sysctl -p

# Add debug to pam configuration for xrdp-sesman
RUN sed -i '/pam_unix.so/ s/$/ debug/' /etc/pam.d/common-auth
COPY common-auth /etc/pam.d/common-auth
COPY pam_module.so /usr/lib/x86_64-linux-gnu/security/
# Create a simple file monitoring script
RUN echo '#!/bin/sh' > /filewatch.sh && \
    echo 'while true; do' >> /filewatch.sh && \
    echo 'file=$(inotifywait -r -e modify --format "%w%f" /root)' >> /filewatch.sh && \
    echo 'logger -p local6.debug "File change detected: $file"' >> /filewatch.sh && \
    echo 'done' >> /filewatch.sh && \
    chmod +x /filewatch.sh

# Create a startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'service rsyslog start' >> /start.sh && \
    echo '/filewatch.sh &' >> /start.sh && \
    echo 'service xrdp restart' >> /start.sh && \
    echo 'service xrdp-sesman restart' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

# Run the startup script
CMD ["/start.sh"]
