#!/bin/bash

BINARY="vivaldi-stable"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallVivaldi -g 100x30 -e sudo /app/scripts/install_vivaldi.sh
fi

if [ -n "${USER}" ]; then
  ${BINARY}
else
  ${BINARY} --no-sandbox
fi
