#!/bin/bash

BINARY="opera"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallOpera -g 100x30 -e sudo /app/scripts/install_opera_repo.sh
fi

${BINARY} --no-sandbox --disable-gpu
