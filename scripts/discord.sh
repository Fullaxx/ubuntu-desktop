#!/bin/bash

BINARY="discord"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallDiscord -g 100x30 -e sudo /app/scripts/install_discord_deb.sh
fi

${BINARY} --no-sandbox --disable-gpu
