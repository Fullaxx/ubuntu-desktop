#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg for the key step below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/vivaldi.gpg

echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list

apt-get update
apt-get install -y vivaldi-stable

# vivaldi-stable sets up its own repository (vivaldi.sources, signed by its own keyring in /usr/share/keyrings),
# so the bootstrap source and key above would make apt see the repository twice (W: warnings): drop them
if [ -f /etc/apt/sources.list.d/vivaldi.sources ]; then
  rm -f /etc/apt/sources.list.d/vivaldi.list /etc/apt/trusted.gpg.d/vivaldi.gpg
fi

# I wish there was a better way ...
source /app/scripts/wait_for_vivaldi_media_codecs.sh
