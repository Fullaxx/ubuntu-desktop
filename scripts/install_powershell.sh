#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.4.12/powershell-lts_7.4.12-1.deb_amd64.deb"
SHA="986DC04F5A2320B027ED90F2090040B559EC68CA62BD74A4977297CF85AC2CB0"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} ${DEB}" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
