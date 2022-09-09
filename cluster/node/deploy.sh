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

function download_engula() {
    curl -s -o /tmp/engula.tar.gz.tmp ${PACKAGE_URL} 2>/dev/null
    mv /tmp/engula.tar.gz.tmp /tmp/engula.tar.gz
    mkdir -p ${WDR}/bin
    tar zxf /tmp/engula.tar.gz -C ${WDR}/bin

    mkdir -p ${WDR}/scripts
    cat >${WDR}/scripts/run.sh <<EOF
#!/bin/bash
$(if [[ ${ENABLE_TCMALLOC:-false} == "true" ]]; then
        echo "export LD_PRELOAD=libtcmalloc_minimal.so.4"
    else
        echo ""
    fi)
export TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=${TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES:-1073741824}
export ENGULA_ENABLE_PROXY_SERVICE=true
exec ${WDR}/bin/engula start --conf ${WDR}/config.toml >${WDR}/log 2>&1

EOF
    chmod +x ${WDR}/scripts/run.sh
}

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

function install_service() {
    cat >/etc/systemd/system/engula-${ENGULA_PORT}.service <<EOF
[Unit]
Description=Engula Service
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
LimitNOFILE=1000000
LimitSTACK=10485760
User=root
ExecStart=${WDR}/scripts/run.sh
Restart=no
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl start engula-${ENGULA_PORT}.service
    systemctl enable engula-${ENGULA_PORT}.service
}

download_engula
generate_config
install_service
