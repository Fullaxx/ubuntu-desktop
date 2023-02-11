#!/bin/bash

BINARY="openshot-qt"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallOpenShot -g 100x30 -e sudo /app/scripts/install_openshot.sh
fi

${BINARY}
