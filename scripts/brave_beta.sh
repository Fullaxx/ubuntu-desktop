#!/bin/bash

BINARY="brave-browser-beta"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallBraveBeta -g 100x30 -e sudo /app/scripts/install_brave_beta_repo.sh
fi

${BINARY} --no-sandbox --disable-gpu
