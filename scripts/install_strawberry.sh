#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
DEB="/tmp/strawberry.deb"
SBV="0.7.2"

case "${OSV}" in
  '18.04') URL="https://files.strawberrymusicplayer.org/strawberry_${SBV}-bionic_amd64.deb" ;;
  '20.04') URL="https://files.strawberrymusicplayer.org/strawberry_${SBV}-focal_amd64.deb" ;;
  '20.10') URL="https://files.strawberrymusicplayer.org/strawberry_${SBV}-groovy_amd64.deb" ;;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
