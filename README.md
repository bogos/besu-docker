# Alastria Besu Regular Node

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

This repository is based on the [Alastria Node Besu](https://github.com/alastria/alastria-node-besu) repository. This repository contains code and documentations needed to deploy private besu node on Alastria Network B.

## Prerequisites

You need to install Docker and Docker Compose. I have put the [installation guidelines](requirements.md) to make it easy for you.

## Deployment

1. Clone the repository.
   ```
   git clone https://github.com/b-rohit/alastria-regular-node-besu.git
   ```
2. Generate private and public for besu node

   ```
   cd alastria-regular-node-besu
   ./node.sh key
   ```

   This is one time operation. The aforementioned command will run a docker container with [hyperledger/besu](https://hub.docker.com/r/hyperledger/besu) image and generate keys in key folder in the current directory. Keep your private key safe, do not reveal it.

3. Launch Node
   ```
   ./node.sh up
   ```
   The command will spin up 3 docker containers namely besu, prometheus, and explorer. The besu container is the most important of all as it is your regular besu node. The [config.toml](config/besu/config.toml) and [genesis.json](config/besu/genesis.json) files are used to configure the besu node. You can make changes in the config.toml file to change the behavior of the node. You don’t need to touch the genesis.json file. The command will give output similar to following
   ```
   Starting besu       ... done
   Starting prometheus ... done
   Starting explorer   ... done
      Name                 Command               State                                                          Ports
   ------------------------------------------------------------------------------------------------------------------------------------------
   besu         besu --config-file=/config ...   Up      0.0.0.0:30303->30303/tcp, 0.0.0.0:30303->30303/udp, 0.0.0.0:8545->8545/tcp,8546/tcp,
                                                         8547/tcp, 0.0.0.0:9545->9545/tcp
   explorer     ./entrypoint.sh nginx -g d ...   Up      0.0.0.0:8080->80/tcp
   prometheus   /bin/prometheus --config.f ...   Up      0.0.0.0:9090->9090/tcp
   *************************************************************
   JSON-RPC HTTP service endpoint      : http://127.0.0.1:8545
   Web block explorer address          : http://127.0.0.1:8080/
   Prometheus address                  : http://127.0.0.1:9090/graph
   ```

## Registration

After successful deployment, you need to register the node to access the Alastria Network B because it is a private permissioned blockchain network. The steps are following:

1. Get your enode
   ```
   curl -X POST --data '{"jsonrpc":"2.0","method":"net_enode","params":[],"id":1}' http://127.0.0.1:8545
   ```
2. Fill in the [electronic form](https://portal.r2docuo.com/alastria/forms/noderequest) and submit.

## Systemd Service

Although it is an optional step, it is quite useful to manage your docker containers using a service. The service will stop the containers during system shutdown and start them again automatically on system startup without loosing container data. The steps to configure the service are following:

1. Set the repo path in the besu-node.service and copy it to /etc/systemd/system
   ```
   sudo cp service/besu-node.service /etc/systemd/system
   ```
2. Enable the service

   ```
   sudo systemctl enable besu-node
   ```

This is all. It will enable the service to manage the containers at system reboot. You can start, stop, and check status of the service using following commands.

```
sudo systemctl start besu-node
sudo systemctl stop besu-node
sudo systemctl status besu-node
```

## Usage

You can interact with the besu node using [HTTP JSON RPC requests](https://besu.hyperledger.org/en/stable/Reference/API-Methods/) on port 8545. The Prometheus and Block Explorer dashboards can be accessed on http://127.0.0.1:9090 and http://127.0.0.1:8080 respectively.
