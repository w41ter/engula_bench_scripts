#!/bin/bash

source config.sh
source cluster/config.sh

systemctl stop engula-${ENGULA_PORT}.service
systemctl disable engula-${ENGULA_PORT}.service
rm -rf /etc/systemd/system/engula-${ENGULA_PORT}.service
systemctl daemon-reload

WDR=${DEPLOY_DIR}/engula-${ENGULA_PORT}/
rm -rf ${WDR}/
