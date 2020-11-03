#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget chromium-codecs-ffmpeg-extra

# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B44B85E3E1A6386BFC79D4119658E8044A3AA3D6
wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | apt-key --keyring /etc/apt/trusted.gpg.d/vivaldi.gpg add -

# add-apt-repository "deb http://repo.vivaldi.com/stable/deb/ stable main"
echo "deb http://repo.vivaldi.com/stable/deb/ stable main" > /etc/apt/sources.list.d/vivaldi.list

apt-get update
apt-get install -y vivaldi-stable
