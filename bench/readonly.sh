#!/bin/bash

# This script run a full round of tests.
# User need to ensure that the environment variables used below have been defined.
set -u

set -a
source config.sh
source bench/config.sh
set +a

export GOGC=off
export GOMEMLIMIT=34359738368
export THREAD_COUNT=600
# bash bench/load.sh >/dev/null
export OPERATION_COUNT=3000000000

echo "run workloadc ..."
./go-ycsb run engula -P workloads/workloadc \
    --threads ${THREAD_COUNT} \
    -p engula.proxy="${ENGULA_PROXIES}" \
    -p engula.conn=16 \
    -p recordcount=${RECORD_COUNT} \
    -p operationcount=${OPERATION_COUNT} \
    -p requestdistribution=zipfian |
    tee ${TEST_NAME}.${THREAD_COUNT}.workloadc.log
