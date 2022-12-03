#!/bin/bash

BINARY="palemoon"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallVivaldi -g 100x30 -e sudo /app/scripts/install_palemoon.sh
fi

${BINARY}
