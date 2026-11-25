#!/bin/bash

BINARY="/opt/tor/Browser/start-tor-browser"

if [ ! -x ${BINARY} ]; then
  # On failure, keep the window open so the error can be read
  xterm -T InstallTorBrowser -g 100x30 -e bash -c \
    'sudo /app/scripts/install_torbrowser.sh || read -r -p "Tor Browser install failed. Press Enter to close."'
fi

# If the app isn't there (its install failed), say so instead of nothing happening
if [ -x ${BINARY} ]; then
  exec ${BINARY} --detach
else
  xmessage "${BINARY} not found!" &
fi
