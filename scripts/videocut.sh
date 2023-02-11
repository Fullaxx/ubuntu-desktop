#!/bin/bash

BINARY="VideoCut"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallVidCutter -g 100x30 -e sudo /app/scripts/install_videocut.sh
fi

${BINARY}
