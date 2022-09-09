#!/bin/bash

source config.sh

# install prometheus
#
# See: https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04
version=2.37.0

if [[ $(systemctl is-active prometheus.service) == "active" ]]; then
    systemctl stop prometheus.service
    systemctl disable prometheus.service
fi

sudo useradd --no-create-home --shell /bin/false prometheus
sudo sudo mkdir /etc/prometheus
sudo sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# wget -q https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-${version}.linux-amd64.tar.gz
tar xvf prometheus-${version}.linux-amd64.tar.gz
sudo cp prometheus-${version}.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-${version}.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-${version}.linux-amd64/prometheus.yml /etc/prometheus/
sudo cp -r prometheus-${version}.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-${version}.linux-amd64/console_libraries /etc/prometheus
rm -rf prometheus-${version}.linux-amd64

SERVERS=$(printf ",'%s:${ENGULA_PORT}'" "${HOST_ENGULA_NODES[@]}")
cat >/etc/prometheus/prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'engula servers'
    scrape_interval: 15s
    metrics_path: "/admin/metrics"
    enable_http2: true
    static_configs:
      - targets: [${SERVERS:1}]
EOF

cat >/etc/systemd/system/prometheus.service <<"EOF"
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=120
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
