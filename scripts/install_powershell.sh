#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.2.7/powershell-lts_7.2.7-1.deb_amd64.deb"
SHA="DC85567C9A52E16EBED727F41389DE0B8E3275437E4B7A3905BC894F359A24F9"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} ${DEB}" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
