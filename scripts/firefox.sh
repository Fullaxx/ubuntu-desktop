#!/bin/bash

BINARY="firefox"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '22.04') xterm -T InstallFirefox -g 100x30 -e sudo /app/scripts/install_firefox_repo.sh ;;
          *) xterm -T InstallFirefox -g 100x30 -e sudo /app/scripts/install_firefox.sh ;;
  esac
fi

${BINARY}
