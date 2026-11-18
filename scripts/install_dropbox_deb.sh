#!/bin/bash
# https://www.dropbox.com/en/install-linux

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
DEB="/tmp/dropbox.deb"

apt-get update

apt-get install -y gnupg2 software-properties-common apt-transport-https wget
# apt-key is gone in Ubuntu 26.04: write Dropbox's repo key (1C61A2656FB57B7E4DE0F4C1FC918B335044912E)
# where apt-key used to put it; it must stay global: the package writes dropbox.list without signed-by
wget -q https://linux.dropbox.com/fedora/rpm-public-key.asc -O- | gpg --dearmor > /etc/apt/trusted.gpg.d/dropbox.gpg

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
