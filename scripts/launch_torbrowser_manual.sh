#!/bin/bash

set -e

if [ ! -x /opt/tor/start-tor-browser.desktop ]; then
  xterm -T InstallTorBrowserManual -g 100x30 -e sudo /app/scripts/install_torbrowser_manual.sh
fi

cd /opt/tor/
./start-tor-browser.desktop
