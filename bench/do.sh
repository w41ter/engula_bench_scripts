#!/bin/bash

# sudo apt-get install -y mailutils

set -a
source config.sh
source bench/config.sh
set +a

export THREAD_COUNT=600
bash bench/load.sh >/dev/null

# workload d inserts records, increasing the size of the database.
workloads=( a b c f d )

# See https://docs.google.com/spreadsheets/d/e/2PACX-1vTIx695jjL3qYN1iR4xC3N8qh0B1qsHOALSBqf1B469b0DIZwVdzZMcSbBOOtAIo31hAdW0x_EXjmgq/pubchart?oid=1044850259&format=interactive
threads=( 40 80 120 160 200 240 280 320 360 400 440 480 )

for suffix in ${workloads[@]}; do
    for num in ${threads[@]}; do
        export THREAD_COUNT=${num}
        bash bench/workload${suffix}.sh >/dev/null </dev/null
        echo "sleep 120 seconds before next round"
        sleep 120
    done

    echo "sleep 300 seconds before next workload"
    sleep 300
done

