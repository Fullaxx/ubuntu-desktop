#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
# Linux Mint's Chromium build for Mint 22.3 (based on noble); its dependencies are in 26.04 too.
# Newer builds: http://packages.linuxmint.com/pool/upstream/c/chromium/ (now suffixed +mint<version>)
URL="http://packages.linuxmint.com/pool/upstream/c/chromium/chromium_157.0.8103.78~linuxmint1%2Bmint22.3_amd64.deb"
DEB="/tmp/chromium.deb"

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
# libasound2t64: /usr/lib/chromium/chromium links libasound.so.2, but Mint's package doesn't declare it
# (as of 157.0.8103.78)
apt-get update
apt-get install -y ${DEB} libasound2t64
rm ${DEB}
