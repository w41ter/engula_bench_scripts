#!/bin/bash

swapoff -a
sed -i 's/^\(.*swap.*\)$/#\1/' /etc/fstab
