#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg for the key step below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# apt-key is gone in Ubuntu 26.04: write the dearmored key where apt-key used to put it
wget -q https://deb.opera.com/archive.key -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/opera.gpg
# opera-archive.list, the file Opera's manual setup uses (https://deb.opera.com/manual.html): opera-stable
# finds its repository here and doesn't add its own opera-stable.sources, which would conflict with it
echo "deb https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera-archive.list

apt-get update
# gsettings-desktop-schemas: Opera reads the org.gnome.desktop.background schema at startup and aborts
# without it; its package doesn't depend on it
apt-get install -y opera-stable gsettings-desktop-schemas
