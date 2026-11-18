#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
# Linux Mint's Chromium build for Mint 22.3 (based on noble); its dependencies are in 26.04 too.
# Newer builds: http://packages.linuxmint.com/pool/upstream/c/chromium/ (now suffixed +mint<version>)
URL="http://packages.linuxmint.com/pool/upstream/c/chromium/chromium_157.0.8103.78~linuxmint1%2Bmint22.3_amd64.deb"
DEB="/tmp/chromium.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y; apt-get install -y libasound2t64)
rm ${DEB}
