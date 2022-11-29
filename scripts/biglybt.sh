#!/bin/bash

set -e

if [ ! -d /opt/biglybt ]; then
  xterm -T InstallBiglyBT -g 100x30 -e sudo /app/scripts/install_biglybt.sh
fi

if [ -x /opt/biglybt/biglybt ]; then
  /opt/biglybt/biglybt >>/opt/biglybt/biglybt.log 2>&1 &
else
  xmessage "/opt/biglybt/biglybt not found!" &
fi
