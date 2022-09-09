#!/bin/bash

# Please run `connection_setup.sh` before this script.

source config.sh

function upload() {
    local path=$1

    scp -r ${path} ${USER}@${HOST_CENTRAL}:~
}

upload config.sh
upload tools/mount_local_ssd.sh

ssh ${USER}@${HOST_CENTRAL} "\
NODES=( ${HOST_ENGULA_NODES[*]} ); \
for node in \${NODES[@]}; do \
    scp -r mount_local_ssd.sh ${USER}@\${node}:~ ; \
    ssh ${USER}@\${node} 'bash mount_local_ssd.sh vdb mnt' </dev/null; \
done \
"
