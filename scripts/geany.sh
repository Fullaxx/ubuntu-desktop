#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="geany"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y build-essential ${BINARY}
fi

${BINARY}
