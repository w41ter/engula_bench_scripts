#!/bin/bash

set -ue

source config.sh
source cluster/config.sh

WDR=${DEPLOY_DIR}/engula-${ENGULA_PORT}/
mkdir -p ${WDR}

if [[ ! -f ~/cluster/node/host ]]; then
    echo "host file '~/node/host' is lost"
    exit 1
fi
host=$(cat ~/cluster/node/host)

function generate_config() {
    if [[ $host == ${INIT_NODE} ]]; then
        ${WDR}/bin/engula start \
            --db ${WDR}/data/ \
            --cpu-nums=${CPU_NUMS:-0} \
            --addr "${host}:${ENGULA_PORT}" \
            --init \
            --dump-config ${WDR}/config.toml
    else
        ${WDR}/bin/engula start \
            --db ${WDR}/data/ \
            --cpu-nums=${CPU_NUMS:-0} \
            --addr "${host}:${ENGULA_PORT}" \
            --join ${INIT_NODE}:${ENGULA_PORT} \
            --dump-config ${WDR}/config.toml
    fi
}

generate_config
