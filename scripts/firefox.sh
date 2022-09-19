#!/bin/bash

BINARY="firefox"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '22.04') INSTALLSCRIPT="/app/scripts/install_firefox_repo.sh" ;;
          *) INSTALLSCRIPT="/app/scripts/install_firefox.sh" ;;
  esac

  xterm -T InstallFirefox -g 100x30 -e sudo ${INSTALLSCRIPT}
fi

${BINARY}
