#!/bin/bash
# This script runs as root

# Remove leftovers from a previous run (docker restart)
source /app/cleanup.sh

# Timezone: /etc/localtime follows TZ
source /app/timezone.sh

# System services: sudo rules, X11 socket dirs, system dbus
source /app/imagestart.sh

# Desktop user: the account, HOME and its shell umask
source /app/user.sh

# Window manager: per-user config for the image's WINDOWMANAGER
source /app/wm.sh

# VNC server: its config and passwords, then run it as the desktop user
source /app/tiger.sh
