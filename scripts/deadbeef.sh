#!/bin/bash

BINARY="/opt/deadbeef/deadbeef"

if [ ! -x ${BINARY} ]; then
  set -e

  xterm -T InstallDeadBeef -g 100x30 -e sudo /app/scripts/install_deadbeef.sh
fi

${BINARY}
