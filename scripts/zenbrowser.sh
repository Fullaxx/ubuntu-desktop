#!/bin/bash

BINARY="zenbrowser"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallZenBrowser -g 100x30 -e sudo /app/scripts/install_zenbrowser.sh
fi

${BINARY}
