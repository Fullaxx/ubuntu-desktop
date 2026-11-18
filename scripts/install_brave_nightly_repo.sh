#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://brave-browser-apt-nightly.s3.brave.com/brave-core-nightly.asc -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg
# add-apt-repository "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main"
echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-nightly.list

apt-get update
apt-get install -y brave-browser-nightly
