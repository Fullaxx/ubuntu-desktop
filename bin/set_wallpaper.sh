#!/bin/bash

if [ -z "$1" ]; then
  echo "$0: <wallpaper> [layout]"
  exit 1
fi

case "$1" in
  1) WPURL="https://digitalblasphemy.com/graphics/HDfree/acumen1HDfree.jpg" ;;
  2) WPURL="https://digitalblasphemy.com/graphics/HDfree/arcana2HDfree.jpg" ;;
  3) WPURL="https://digitalblasphemy.com/graphics/HDfree/circularlogicHDfree.jpg" ;;
  4) WPURL="https://digitalblasphemy.com/graphics/HDfree/darkfluorescence1HDfree.jpg" ;;
  5) WPURL="https://digitalblasphemy.com/graphics/HDfree/fluorescence6HDfree.jpg" ;;
  6) WPURL="https://digitalblasphemy.com/graphics/HDfree/portals1HDfree.jpg" ;;
  7) WPURL="https://digitalblasphemy.com/graphics/HDfree/sierraautumn1HDfree.jpg" ;;
  8) WPURL="https://digitalblasphemy.com/graphics/HDfree/turning2k161HDfree.jpg" ;;
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
