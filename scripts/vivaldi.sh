#!/bin/bash

URL="https://downloads.vivaldi.com/stable/vivaldi-stable_2.3.1440.57-1_amd64.deb"
DEB="/tmp/vivaldi.deb"

BINARY="vivaldi-stable"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e
#  xmessage "Installing Vivaldi ..." &
#  gxmessage "Installing Vivaldi ..." &

  xterm -T Download -g 100x30 -e wget ${URL} -O ${DEB}
  xterm -T dPkgInstall -g 100x30 -e dpkg -i ${DEB}
  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -f -y
  rm ${DEB}
fi

${BINARY} --no-sandbox
