#!/bin/bash

BINARY="openshot-qt"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  # install_openshot_ppa.sh is the add-apt-repository version (daily PPA), kept for when the PPA's key changes
  xterm -T InstallOpenShot -g 100x30 -e sudo /app/scripts/install_openshot_ppa_direct.sh
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  exec ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
