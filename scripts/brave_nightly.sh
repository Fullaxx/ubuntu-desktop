#!/bin/bash

BINARY="brave-browser-nightly"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallBraveNightly -g 100x30 -e sudo /app/scripts/install_brave_nightly_repo.sh
fi

${BINARY} --no-sandbox --disable-gpu
