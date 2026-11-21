#!/bin/bash
# This script runs as root
# The VNC server's settings and its files in the desktop user's HOME, for app/tiger.sh, which starts it.
# app/user.sh chose the desktop user: root (HOME=/root), or a non-root account, for which it set
# USER, GROUP and HOME

# Ubuntu 24.04's TigerVNC (1.13) uses ~/.vnc for xstartup, passwd and the session log
# (tigervncserver reads passwd from there, and vncpasswd without -f writes it there)
VNCDIR="${HOME}/.vnc"
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCSTART="${VNCDIR}/xstartup"
VNCPORT=${VNCPORT:-1}

# xstartup starts the desktop session. The image's copy is installed at every start, so a HOME kept
# on a volume gets the current image's xstartup too (changes made to the file don't last)
mkdir -p ${VNCDIR}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${VNCSTART}

# docker run's -e VNCPASS replaces "no authentication" with a password file; -e VNCPASSRO adds a
# view-only password (vncpasswd's prompts write the file again, with both)
if [ -n "${VNCPASS}" ]; then
  echo "${VNCPASS}" | vncpasswd -f > ${VNCDIR}/passwd
  if [ -n "${VNCPASSRO}" ]; then
    echo -e "${VNCPASS}\n${VNCPASS}\ny\n${VNCPASSRO}\n${VNCPASSRO}\n" | vncpasswd
  fi
  chmod 0600 ${VNCDIR}/passwd
  VNCAUTH=""
fi

# A non-root desktop user gets HOME, with everything this and the earlier stages wrote into it as
# root, and app/tiger.sh starts the server as that user (sudo -u)
if [ -n "${USER}" ]; then
  chown -R ${USER}:${GROUP} ${HOME}
  SUDOUSEROPT="-u ${USER}"
fi
