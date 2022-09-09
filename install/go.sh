#!/bin/bash

set -e

# Should download this package on local machine mannually.
# wget https://go.dev/dl/go1.19.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
if ! grep "/go/bin" ~/.bashrc; then
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
fi

