#!/bin/bash

if [ -n "${WALLPAPER}" ]; then
  /root/.config/autostart/set_wallpaper_xfce4.sh ${WALLPAPER}
fi
