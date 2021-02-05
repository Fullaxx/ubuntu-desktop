#!/bin/bash

BINARY="slack"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallSlack -g 100x30 -e sudo /app/scripts/install_slack.sh
fi

${BINARY} --no-sandbox
