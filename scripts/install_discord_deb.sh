#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://discord.com/api/download?platform=linux&format=deb"
DEB="/tmp/discord.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y; apt-get install -y libgbm1)
rm ${DEB}
