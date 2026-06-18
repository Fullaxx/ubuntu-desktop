#!/bin/bash

BINARY="strawberry"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallStrawberry -g 100x30 -e sudo /app/scripts/install_strawberry_ppa.sh
fi

${BINARY}
