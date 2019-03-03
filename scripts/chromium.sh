#!/bin/bash

BINARY="chromium-browser"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y ${BINARY}
fi

# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/
${BINARY} --no-sandbox --disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization
