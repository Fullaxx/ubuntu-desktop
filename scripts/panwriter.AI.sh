#!/bin/bash

BINARY="${HOME}/AI/panwriter.AppImage"

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${BINARY} ]; then
  xterm -T InstallHyper -g 100x30 -e /app/scripts/install_panwriter.AI.sh
fi

# If the app isn't there (its install failed), say so instead of nothing happening
if [ -x ${BINARY} ]; then
  ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
