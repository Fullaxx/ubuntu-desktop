#!/bin/bash

BINARY="/opt/cherrytree/build/cherrytree"

if [ ! -x ${BINARY} ]; then
  xterm -T CompileCherryTree -g 100x30 -e sudo /app/scripts/compile_cherrytree.sh
fi

# If the app isn't there (its install failed), say so instead of nothing happening
if [ -x ${BINARY} ]; then
  ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
