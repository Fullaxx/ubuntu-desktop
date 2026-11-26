#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="quodlibet"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}

  # Ubuntu 24.04's quodlibet (4.6.0-3) doesn't depend on libmodplug1, yet stops at startup
  # without it ("AttributeError: libmodplug.so.1"); 26.04's (4.6.0-6) has the fix (Debian bug #1095175)
  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  if [ "${OSV}" == "24.04" ]; then
    xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y libmodplug1
  fi
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
