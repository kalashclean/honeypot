#!/bin/bash

# Get the IP address of the client
CLIENT_IP=$(echo $SSH_CONNECTION | awk '{print $1}')

# Log the command executed by the client along with their IP address
logger -p local1.notice -t ssh-wrapper "User $USER from $CLIENT_IP executed '$SSH_ORIGINAL_COMMAND'"

# Execute the requested command
if [ -z "$SSH_ORIGINAL_COMMAND" ]
then
  # If no command was specified, start a shell
  /bin/bash
else
  eval $SSH_ORIGINAL_COMMAND
fi

