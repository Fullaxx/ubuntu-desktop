#!/bin/bash

privwarn()
{
	rm -f /tmp/privwarn.txt
	echo "It would appear that you are not running this container in privileged mode" >> /tmp/privwarn.txt
	echo "FlatPaks require privileged mode (run this container with --privileged)" >> /tmp/privwarn.txt
	xmessage -file /tmp/privwarn.txt &
}

fperr()
{
	rm -f /tmp/fperr.txt
	echo "FlatPak failed to run GST" >> /tmp/fperr.txt
	echo "The most likely cause of this is that this container was not run in privileged mode" >> /tmp/fperr.txt
	echo "FlatPaks require privileged mode (run this container with --privileged)" >> /tmp/fperr.txt
	xmessage -file /tmp/fperr.txt &
}

# HOW DO I CHECK FOR PRIVILEGED MODE??
# https://stackoverflow.com/questions/32144575/how-to-know-if-a-docker-container-is-running-in-privileged-mode
DEVITEMS=`find /dev | wc -l`
if [ ${DEVITEMS} -lt 32 ]; then
  privwarn
fi

BINARYLOC=`which flatpak`
if [ "$?" -ne "0" ]; then
  INSTALLGST="1"
fi

if ! flatpak info com.leinardi.gst >/dev/null 2>&1 ; then
  INSTALLGST="1"
fi

if [ "${INSTALLGST}" == "1" ]; then
  xterm -T InstallGST -g 100x30 -e /app/scripts/install_gst.FP.sh
fi

flatpak run com.leinardi.gst || fperr
