#!/bin/bash

BINARY="steam"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallSteam -g 100x30 -e sudo /app/scripts/install_steam.sh
fi

${BINARY}
