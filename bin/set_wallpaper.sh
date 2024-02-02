#!/bin/bash

if [ -z "$1" ]; then
  echo "$0: <wallpaper> [layout]"
  exit 1
fi

case "$1" in
  1) WPURL="http://rapidlinux.org/udwp/metallurgy1HDfree.jpg" ;;
  2) WPURL="http://rapidlinux.org/udwp/portals1HDfree.jpg" ;;
  3) WPURL="http://rapidlinux.org/udwp/cronusrising2k141HDfree.jpg" ;;
  4) WPURL="http://rapidlinux.org/udwp/harbinger2k91HDfree.jpg" ;;
  5) WPURL="http://rapidlinux.org/udwp/arcana2HDfree.jpg" ;;
  6) WPURL="http://rapidlinux.org/udwp/rivenHDfree.jpg" ;;
  7) WPURL="http://rapidlinux.org/udwp/circularlogicHDfree.jpg" ;;
  8) WPURL="http://rapidlinux.org/udwp/gardener2k121HDfree.jpg" ;;
  9) WPURL="http://rapidlinux.org/udwp/overseer2k141_single_1920x1080.jpg" ;;
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
