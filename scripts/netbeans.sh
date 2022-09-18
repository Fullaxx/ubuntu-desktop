#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
BINARY="netbeans"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '18.04') SOURCE="ubuntu" ;;
    '20.04') SOURCE="ubuntu" ;;
          *) bailmsg "Ubuntu ${OSV} not supported!"
  esac

  apt-get update
  apt-get install -y ${BINARY}
fi

${BINARY}
