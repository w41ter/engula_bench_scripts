#!/bin/bash

# This script run a full round of tests.
# User need to ensure that the environment variables used below have been defined.
set -u

echo "run workloadf ..."
./go-ycsb run engula -P workloads/workloadf \
    --threads ${THREAD_COUNT} \
    -p engula.proxy="${ENGULA_PROXIES}" \
    -p engula.conn=32 \
    -p recordcount=${RECORD_COUNT} \
    -p operationcount=${OPERATION_COUNT} \
    -p requestdistribution=zipfian |
    tee ${TEST_NAME}.${THREAD_COUNT}.workloadf.log
