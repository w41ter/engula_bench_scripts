#!/bin/bash
set -ue

source config.sh
source cluster/config.sh

bash ~/cluster/node/download.sh
bash ~/cluster/node/install.sh
bash ~/cluster/node/update_config.sh
systemctl start engula-${ENGULA_PORT}.service
systemctl enable engula-${ENGULA_PORT}.service
