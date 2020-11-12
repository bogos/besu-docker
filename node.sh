#!/bin/bash

# Set the BESU_P2P_HOST environment variable to the public IP address of your node
HOST_IP=`dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || curl -s --retry 2 icanhazip.com`
if [ -z "$HOST_IP" ]
then
  export BESU_P2P_HOST=127.0.0.1
  HOST_IP=127.0.0.1
else
  export BESU_P2P_HOST=$HOST_IP
fi
# cd to current directory
cd "$(dirname "$0")"

# Print the usage message
function printHelp() {
  echo "Usage: "
  echo "  node <mode>"
  echo "    <mode> - one of 'up', 'down', 'start', 'stop' or 'restart'"
  echo "      - 'up' - bring up the node with docker-compose up"
  echo "      - 'down' - clear the node with docker-compose down"
  echo "      - 'pause' - pause the node with docker-compose stop"
  echo "      - 'resume' - resume the node with docker-compose start"
  echo "      - 'restart' - restart the node"
}

function listEndpoints() {
  # displays services list with port mapping
  sleep 5s
  docker-compose ps
  echo "*************************************************************"
  echo "JSON-RPC HTTP service endpoint      : http://${HOST_IP}:8545"
}

function upNode() {
  echo "up node"
  echo "--------------------------"
  # create containers
  docker-compose up -d
  listEndpoints
}

function downNode() {
  echo "down node"
  echo "--------------------------"
  # remove containers
  docker-compose down -v
}

function pauseNode() {
  echo "pause node"
  echo "--------------------------"
  # stop containers
  docker-compose stop
  docker-compose ps
}

function resumeNode() {
  echo "resume node"
  echo "--------------------------"
  # start containers
  docker-compose start
  listEndpoints
}

function restartNode() {
  echo "restart node"
  echo "--------------------------"
  # restart containers
  docker-compose stop
  echo "sleeping 20s"
  sleep 20s
  docker-compose start
  listEndpoints
}

function generatateKey() {
  echo "key generation"
  docker container run -v `pwd`/keys/besu:/data -w /data -it --rm hyperledger/besu:1.4.3 --data-path=/data public-key export --to=/data/key.pub
}

if [ "$1" = "-m" ]; then # supports old usage, muscle memory is powerful!
  shift
fi
MODE=$1
shift

# Determine the mode
if [ "$MODE" == "up" ]; then
  upNode
elif [ "$MODE" == "down" ]; then
  downNode
elif [ "$MODE" == "pause" ]; then
  pauseNode
elif [ "$MODE" == "resume" ]; then
  resumeNode
elif [ "$MODE" == "restart" ]; then
  restartNode
elif [ "$MODE" == "key" ]; then
  generatateKey
else
  printHelp
  exit 1
fi

exit 0
