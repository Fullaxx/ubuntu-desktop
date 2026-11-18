#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg for the key step below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://brave-browser-apt-beta.s3.brave.com/brave-core-nightly.asc -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg
echo "deb [arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" > /etc/apt/sources.list.d/brave-browser-beta.list

apt-get update
apt-get install -y brave-browser-beta
