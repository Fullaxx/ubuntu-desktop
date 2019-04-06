#!/bin/bash

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${HOME}/AI/Archipelago.AppImage ]; then
  xterm -T InstallArchipelago -g 100x30 -e /app/scripts/install_archipelago.AI.sh
fi

${HOME}/AI/Archipelago.AppImage
