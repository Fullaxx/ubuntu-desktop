#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="nextcloud"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y nextcloud-desktop
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  # Nextcloud 4 starts Qt WebEngine (Chromium), whose sandbox Docker's default seccomp profile blocks, and which
  # refuses to start as root with it ("Running as root without --no-sandbox is not supported")
  export QTWEBENGINE_DISABLE_SANDBOX=1
  exec ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
