# Benchmark setup scripts

## Topo

- central node: the control node which would connect to WWW.
- engula server nodes: a set of node which contains an unmounted local disk.
- go-ycsb node: a set of node to run go-ycsb client.

## Setup

Fill in the `config.sh` according to the template file (`config-template`):

```sh
cp config-template config.sh
vim config.sh
```

Initialize the link between machines:

```sh
bash setup_connection.sh
```

If there is an unmounted local disk, mount it first (default mountpoint is '/mnt', please modify the script yourself):

```sh
bash setup_ssd.sh
```

Transfer the scripts to the central node and initialize the machines in the cluster:

```sh
bash copy_to_central.sh
source config.sh
ssh ${USER}@${HOST_CENTRAL} "bash setup_central.sh"
```

> Since the network connection isn't good, you might download the binaries to local and upload them to central node:
> 
> ```sh
> # download & compile bianries
> # - prometheus
> # - grafana
> # - go-ycsb: https://github.com/w41ter/go-ycsb.git
> # - engula
> #
> # then
> UPLOAD_BINARY=all bash copy_to_central.sh
> ```
>
> See copy_to_central.sh for details.

## Deploy

1. Clone engula repo and build

```sh
git clone https://github.com/engula/engula.git
cd engula
cargo build --release
```

2. package and upload it to a http server(nginx is setted at the central node):

```sh
cd ./target/release/
tar zcf engula.tar.gz engula

# copy to enginx
cp engula.tar.gz /var/www/html/
```

3. Deploy

```sh
bash cluster/deploy.sh
```

## Bench

The next steps will be done on the ycsb worker node.

```sh
ssh ${USER}@${HOST_CENTRAL}
source config.sh
ssh ${USER}@${HOST_YCSB}
```

Generate `config.sh` according to the template (`bench/config-template`):

```sh
cp bench/config-template bench/config.sh
vim config.sh
```

Do it:

```sh
bash bench/do.sh
```

