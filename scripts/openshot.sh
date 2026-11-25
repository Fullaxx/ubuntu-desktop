#!/bin/bash

BINARY="openshot-qt"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  # install_openshot_ppa.sh is the add-apt-repository version (daily PPA), kept for when the PPA's key changes
  xterm -T InstallOpenShot -g 100x30 -e sudo /app/scripts/install_openshot_ppa_direct.sh
fi

${BINARY}
