#!/bin/bash

# This script run a full round of tests.
# User need to ensure that the environment variables used below have been defined.
set -u

# doTransactionInsert
# transactionInsertSequence: an ackCounter, start at record count.
echo "run workloadd ..."
./go-ycsb run engula -P workloads/workloadd \
    --threads ${THREAD_COUNT} \
    -p engula.proxy="${ENGULA_PROXIES}" \
    -p engula.conn=32 \
    -p recordcount=${RECORD_COUNT} \
    -p insertcount=${INSERT_COUNT} \
    -p operationcount=${OPERATION_COUNT} |
    tee ${TEST_NAME}.${THREAD_COUNT}.workloadd.log
