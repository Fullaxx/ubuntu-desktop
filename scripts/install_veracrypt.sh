#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
DEB="/tmp/veracrypt.deb"

case "${OSV}" in
  '18.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-18.04-amd64.deb" ;;
  '20.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-20.04-amd64.deb" ;;
  '21.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-21.04-amd64.deb" ;;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
