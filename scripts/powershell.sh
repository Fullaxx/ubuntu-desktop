#!/bin/bash

BINARY="pwsh"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallPowerShell -g 100x30 -e sudo /app/scripts/install_powershell.sh
fi

xterm -T InstallPowerShell -e ${BINARY}
