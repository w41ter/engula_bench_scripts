#!/bin/bash

source config.sh
source cluster/config.sh

for node in ${HOST_ENGULA_NODES[@]}; do
    ssh ${USER}@${node} "echo ${node} > ~/cluster/node/host; bash cluster/node/deploy.sh" </dev/null
done
