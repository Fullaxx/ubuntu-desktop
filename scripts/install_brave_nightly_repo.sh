#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

wget -q https://brave-browser-apt-nightly.s3.brave.com/brave-core-nightly.asc -O- | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg add -
# add-apt-repository "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main"
echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-nightly.list

apt-get update
apt-get install -y brave-browser-nightly
