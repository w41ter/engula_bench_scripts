#!/bin/bash

# This script will establish ssh authorization for the central node.
source config.sh

# Install rsa keys
ssh-keygen -f "~/.ssh/known_hosts" -R "${HOST_CENTRAL}"
ssh-keyscan ${HOST_CENTRAL} >> ~/.ssh/known_hosts; \
ssh ${USER}@${HOST_CENTRAL} 'if [ ! -f /root/.ssh/id_rsa ]; then ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa; fi'
scp ${USER}@${HOST_CENTRAL}:~/.ssh/id_rsa.pub .
scp ${USER}@${HOST_CENTRAL}:~/.ssh/id_rsa .
ssh ${USER}@${HOST_CENTRAL} "cat <<EOF >~/.ssh/config
Host *
        ServerAliveInterval 30
        StrictHostKeyChecking no
EOF"

for host in ${HOSTS[@]}; do
    ssh ${USER}@${HOST_CENTRAL} "\
        ssh-keygen -f '~/.ssh/known_hosts' -R ${host}; \
        ssh-keyscan ${host} >> ~/.ssh/known_hosts; \
    "
	ssh-copy-id -i id_rsa.pub  -o ProxyJump=${USER}@${HOST_CENTRAL} ${USER}@${host} </dev/null
done
