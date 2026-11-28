#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"
BINARY="guake"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  # gsettings-desktop-schemas: Guake reads desktop settings, such as the system's monospace font, from the
  # schemas this package installs (org.gnome.desktop.interface). Ubuntu's guake package doesn't depend on it,
  # and without it Guake aborts at start ("Settings schema 'org.gnome.desktop.interface' is not installed")
  # dconf-cli: Guake runs the dconf command when it starts (to carry over an older Guake's settings) and for its
  # --save-preferences and --restore-preferences options, which fail without it
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY} gsettings-desktop-schemas dconf-cli
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
# --show: Guake starts hidden, waiting for its F12 key, so this opens its window at once; when Guake is
# already running it shows that window (plain guake would toggle it, hiding an open window)
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  exec ${BINARY} --show
else
  xmessage "${BINARY} not found!" &
fi
