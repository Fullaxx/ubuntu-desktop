#!/bin/bash

BINARY="bluefish"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e
#  xmessage "Installing Bluefish ..." &
#  gxmessage "Installing Bluefish ..." &

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y ${BINARY}
fi

${BINARY}
