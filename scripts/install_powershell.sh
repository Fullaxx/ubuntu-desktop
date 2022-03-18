#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.2.2/powershell-lts_7.2.2-1.deb_amd64.deb"
SHA="BF822A5033403C396126818985FEE79AF163B62BB015603D81400E90AC9E32C7"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} /tmp/powershell.deb" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
