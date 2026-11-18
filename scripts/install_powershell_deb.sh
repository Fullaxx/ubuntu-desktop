#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
# 7.6 is the current LTS line; SHA is the sha256 digest GitHub lists for this release asset
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.6.10/powershell-lts_7.6.10-1.deb_amd64.deb"
SHA="20E9BE2578EC14A092D31DF4B8F5B0DCFA280D3BE277504741974D6F4C762E47"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} ${DEB}" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
