#!/bin/bash

URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB="/tmp/chrome.deb"

BINARY="google-chrome"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e
#  xmessage "Installing Chrome ..." &
#  gxmessage "Installing Chrome ..." &

  xterm -T Download -g 100x30 -e wget ${URL} -O ${DEB}
  xterm -T dPkgInstall -g 100x30 -e dpkg -i ${DEB}
  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -f -y
  rm ${DEB}
fi

${BINARY} --no-sandbox
