#!/bin/bash

BINARY="google-chrome-stable"
CMDARGS="--disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization"
# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallChrome -g 100x30 -e sudo /app/scripts/install_chrome.sh
fi

${BINARY} --no-sandbox ${CMDARGS}
