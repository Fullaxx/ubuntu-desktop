#!/bin/bash

BINARY="firefox"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '22.04') xterm -T PrepareFirefoxPPA -g 100x30 -e sudo /app/scripts/prepare_firefox_ppa.sh ;;
          *) SOURCE="ubuntu" ;;
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
