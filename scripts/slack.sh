#!/bin/bash

BINARY="slack"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallSlack -g 100x30 -e sudo /app/scripts/install_slack_deb.sh
fi

${BINARY} --no-sandbox --disable-gpu
