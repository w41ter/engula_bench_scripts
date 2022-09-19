#!/bin/bash

source config.sh

function upload() {
    local path=$1

    scp -r ${path} ${USER}@${HOST_CENTRAL}:~
}

upload config.sh
upload setup_node.sh
upload setup_central.sh
upload copy_to_node.sh
upload install
upload tools
upload cluster

if [[ "${UPLOAD_BINARY}" == "all" ]]; then
    upload binary/prometheus-2.37.0.linux-amd64.tar.gz
    upload binary/grafana-enterprise_9.1.1_amd64.deb
fi

# upload go1.19.linux-amd64.tar.gz
if [[ ! -z ${UPLOAD_BINARY} ]]; then
    upload binary/engula.tar.gz
    upload binary/go-ycsb/bin/go-ycsb
    upload binary/go-ycsb/workloads
fi

upload bench

