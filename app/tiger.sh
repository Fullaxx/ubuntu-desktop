#!/bin/bash
# This script runs as root

# Ubuntu 26.04's TigerVNC (1.15) uses ~/.config/tigervnc for xstartup, passwd and the session log
VNCDIR="${HOME}/.config/tigervnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCSTART="${VNCDIR}/xstartup"
VNCPORT=${VNCPORT:-1}

# VNC configuration
mkdir -p ${VNCDIR}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${VNCSTART}

# If a password was specified on the command line
if [ -n "${VNCPASS}" ]; then
  echo "${VNCPASS}" | vncpasswd -f > ${VNCDIR}/passwd
  if [ -n "${VNCPASSRO}" ]; then
    echo -e "${VNCPASS}\n${VNCPASS}\ny\n${VNCPASSRO}\n${VNCPASSRO}\n" | vncpasswd
  fi
  chmod 0600 ${VNCDIR}/passwd
  VNCAUTH=""
fi

if [ -n "${USER}" ]; then
  chown -R ${USER}:${GROUP} ${HOME}
  SUDOUSEROPT="-u ${USER}"
fi

# -fg keeps tigervncserver in the foreground until the desktop session ends
# (without it, tigervncserver returns once the server is up, and the container stops)
# so ending the desktop session (log out / exit) will bring us down
# using sudo here will allow 'docker stop' to bring us down quickly
exec sudo ${SUDOUSEROPT} tigervncserver :${VNCPORT} -fg -localhost no \
${VNCAUTH} -geometry ${VNCRES} -depth ${VNCDEPTH} -xstartup ${VNCSTART}
