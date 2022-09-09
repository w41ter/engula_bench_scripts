#!/bin/bash

wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
git clone https://github.com/pingcap/go-ycsb.git
cd go-ycsb
make
