#!/bin/bash

# Qalculate!: the most capable of the Utilities menu's calculators (units, symbolic math, plots)
export DEBIAN_FRONTEND="noninteractive"
BINARY="qalculate-gtk"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
