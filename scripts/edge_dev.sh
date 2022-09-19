#!/bin/bash

BINARY="microsoft-edge-dev"
CMDARGS="--disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization"
# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T PrepareEdgeDevRepo -g 100x30 -e sudo /app/scripts/prepare_edge_dev_repo.sh
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY} --no-sandbox ${CMDARGS}
