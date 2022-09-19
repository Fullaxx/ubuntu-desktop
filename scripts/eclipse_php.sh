#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="eclipse_php"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallEclipsePHP -g 100x30 -e sudo ECLPKG="PHP" /app/scripts/install_eclipse.sh
fi

${BINARY}
