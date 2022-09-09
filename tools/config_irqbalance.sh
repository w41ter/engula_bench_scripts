#!/bin/bash

sudo apt install -y irqbalance
systemctl enable irqbalance
systemctl start irqbalance
