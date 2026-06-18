#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="http://packages.linuxmint.com/pool/upstream/c/chromium/chromium_140.0.7339.127~linuxmint1%2Bzara_amd64.deb"
DEB="/tmp/chromium.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y; apt-get install -y libasound2t64)
rm ${DEB}
