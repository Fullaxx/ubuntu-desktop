#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="gftp"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  # gftp starts its GTK client if it's there (24.04), and its text client otherwise (26.04, where Debian
  # dropped gftp-gtk, bug #967390). The text client has no window of its own, so it runs in an xterm like
  # PowerShell's: the same colors and TrueType monospace font, titled gFTP
  if which gftp-gtk >/dev/null; then
    exec ${BINARY}
  else
    exec xterm -T gFTP -g 100x30 -bg '#012456' -fg '#CCCCCC' -cr '#FFFFFF' -fa Monospace -fs 11 -e gftp-text
  fi
else
  xmessage "${BINARY} not found!" &
fi
