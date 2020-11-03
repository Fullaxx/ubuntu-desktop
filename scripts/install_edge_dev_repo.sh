#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key --keyring /etc/apt/trusted.gpg.d/microsoft.gpg add -
# add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list

apt-get update
apt-get install -y microsoft-edge-dev
