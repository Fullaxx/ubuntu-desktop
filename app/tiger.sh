#!/bin/bash
# This script runs as root
# Start the VNC server as the desktop user (app/user.sh), with the settings from app/prepare.sh

# Start the desktop session in the session user's home: sudo keeps this working directory, so the
# session and the programs it starts (a terminal, for example) begin in HOME instead of /
cd ${HOME}

# -fg keeps tigervncserver in the foreground until the desktop session ends
# (without it, tigervncserver returns once the server is up, and the container stops)
# so ending the desktop session (log out / exit) will bring us down
# using sudo here will allow 'docker stop' to bring us down quickly
exec sudo ${SUDOUSEROPT} tigervncserver :${VNCPORT} -fg -localhost no \
${VNCAUTH} -geometry ${VNCRES} -depth ${VNCDEPTH} -xstartup ${VNCSTART}
