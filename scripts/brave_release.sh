#!/bin/bash

BINARY="brave-browser-stable"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallBraveRelease -g 100x30 -e sudo /app/scripts/install_brave_release_repo.sh
fi

${BINARY} --no-sandbox --disable-gpu
