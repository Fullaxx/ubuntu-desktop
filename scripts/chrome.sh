#!/bin/bash

BINARY="google-chrome"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
#  xmessage "Installing Chrome ..." &
#  gxmessage "Installing Chrome ..." &

  xterm -T Download -g 100x30 -e wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  xterm -T dPkgInstall -g 100x30 -e dpkg -i google-chrome-stable_current_amd64.deb
  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -f -y
  rm *.deb
fi

${BINARY} --no-sandbox
