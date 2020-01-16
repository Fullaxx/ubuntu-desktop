#!/bin/bash

if [ -z "$1" ]; then
  echo "$0: <wallpaper> [layout]"
  exit 1
fi

case "$1" in
  1) WPURL="https://digitalblasphemy.com/graphics/HDfree/moonbeamsea1HDfree.jpg" ;;
  2) WPURL="https://digitalblasphemy.com/graphics/HDfree/ringoffirenight2k153HDfree.jpg" ;;
  3) WPURL="https://digitalblasphemy.com/graphics/HDfree/moonshadow1HDfree.jpg" ;;
  4) WPURL="https://digitalblasphemy.com/graphics/HDfree/portals1HDfree.jpg" ;;
  5) WPURL="https://digitalblasphemy.com/graphics/HDfree/acumen1HDfree.jpg" ;;
  6) WPURL="https://digitalblasphemy.com/graphics/HDfree/threemoonbayday1HDfree.jpg" ;;
  *) WPURL="0" ;;
esac

case "$2" in
    "fill") HSRCMD="-fill" ;;
  "extend") HSRCMD="-extend" ;;
    "full") HSRCMD="-full" ;;
    "tile") HSRCMD="-tile" ;;
   "cover") HSRCMD="-cover" ;;
  "center") HSRCMD="-center" ;;
         *) HSRCMD="-center" ;;
esac

if [ -n "${WPURL}" ] && [ "${WPURL}" != "0" ]; then
  wget "${WPURL}" -O /tmp/wpimg && hsetroot "${HSRCMD}" /tmp/wpimg && rm /tmp/wpimg
fi
