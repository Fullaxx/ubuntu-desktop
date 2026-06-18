#!/bin/bash

######################################################
xmessage "This script is not used at the moment!" &  #
exit 1                                               #
######################################################

set -e

export DEBIAN_FRONTEND="noninteractive"
DEB="/tmp/vivaldi.deb"
KEY="/tmp/vivaldi.pub"

apt-get update
apt-get install -y gnupg2 software-properties-common apt-transport-https wget chromium-codecs-ffmpeg-extra dpkg-sig

VPKG=`curl -s https://vivaldi.com/download/ 2>/dev/null | tr '"' '\n' | grep vivaldi-stable | grep amd64.deb | head -n1`
VKEY="https://repo.vivaldi.com/stable/linux_signing_key.pub"

# gpg --keyserver keyserver.ubuntu.com --recv-keys B44B85E3E1A6386BFC79D4119658E8044A3AA3D6

wget ${VPKG} -O ${DEB}
wget ${VKEY} -O ${KEY}
gpg --import ${KEY}
dpkg-sig --verify ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
