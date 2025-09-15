#!/bin/bash
# This script is specific to ubuntu:24.04 (noble)

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
CMDARGS="--disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization"
# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/

BINARY="chromium"
BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e
  xterm -T InstallChromium -g 100x30 -e sudo /app/scripts/install_chromium_mintzara.sh
fi

${BINARY} --no-sandbox ${CMDARGS}
