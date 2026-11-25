#!/bin/bash

BINARY="veracrypt"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallVeraCrypt -g 100x30 -e sudo /app/scripts/install_veracrypt_deb.sh
fi

${BINARY}
