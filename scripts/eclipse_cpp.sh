#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="eclipse_cpp"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallEclipseCPP -g 100x30 -e sudo ECLPKG="CPP" /app/scripts/install_eclipse.sh
fi

${BINARY}
