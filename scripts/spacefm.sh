#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="spacefm"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '18.04') PKGS="lsof sshfs spacefm-gtk3" ;;
    '20.04') PKGS="lsof sshfs spacefm-gtk3 yaru-theme-icon" ;;
          *) bailmsg "Ubuntu ${OSV} not supported!"
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${PKGS}
fi

${BINARY}
