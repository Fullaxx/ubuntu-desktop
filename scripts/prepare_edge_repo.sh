#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y apt-transport-https gnupg2 software-properties-common wget

if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O - | gpg --dearmor > /usr/share/keyrings/microsoft.gpg
fi

if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list
fi
