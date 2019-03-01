#!/bin/bash

VNCDIR="/root/.vnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCSTART="${VNCDIR}/xstartup"

# If a password was specified on the command line
if [ -n "${VNCPASS}" ]; then
  echo "${VNCPASS}" | vncpasswd -f > ${VNCDIR}/passwd
  if [ -n "${VNCPASSRO}" ]; then
    echo -e "${VNCPASS}\n${VNCPASS}\ny\n${VNCPASSRO}\n${VNCPASSRO}\n" | vncpasswd
  fi
  chmod 0600 ${VNCDIR}/passwd
  VNCAUTH=""
fi

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
/etc/init.d/dbus start

tigervncserver -fg -localhost no ${VNCAUTH} \
-geometry ${VNCRES} \
-depth ${VNCDEPTH} \
-xstartup ${VNCSTART}
