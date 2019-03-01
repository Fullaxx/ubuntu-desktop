#!/bin/bash

BINARY="code"
export DEBIAN_FRONTEND="noninteractive"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e
#  xmessage "Installing VSCode ..." &
#  gxmessage "Installing VSCode ..." &

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y gnupg2 software-properties-common apt-transport-https wget libasound2

  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
  add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

  xterm -T AptGetUpdate -g 100x30 -e apt-get update
  xterm -T AptGetInstall -g 100x30 -e apt-get install -y code
fi

${BINARY} --user-data-dir "/root/vscode"
