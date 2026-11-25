#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="quodlibet"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}

  # Ubuntu 24.04's quodlibet (4.6.0-3) doesn't depend on libmodplug1, yet stops at startup
  # without it ("AttributeError: libmodplug.so.1"); 26.04's (4.6.0-6) has the fix (Debian bug #1095175)
  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  if [ "${OSV}" == "24.04" ]; then
    xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y libmodplug1
  fi
fi

${BINARY}
