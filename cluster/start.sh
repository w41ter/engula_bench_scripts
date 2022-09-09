#!/bin/bash

source config.sh
source cluster/config.sh

for node in ${HOST_ENGULA_NODES[@]}; do
    ssh ${USER}@${node} "systemctl start engula-${ENGULA_PORT}.service" </dev/null
done
