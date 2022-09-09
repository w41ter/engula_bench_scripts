#!/bin/bash

# config sysctl.conf
cat <<EOF >  /etc/sysctl.d/tikv.conf
net.core.somaxconn = 32768
vm.swappiness = 0
net.ipv4.tcp_syncookies = 0
fs.file-max = 1000000
EOF

sed -i '/net.ipv4.tcp_syncookies = 1/d' /etc/sysctl.conf

# config ulimits
cat <<EOF >>  /etc/security/limits.conf
root        soft        nofile        1048576
root        hard        nofile        1048576
root        soft        stack         10240
tidb        soft        nofile        1048576
tidb        hard        nofile        1048576
tidb        soft        stack         10240
EOF

sysctl --system