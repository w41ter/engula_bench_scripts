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
}

function extract_engula() {
    tar zxf /tmp/engula.tar.gz -C ${WDR}/bin
}

function build_scripts() {
    mkdir -p ${WDR}/scripts
    cat >${WDR}/scripts/run.sh <<EOF
#!/bin/bash
$(if [[ ${ENABLE_TCMALLOC:-false} == "true" ]]; then
        echo "export LD_PRELOAD=libtcmalloc_minimal.so.4"
    else
        echo ""
    fi)
$(if [[ ! -z ${EVENT_INTERVAL:-""} ]]; then
        echo "export ENGULA_EXECUTOR_EVENT_INTERVAL=${EVENT_INTERVAL}"
    else
        echo ""
    fi)
$(if [[ ! -z ${GLOBAL_EVENT_INTERVAL:-""} ]]; then
        echo "export ENGULA_EXECUTOR_GLOBAL_EVENT_INTERVAL=${GLOBAL_EVENT_INTERVAL}"
    else
        echo ""
    fi)
export TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=${TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES:-1073741824}
export ENGULA_ENABLE_PROXY_SERVICE=true
exec ${WDR}/bin/engula start --conf ${WDR}/config.toml >${WDR}/log 2>&1

EOF
    chmod +x ${WDR}/scripts/run.sh
}

download_engula
systemctl stop engula-${ENGULA_PORT}
extract_engula
build_scripts
systemctl start engula-${ENGULA_PORT}
