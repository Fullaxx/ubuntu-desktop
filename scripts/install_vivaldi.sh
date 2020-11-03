#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://downloads.vivaldi.com/stable/vivaldi-stable_3.4.2066.90-1_amd64.deb"
DEB="/tmp/vivaldi.deb"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget chromium-codecs-ffmpeg-extra dpkg-sig

gpg --keyserver keyserver.ubuntu.com --recv-keys B44B85E3E1A6386BFC79D4119658E8044A3AA3D6
# wget -q https://repo.vivaldi.com/stable/linux_signing_key.pub -O- | apt-key add -

wget ${URL} -O ${DEB}
dpkg-sig --verify ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
