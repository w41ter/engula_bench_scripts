#!/bin/bash

# https://www.mongodb.com/docs/v5.0/tutorial/transparent-huge-pages/#create-the-systemd-unit-file
# verify by: systemd-analyze critical-chain

cat >/etc/systemd/system/disable-transparent-huge-pages.service <<"EOF"
[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=mongod.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null; echo never | tee /sys/kernel/mm/transparent_hugepage/defrag > /dev/null'

[Install]
WantedBy=basic.target
EOF

sudo systemctl daemon-reload
sudo systemctl start disable-transparent-huge-pages
sudo systemctl enable disable-transparent-huge-pages
