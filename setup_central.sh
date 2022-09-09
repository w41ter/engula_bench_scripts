#!/bin/bash

source config.sh

echo "install softwares ..."
bash setup_node.sh
bash install/prometheus.sh
bash install/grafana.sh
bash install/nginx.sh

cp engula.tar.gz /var/www/html/

echo "begin setup private nodes ..."
bash copy_to_node.sh

for host in ${HOSTS_PRIVATE[@]}; do
    ssh ${USER}@${host} 'bash setup_node.sh' </dev/null &
done
wait
