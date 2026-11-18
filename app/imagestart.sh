#!/bin/bash
# This script runs as root

# sudo configuration for ubuntu-desktop
install -m 0440 /usr/share/ubuntu-desktop/sudo /etc/sudoers.d/ubuntudesktop

# Necessary for many applications
# (i.e. Chrome, terminator, ktorrent, ...)
/etc/init.d/x11-common start
mkdir -p /run/dbus
dbus-daemon --system --fork
