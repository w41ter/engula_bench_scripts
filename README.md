# Benchmark setup scripts

## Setup

Fill in the `config.sh` according to the template file (`config-template`):

```sh
cp config-template config.sh
vim config.sh
```

Initialize the link between machines:

```sh
bash connection_setup.sh
```

If there is an unmounted local disk, mount it first (please modify the script yourself):

```sh
bash ssd_setup.sh
```

Transfer the scripts to the central node and initialize the machines in the cluster:

```sh
bash copy_to_central.sh
source config.sh
ssh ${USER}@${HOST_CENTRAL} "bash central_setup.sh"
```

## Deploy

TODO

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

