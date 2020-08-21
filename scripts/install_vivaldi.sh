#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://downloads.vivaldi.com/stable/vivaldi-stable_3.2.1967.47-1_amd64.deb"
DEB="/tmp/vivaldi.deb"

apt-get update
# apt-get install -y chromium-codecs-ffmpeg-extra
apt-get install -y gnupg2 software-properties-common apt-transport-https wget chromium-codecs-ffmpeg-extra dpkg-sig
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8D04CE49EFB20B23

# wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | apt-key add -
# add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

wget ${URL} -O ${DEB}
# dpkg-sig --verify ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
