#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg for the key step below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O - | gpg --dearmor > /usr/share/keyrings/microsoft.gpg
fi

if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list
fi
