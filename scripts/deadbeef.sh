#!/bin/bash

BINARY="/opt/deadbeef/deadbeef"

if [ ! -x ${BINARY} ]; then
  xterm -T InstallDeadBeef -g 100x30 -e sudo /app/scripts/install_deadbeef.sh
fi

# If the app isn't there (its install failed), say so instead of nothing happening
if [ -x ${BINARY} ]; then
  ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
