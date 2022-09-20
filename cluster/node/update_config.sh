#!/bin/bash

# This scripts will generate config file for this server.

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

if [[ $host == ${INIT_NODE} ]]; then
    INIT="true"
fi

# save former config.
if [ -e ${WDR}/config.toml ]; then
    mv ${WDR}/config.toml ${WDR}/config.toml.$(date +'%Y%d%m')
fi

cat >${WDR}/config.toml <<EOF
root_dir = "${WDR}/data/"
addr = "${host}:${ENGULA_PORT}"
cpu_nums = 0
init = ${INIT:-false}
num_conn = 1
enable_proxy_service = true
join_list = [
    "${INIT_NODE}:${ENGULA_PORT}",
]

[node]
shard_chunk_size = 67108864
shard_gc_keys = 256

[node.replica]
snap_file_size = 68719476736

[node.engine]

[raft]
tick_interval_ms = 500
max_inflight_requests = 102400
election_tick = 3
max_size_per_msg = 131072
max_io_batch_size = 131072
max_inflight_msgs = 10000
enable_log_recycle = false

[root]
replicas_per_group = 3
enable_group_balance = true
enable_replica_balance = true
enable_shard_balance = true
enable_leader_balance = true
liveness_threshold_sec = 30
heartbeat_timeout_sec = 4
schedule_interval_sec = 1
max_create_group_retry_before_rollback = 10

[executor]

[db]
max_background_jobs = 2
max_sub_compactions = 1
max_manifest_file_size = 1073741824
bytes_per_sync = 1048576
compaction_readahead_size = 0
use_direct_read = false
use_direct_io_for_flush_and_compaction = false
avoid_unnecessary_blocking_io = true
block_size = 4096
block_cache_size = 7917905920
write_buffer_size = 67108864
max_write_buffer_number = 3
min_write_buffer_number_to_merge = 1
num_levels = 7
compression_per_level = ["None", "None", "Lz4", "Lz4", "Lz4", "Zstd", "Zstd"]
level0_file_num_compaction_trigger = 4
target_file_size_base = 67108864
max_bytes_for_level_base = 268435456
max_bytes_for_level_multiplier = 10.0
max_compaction_bytes = 0
level_compaction_dynamic_level_bytes = true
level0_stop_write_trigger = 36
level0_slowdown_writes_trigger = 20
soft_pending_compaction_bytes_limit = 68719476736
hard_pending_compaction_bytes_limit = 274877906944
rate_limiter_bytes_per_sec = 10737418240
rate_limiter_refill_period = 100000
rate_limiter_auto_tuned = true
EOF

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

# generate_config
