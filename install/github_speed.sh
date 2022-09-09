#!/bin/bash

cat >>/etc/hosts <<EOF
# GitHub Start
140.82.113.4      github.com
140.82.114.4      github.com
140.82.113.4      gist.github.com
140.82.113.6      api.github.com
185.199.108.153   assets-cdn.github.com
185.199.109.153   assets-cdn.github.com
185.199.110.153   assets-cdn.github.com
185.199.111.153   assets-cdn.github.com
199.232.96.133    raw.githubusercontent.com
199.232.96.133    gist.githubusercontent.com
199.232.96.133    cloud.githubusercontent.com
199.232.96.133    camo.githubusercontent.com
199.232.96.133    avatars.githubusercontent.com
199.232.96.133    avatars0.githubusercontent.com
199.232.96.133    avatars1.githubusercontent.com
199.232.96.133    avatars2.githubusercontent.com
199.232.96.133    avatars3.githubusercontent.com
199.232.96.133    avatars4.githubusercontent.com
199.232.96.133    avatars5.githubusercontent.com
199.232.96.133    avatars6.githubusercontent.com
199.232.96.133    avatars7.githubusercontent.com
199.232.96.133    avatars8.githubusercontent.com
199.232.96.133    user-images.githubusercontent.com
# GitHub End
EOF
