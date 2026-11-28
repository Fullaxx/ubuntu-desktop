#!/bin/bash
# This script runs as root
# The stages below are sourced into this one shell, in order: each one sees the variables set before
# it, here or in an earlier stage

# The VNC server's settings, for app/prepare.sh (its files) and app/tiger.sh (its start): docker
# run's -e VNCRES, -e VNCDEPTH and -e VNCPORT, or these defaults (README.md)
VNCRES=${VNCRES:-1280x800}
VNCDEPTH=${VNCDEPTH:-24}
VNCPORT=${VNCPORT:-1}
# No password unless docker run's -e VNCPASS sets one (app/prepare.sh writes its password file)
VNCAUTH="-SecurityTypes=None --I-KNOW-THIS-IS-INSECURE"
if [ -n "${VNCPASS}" ]; then VNCAUTH=""; fi
# VNC clients may resize the desktop (TigerVNC's default: noVNC's remote resizing, or a viewer's) unless
# docker run's -e VNCRESIZE=0 says no: TigerVNC then refuses their requests, so the desktop keeps VNCRES
VNCRESIZEOPT=""
if [ "${VNCRESIZE}" = "0" ]; then VNCRESIZEOPT="-AcceptSetDesktopSize=0"; fi
# TigerVNC's folder, as a path in the desktop user's HOME (set by app/useracct.sh), for xstartup,
# passwd and the session log (tigervncserver reads passwd from there, and vncpasswd without -f
# writes it there). It depends on the release's TigerVNC, so VERSION_ID in /etc/os-release picks
# it: Ubuntu 26.04's TigerVNC (1.15) uses ~/.config/tigervnc, Ubuntu 24.04's (1.13) uses ~/.vnc
if grep -q '^VERSION_ID="26.04"' /etc/os-release; then
  VNCDIR=".config/tigervnc"
else
  VNCDIR=".vnc"
fi

# HOME, USER and GROUP, which the stages share too, aren't set here: they're the desktop user's,
# and app/useracct.sh picks that user at run time. The container starts as root with docker's
# HOME=/root; for a non-root account, app/useracct.sh exports USER and GROUP, and HOME from the
# account's passwd entry (/home/<name>)

# Remove leftovers from a previous run (docker restart)
source /app/cleanup.sh

# Timezone: /etc/localtime follows TZ
source /app/timezone.sh

# Locale of the desktop session: LANG and LC_ALL follow LOCALE (or LANG)
source /app/locale.sh

# System services: sudo rules, X11 socket dirs, system dbus
source /app/imagestart.sh

# Desktop user: the account, HOME and its shell umask; a non-root account's USER, GROUP and HOME
# are exported for the stages below
source /app/useracct.sh

# Window manager: per-user config for the image's WINDOWMANAGER
source /app/wm.sh

# VNC server setup: xstartup and the passwords in HOME's VNCDIR, then HOME goes to the desktop user
source /app/prepare.sh

# User hook: room for your own startup commands in your copy of the image or container, run as
# root before the VNC server starts (app/userhook.sh is empty in the image and says how)
source /app/userhook.sh

# VNC server: run it as the desktop user until the desktop session ends
source /app/tiger.sh
