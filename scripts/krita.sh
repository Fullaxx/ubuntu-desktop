#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="krita"

# XXX TEMP
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
if [ "${OSV}" == "20.04" ]; then
  xmessage "${BINARY} is not supported in Ubuntu 20.04 yet" &
  exit 1
fi
# XXX TEMP

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
