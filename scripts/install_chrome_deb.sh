#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB="/tmp/chrome.deb"

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get update
apt-get install -y ${DEB}
rm ${DEB}
