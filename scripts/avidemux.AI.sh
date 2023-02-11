#!/bin/bash

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${HOME}/AI/avidemux.AppImage ]; then
  set -e

  xterm -T InstallAviDemux -g 100x30 -e /app/scripts/install_avidemux.AI.sh
fi

${HOME}/AI/avidemux.AppImage
