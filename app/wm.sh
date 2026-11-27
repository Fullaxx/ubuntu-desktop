#!/bin/bash
# This script runs as root
# Per-user window manager config for the image's WINDOWMANAGER (it needs HOME from user.sh);
# only openbox needs any: xfce4 reads its defaults from /etc/xdg
# On Ubuntu 26.04 it also puts glycin's bwrap workaround in front of /usr/bin/bwrap (PRIVILEGES.md)

# Openbox/FBPanel configuration
if [ "${WINDOWMANAGER}" == "openbox" ]; then
  if [ ! -d ${HOME}/.config/openbox ]; then
    mkdir -p ${HOME}/.config/openbox
  fi
  if [ ! -f ${HOME}/.config/openbox/autostart ]; then
    install -m 0755 /usr/share/ubuntu-desktop/openbox/autostart ${HOME}/.config/openbox/autostart
  fi
  if [ ! -f ${HOME}/.config/openbox/menu.xml ]; then
    install -m 0644 /usr/share/ubuntu-desktop/openbox/menu.xml ${HOME}/.config/openbox/menu.xml
  fi
  if [ ! -f ${HOME}/.config/openbox/rc.xml ]; then
    install -m 0644 /usr/share/ubuntu-desktop/openbox/rc.xml ${HOME}/.config/openbox/rc.xml
  fi

  if [ ! -d ${HOME}/.config/fbpanel ]; then
    mkdir -p ${HOME}/.config/fbpanel
  fi
  if [ ! -f ${HOME}/.config/fbpanel/default ]; then
    install -m 0644 /usr/share/fbpanel/config/default ${HOME}/.config/fbpanel/default
  fi
  if [ ! -f ${HOME}/.gtkrc-2.0 ]; then
    echo 'gtk-icon-theme-name = "gnome"' >${HOME}/.gtkrc-2.0
  fi
fi

# glycin's sandbox test goes through /usr/share/ubuntu-desktop/bwrap, so GTK programs load images
# without the sandbox where it can't start, instead of aborting (PRIVILEGES.md);
# BUBBLEWRAP_WORKAROUND=0 leaves /usr/bin/bwrap alone
# Only on Ubuntu 26.04 (VERSION_ID in /etc/os-release): its GTK programs load images through
# glycin, 24.04's don't, and only the 26.04 image ships the wrapper
if grep -q '^VERSION_ID="26.04"' /etc/os-release; then
  if [ "${BUBBLEWRAP_WORKAROUND}" != "0" ]; then
    install -m 0755 /usr/share/ubuntu-desktop/bwrap /usr/local/bin/bwrap
  fi
fi
