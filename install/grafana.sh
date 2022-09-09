#!/bin/bash

# install grafana oss version
# wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
# echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list


# sudo apt-get update
# sudo apt-get install -y grafana

# download dep directly:
#       https://dl.grafana.com/enterprise/release/grafana-enterprise_9.1.1_amd64.deb
sudo dpkg -i grafana-enterprise_9.1.1_amd64.deb

sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
