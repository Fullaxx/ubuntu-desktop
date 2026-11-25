#!/bin/bash

BINARY="subl"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallSublimeText -g 100x30 -e sudo /app/scripts/install_sublimetext_repo.sh
fi

${BINARY}
