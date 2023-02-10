#!/bin/bash

BINARY="vidcutter"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallVidCutter -g 100x30 -e sudo /app/scripts/install_vidcutter.sh
fi

${BINARY}
