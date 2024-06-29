#!/bin/bash

if [ -z "$1" ]; then
  echo "$0: <wallpaper>"
  exit 1
fi

case "$1" in
  1) WPURL="https://www.rapidlinux.org/udwp/metallurgy1HDfree.jpg" ;;
  2) WPURL="https://www.rapidlinux.org/udwp/portals1HDfree.jpg" ;;
  3) WPURL="https://www.rapidlinux.org/udwp/cronusrising2k141HDfree.jpg" ;;
  4) WPURL="https://www.rapidlinux.org/udwp/harbinger2k91HDfree.jpg" ;;
  5) WPURL="https://www.rapidlinux.org/udwp/arcana2HDfree.jpg" ;;
  6) WPURL="https://www.rapidlinux.org/udwp/rivenHDfree.jpg" ;;
  7) WPURL="https://www.rapidlinux.org/udwp/circularlogicHDfree.jpg" ;;
  8) WPURL="https://www.rapidlinux.org/udwp/gardener2k121HDfree.jpg" ;;
  9) WPURL="https://www.rapidlinux.org/udwp/overseer2k141_single_1920x1080.jpg" ;;
  *) WPURL="0" ;;
esac

if [ -n "${WPURL}" ] && [ "${WPURL}" != "0" ]; then
  set -e
  wget "${WPURL}" -O /tmp/wpimg.jpg

#  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/image-style -n -t int -s 0
#  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -n -t string -s /tmp/wpimg
#  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/rgba1 -n -t double -s 0.180392 -t double -s 0.0.203922 -t double -s 0.250980 -t double -s 1.000000

  for PROP in `xfconf-query -c xfce4-desktop -l`; do
    xfconf-query -c xfce4-desktop -p ${PROP} -n -t string -s /tmp/wpimg.jpg
  done

  rm /tmp/wpimg.jpg
fi
