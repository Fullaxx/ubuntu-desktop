#!/bin/bash

BINARY="dropbox"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallDropbox -g 100x30 -e sudo /app/scripts/install_dropbox.sh
  dropbox update
fi

xterm -T DropboxStatus -g 100x30 -e ${BINARY} status
xterm -T DropboxVersion -g 100x30 -e ${BINARY} version
