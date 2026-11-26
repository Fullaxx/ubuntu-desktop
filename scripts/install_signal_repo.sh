#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg to dearmor the key below, wget for the downloads; no apt-transport-https (https is built into apt
# since 1.5) or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# Signal's own setup (https://signal.org/download/linux/): its key in /usr/share/keyrings, and its deb822
# .sources file, which names that key in Signed-By, so the key is trusted for this repository only.
# Signal's package adds no source of its own, so this one stays
wget -q https://updates.signal.org/desktop/apt/keys.asc -O- | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg
wget -q https://updates.signal.org/static/desktop/apt/signal-desktop.sources -O /etc/apt/sources.list.d/signal-desktop.sources

apt-get update
apt-get install -y signal-desktop
