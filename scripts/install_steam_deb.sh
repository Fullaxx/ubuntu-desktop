#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
DEB="/tmp/steam.deb"

apt-get update
# (no file libnss3 python3-apt xz-utils zenity: steam-launcher depends on them itself, and it recommends
# xdg-desktop-portal and xdg-desktop-portal-gtk, which apt installs by default)

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get install -y ${DEB}
rm ${DEB}

# Allow to run as root
sed -e 's/"$(id -u)" == "0"/`false`/' -i /usr/bin/steam
xmessage "Please be patient. Steam might take a few seconds to initialize." &
