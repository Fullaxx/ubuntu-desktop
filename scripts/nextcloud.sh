#!/bin/bash

BINARY="nextcloud"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  # From the Nextcloud team's PPA, not Ubuntu's archive (see install_nextcloud_ppa_direct.sh)
  xterm -T InstallNextcloud -g 100x30 -e sudo /app/scripts/install_nextcloud_ppa_direct.sh
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  # The PPA's Nextcloud doesn't use Qt WebEngine, so unlike Ubuntu's 4.0.6 it needs no QTWEBENGINE_DISABLE_SANDBOX
  exec ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
