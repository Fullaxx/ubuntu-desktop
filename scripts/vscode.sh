#!/bin/bash

BINARY="code"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

  xterm -T InstallVSCode -g 100x30 -e sudo /app/scripts/install_vscode_repo.sh
fi

${BINARY} --user-data-dir "${HOME}/vscode"
