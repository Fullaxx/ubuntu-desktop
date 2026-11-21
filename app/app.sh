#!/bin/bash
# This script runs as root

# Remove leftovers from a previous run (docker restart)
source /app/cleanup.sh

# Timezone: /etc/localtime follows TZ
source /app/timezone.sh

# Locale of the desktop session: LANG and LC_ALL follow LOCALE (or LANG)
source /app/locale.sh

# System services: sudo rules, X11 socket dirs, system dbus
source /app/imagestart.sh

# Desktop user: the account, HOME and its shell umask
source /app/user.sh

# Window manager: per-user config for the image's WINDOWMANAGER
source /app/wm.sh

# VNC server setup: its settings, xstartup and passwords, then HOME goes to the desktop user
source /app/prepare.sh

# VNC server: run it as the desktop user until the desktop session ends
source /app/tiger.sh
