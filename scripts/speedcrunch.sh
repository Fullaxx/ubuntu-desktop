#!/bin/bash

# SpeedCrunch: keyboard-driven and high-precision, one of the Utilities menu's calculators
export DEBIAN_FRONTEND="noninteractive"
BINARY="speedcrunch"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
