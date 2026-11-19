#!/bin/bash

if [ -z "$1" ]; then
  echo "$0: <wallpaper> [layout]"
  exit 1
fi

case "$1" in
  1) WPURL="https://images.rapidlinux.org/udwp/metallurgy1HDfree.jpg" ;;
  2) WPURL="https://images.rapidlinux.org/udwp/portals1HDfree.jpg" ;;
  3) WPURL="https://images.rapidlinux.org/udwp/cronusrising2k141HDfree.jpg" ;;
  4) WPURL="https://images.rapidlinux.org/udwp/harbinger2k91HDfree.jpg" ;;
  5) WPURL="https://images.rapidlinux.org/udwp/arcana2HDfree.jpg" ;;
  6) WPURL="https://images.rapidlinux.org/udwp/rivenHDfree.jpg" ;;
  7) WPURL="https://images.rapidlinux.org/udwp/circularlogicHDfree.jpg" ;;
  8) WPURL="https://images.rapidlinux.org/udwp/gardener2k121HDfree.jpg" ;;
  9) WPURL="https://images.rapidlinux.org/udwp/overseer2k141_single_1920x1080.jpg" ;;
  # an unknown number is an error, not a silent no-op
  *) echo "$0: unknown wallpaper: $1" >&2; exit 1 ;;
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

# -q keeps progress lines out of the session log; -T 20 -t 2 gives up after 2 tries of 20 s
# (wget's defaults are 20 tries and a 900 s read timeout)
wget -q -T 20 -t 2 "${WPURL}" -O /tmp/wpimg && hsetroot "${HSRCMD}" /tmp/wpimg && rm /tmp/wpimg
