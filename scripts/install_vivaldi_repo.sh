#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/vivaldi.gpg

# add-apt-repository "deb http://repo.vivaldi.com/stable/deb/ stable main"
echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list

apt-get update
apt-get install -y vivaldi-stable

# I wish there was a better way ...
source /app/scripts/wait_for_vivaldi_media_codecs.sh
