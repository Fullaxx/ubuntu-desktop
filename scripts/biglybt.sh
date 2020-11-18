#!/bin/bash

set -e

if [ "$1" == "NOQUIET" ]; then
  INSTTYPE="NOQUIET"
else
  INSTTYPE="QUIET"
fi

if [ ! -d /opt/biglybt ]; then
  xterm -T InstallBiglyBT -g 100x30 -e sudo /app/scripts/install_biglybt.sh ${INSTTYPE}
fi

if [ -x /opt/biglybt/biglybt ]; then
  /opt/biglybt/biglybt &
else
  xmessage "/opt/biglybt/biglybt not found!" &
fi
