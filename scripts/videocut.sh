#!/bin/bash

BINARY="VideoCut"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '20.04') SOURCE="/app/scripts/install_videocut_repo.sh" ;;
    '22.04') SOURCE="/app/scripts/install_videocut_repo.sh" ;;
          *) bailmsg "${BINARY} is not supported in Ubuntu ${OSV}" ;;
  esac

  xterm -T InstallVideoCut -g 100x30 -e sudo ${SOURCE}
fi

${BINARY}
