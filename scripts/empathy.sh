#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
BINARY="empathy"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '24.04') bailmsg "${BINARY} is not supported in Ubuntu ${OSV}" ;;
          *) SOURCE="ubuntu" ;;
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
