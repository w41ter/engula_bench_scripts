#!/bin/bash

# This script is the common part of setup of machines.


bash install/common.sh

# add nodelalloc,noatime
bash tools/config_ext4.sh

bash tools/config_irqbalance.sh
bash tools/config_kernel.sh
bash tools/disable_swap.sh

# disable THP: https://pingcap.com/zh/blog/why-should-we-disable-thp
bash tools/disable_thp.sh
