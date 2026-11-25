#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
BINARY="sylpheed"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  # 26.04's archive has no sylpheed
  case "${OSV}" in
    '24.04') SOURCE="ubuntu" ;;
          *) bailmsg "Ubuntu ${OSV} not supported!"
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
