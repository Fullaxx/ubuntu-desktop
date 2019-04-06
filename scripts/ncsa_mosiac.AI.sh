#!/bin/bash

if [ ! -c /dev/fuse ]; then
  xmessage "AppImages require FUSE (run this image with --device /dev/fuse --cap-add SYS_ADMIN)" &
  exit 1
fi

if [ ! -x ${HOME}/AI/NCSA_Mosaic.AppImage ]; then
  xterm -T InstallNCSAMosaic -g 100x30 -e /app/scripts/install_ncsa_mosiac.AI.sh
fi

${HOME}/AI/NCSA_Mosaic.AppImage
