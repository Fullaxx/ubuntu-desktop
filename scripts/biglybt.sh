#!/bin/bash

BINARY="/opt/biglybt/biglybt"

if [ ! -x ${BINARY} ]; then
  xterm -T InstallBiglyBT -g 100x30 -e sudo /app/scripts/install_biglybt.sh
fi

# If the app isn't there (its install failed), say so instead of nothing happening
if [ -x ${BINARY} ]; then
  ${BINARY} >>/opt/biglybt/biglybt.log 2>&1 &
else
  xmessage "${BINARY} not found!" &
fi
