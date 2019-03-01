#!/bin/bash

BINARY="gedit"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
#  xmessage "Installing Gedit ..." &
#  gxmessage "Installing Gedit ..." &

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y gedit
fi

${BINARY}
