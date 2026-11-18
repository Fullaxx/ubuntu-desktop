#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://discord.com/api/download?platform=linux&format=deb"
DEB="/tmp/discord.deb"

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
# (no libgbm1: Discord's package declares it, and libasound2, itself)
apt-get update
apt-get install -y ${DEB}
rm ${DEB}
