#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg to dearmor the key below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# What this script wrote before: a one-line source, and a key apt trusted for every repository
rm -f /etc/apt/sources.list.d/vivaldi.list /etc/apt/trusted.gpg.d/vivaldi.gpg

# vivaldi-stable sets up its own repository when it installs (vivaldi.sources, signed by its own keyring in
# /usr/share/keyrings), so this script's source is only a bootstrap: a deb822 .sources file with a key of its
# own, removed again below. None is written if vivaldi.sources is already there (Vivaldi was installed
# before): for the same address with a second Signed-By value, apt would refuse to update
if [ ! -f /etc/apt/sources.list.d/vivaldi.sources ]; then
  install -d -m 0755 /etc/apt/keyrings
  wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | gpg --dearmor > /etc/apt/keyrings/vivaldi-bootstrap.gpg
  cat > /etc/apt/sources.list.d/vivaldi-bootstrap.sources <<EOF
Types: deb
URIs: https://repo.vivaldi.com/stable/deb/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/vivaldi-bootstrap.gpg
EOF
fi

apt-get update
apt-get install -y vivaldi-stable

# The package's own source has priority: drop the bootstrap
if [ -f /etc/apt/sources.list.d/vivaldi.sources ]; then
  rm -f /etc/apt/sources.list.d/vivaldi-bootstrap.sources /etc/apt/keyrings/vivaldi-bootstrap.gpg
fi

# I wish there was a better way ...
source /app/scripts/wait_for_vivaldi_media_codecs.sh
