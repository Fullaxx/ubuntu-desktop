#!/bin/bash

BINARY="firefox"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  # prepare_firefox_ppa.sh is the add-apt-repository version, kept for when the PPA's key changes
  case "${OSV}" in
    '26.04') xterm -T PrepareFirefoxPPA -g 100x30 -e sudo /app/scripts/prepare_firefox_ppa_direct.sh ;;
    '24.04') xterm -T PrepareFirefoxPPA -g 100x30 -e sudo /app/scripts/prepare_firefox_ppa_direct.sh ;;
    '22.04') xterm -T PrepareFirefoxPPA -g 100x30 -e sudo /app/scripts/prepare_firefox_ppa_direct.sh ;;
          *) SOURCE="ubuntu" ;;
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY}
