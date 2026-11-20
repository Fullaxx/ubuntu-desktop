#!/bin/bash

BINARY="strawberry"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  # install_strawberry_ppa.sh is the add-apt-repository version, kept for when the PPA's key changes
  xterm -T InstallStrawberry -g 100x30 -e sudo /app/scripts/install_strawberry_ppa_direct.sh
fi

${BINARY}
