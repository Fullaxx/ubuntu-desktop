#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

BINARY="vidcutter"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '22.04') SOURCE="/app/scripts/install_vidcutter_repo.sh" ;;
          *) bailmsg "${BINARY} is not supported in Ubuntu ${OSV}" ;;
  esac

  xterm -T InstallVidCutter -g 100x30 -e sudo ${SOURCE}
fi

${BINARY}
