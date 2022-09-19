#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="eclipse_java"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallEclipseJAVA -g 100x30 -e sudo ECLPKG="JAVA" /app/scripts/install_eclipse.sh
fi

${BINARY}
