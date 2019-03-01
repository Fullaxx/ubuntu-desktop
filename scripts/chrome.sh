#!/bin/bash

URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB="/tmp/chrome.deb"

BINARY="google-chrome"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T Download -g 100x30 -e wget ${URL} -O ${DEB}
  xterm -T dPkgInstall -g 100x30 -e dpkg -i ${DEB}
  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -f -y
  rm ${DEB}
fi

# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/
${BINARY} --no-sandbox --disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization
