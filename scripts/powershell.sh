#!/bin/bash

BINARY="pwsh"

# XXX TEMP
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
if [ "${OSV}" == "20.04" ]; then
  xmessage "Powershell is not supported in Ubuntu 20.04 yet" &
  exit 1
fi
# XXX TEMP

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallPowerShell -g 100x30 -e sudo /app/scripts/install_powershell.sh
fi

xterm -T InstallPowerShell -e ${BINARY}
