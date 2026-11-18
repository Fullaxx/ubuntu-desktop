#!/bin/bash
# This script runs as root
# Remove leftovers from a previous run (test case: docker restart ubuntu-desktop)

# Stale X server lock file and socket
rm -f /tmp/.X*-lock
rm -f /tmp/.X11-unix/*

# Stale dbus pid file (dbus-daemon refuses to start while it exists)
rm -f /run/dbus/pid
