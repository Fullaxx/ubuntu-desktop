#!/bin/bash

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${HOME}/AI/LibreOffice-fresh.AppImage ]; then
  xterm -T InstallHyper -g 100x30 -e /app/scripts/install_libreoffice.AI.sh
fi

${HOME}/AI/LibreOffice-fresh.AppImage
