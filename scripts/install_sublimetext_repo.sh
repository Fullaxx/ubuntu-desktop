#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg for the key step below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://download.sublimetext.com/sublimehq-pub.gpg -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/sublimetext.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublimetext.list

apt-get update
apt-get install -y sublime-text
