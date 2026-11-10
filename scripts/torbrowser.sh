#!/bin/bash

TORBROWSER="/opt/tor/Browser/start-tor-browser"

if [ ! -x "${TORBROWSER}" ]; then
  # On failure, keep the window open so the error can be read
  xterm -T InstallTorBrowser -g 100x30 -e bash -c \
    'sudo /app/scripts/install_torbrowser.sh || read -r -p "Tor Browser install failed. Press Enter to close."'
fi

if [ ! -x "${TORBROWSER}" ]; then
  exit 1
fi

exec "${TORBROWSER}" --detach
