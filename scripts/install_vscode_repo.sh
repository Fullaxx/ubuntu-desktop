#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget libasound2

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
# add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/microsoft-vscode.list

apt-get update
apt-get install -y code
