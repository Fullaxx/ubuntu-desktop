#!/bin/bash

BINARY="/opt/cherrytree/build/cherrytree"

if [ ! -x ${BINARY} ]; then
  xterm -T CompileCherryTree -g 100x30 -e sudo /app/scripts/compile_cherrytree.sh
fi

${BINARY}
