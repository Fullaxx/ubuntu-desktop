#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
DEB="/tmp/steam.deb"

apt-get update
apt-get install -y file libnss3 python3-apt xdg-desktop-portal xdg-desktop-portal-gtk xz-utils zenity

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}

# Allow to run as root
sed -e 's/"$(id -u)" == "0"/`false`/' -i /usr/bin/steam
xmessage "Please be patient. Steam might take a few seconds to initialize." &
