#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
CMDARGS="--disable-gpu --disable-accelerated-2d-canvas --disable-gpu-rasterization"
# https://www.ghacks.net/2013/10/06/list-useful-google-chrome-command-line-switches/
# https://peter.sh/experiments/chromium-command-line-switches/

case "${OSV}" in
  '18.04') BINARY="chromium-browser" ;;
  '20.04') BINARY="chromium" ;;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  if [ "${OSV}" == "20.04" ]; then
    xterm -T PrepareDebianChromium -g 100x30 -e sudo /app/scripts/prepare_debian_chromium.sh
  fi

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

${BINARY} --no-sandbox ${CMDARGS}
