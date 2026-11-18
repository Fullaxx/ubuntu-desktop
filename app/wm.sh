#!/bin/bash
# This script runs as root
# Per-user window manager config for the image's WINDOWMANAGER (it needs HOME from user.sh);
# only openbox needs any: xfce4 reads its defaults from /etc/xdg

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
