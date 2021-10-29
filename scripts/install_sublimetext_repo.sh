#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget

wget -q https://download.sublimetext.com/sublimehq-pub.gpg -O- | apt-key --keyring /etc/apt/trusted.gpg.d/sublimetext.gpg add -
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublimetext.list

apt-get update
apt-get install -y sublime-text
