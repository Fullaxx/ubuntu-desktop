#!/bin/bash

BINARY="vivaldi-stable"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
#  xmessage "Installing Vivaldi ..." &
#  gxmessage "Installing Vivaldi ..." &

  xterm -T Download -g 100x30 -e wget https://downloads.vivaldi.com/stable/vivaldi-stable_2.3.1440.57-1_amd64.deb
  xterm -T dPkgInstall -g 100x30 -e dpkg -i vivaldi-stable_*_amd64.deb
  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -f -y
  rm *.deb
fi

${BINARY} --no-sandbox
