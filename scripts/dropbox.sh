#!/bin/bash

BINARY="dropbox"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  set -e

  xterm -T InstallDropbox -g 100x30 -e sudo /app/scripts/install_dropbox_deb.sh
  # Update only if the install brought the command: set -e would otherwise end the script here, silently,
  # before the check below can say it's missing (a failed update still ends it)
  which ${BINARY} >/dev/null && ${BINARY} update
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  ${BINARY} version | xmessage -file -
else
  xmessage "${BINARY} not found!" &
fi
