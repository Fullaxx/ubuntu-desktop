#!/bin/bash

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${HOME}/AI/pktsender.AppImage ]; then
  xterm -T InstallPktSender -g 100x30 -e /app/scripts/install_pktsender.AI.sh
fi

${HOME}/AI/pktsender.AppImage
