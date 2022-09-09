#!/bin/bash

source config.sh
source cluster/config.sh

for node in ${HOST_ENGULA_NODES[@]}; do
    ssh ${USER}@${node} "systemctl stop engula-*.service" </dev/null
done
