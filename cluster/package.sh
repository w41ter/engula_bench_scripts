#!/bin/bash

if [[ ! -z ${INSTALL} ]]; then
    sudo apt-get install -y cmake libclang-dev

    export RUSTUP_DIST_SERVER="https://rsproxy.cn"
    export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

    # install rust env
    curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -q -y
    source "$HOME/.cargo/env"

    # setup proxy
    cat >~/.cargo/config <<EOF
[source.crates-io]
# To use sparse index, change 'rsproxy' to 'rsproxy-sparse'
replace-with = 'rsproxy'

[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"

[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF

    git clone https://github.com/w41ter/engula.go
fi

cd engula

if [[ ! -z ${INSTALL} ]]; then
    mkdir -p .cargo

    cat >.cargo/config.toml <<EOF
[profile.release]
debug = 1

[build]
rustflags = ["-Cforce-frame-pointers=yes"]
EOF
fi

cargo build --release
cd ./target/release/
tar zcf engula.tar.gz engula

# copy to enginx
cp engula.tar.gz /var/www/html/

