#!/bin/bash
# This script runs as root
# The VNC server's files in the desktop user's HOME, for app/tiger.sh, which starts it.
# app/useracct.sh chose the desktop user: root (HOME=/root), or a non-root account, for which it
# set USER, GROUP and HOME. VNCDIR, their folder in HOME, is set in app/app.sh with the server's
# other settings

# xstartup starts the desktop session. The image's copy is installed at every start, so a HOME kept
# on a volume gets the current image's xstartup too (changes made to the file don't last)
mkdir -p ${HOME}/${VNCDIR}
install -m 0755 /usr/share/ubuntu-desktop/vnc/xstartup ${HOME}/${VNCDIR}/xstartup

# docker run's -e VNCPASS: the password file the server asks for, since app/app.sh's VNCAUTH then
# leaves "no authentication" out; -e VNCPASSRO adds a view-only password (vncpasswd's prompts write
# the file again, with both)
if [ -n "${VNCPASS}" ]; then
  echo "${VNCPASS}" | vncpasswd -f > ${HOME}/${VNCDIR}/passwd
  if [ -n "${VNCPASSRO}" ]; then
    echo -e "${VNCPASS}\n${VNCPASS}\ny\n${VNCPASSRO}\n${VNCPASSRO}\n" | vncpasswd
  fi
  chmod 0600 ${HOME}/${VNCDIR}/passwd
fi

# A non-root desktop user gets HOME, with everything this and the earlier stages wrote into it as
# root, and app/tiger.sh starts the server as that user (sudo -u)
if [ -n "${USER}" ]; then
  chown -R ${USER}:${GROUP} ${HOME}
fi
