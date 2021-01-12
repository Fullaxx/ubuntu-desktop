#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.1.0/powershell_7.1.0-1.ubuntu.${OSV}_amd64.deb"
DEB="/tmp/powershell.deb"

case "${OSV}" in
  '16.04') SHA="25EDE87C86DBB44A3539E9FDFBBF7202359F723C687B9A6DD5951AEDA259C29B";;
  '18.04') SHA="0E91D6A3EFDE525266E4DC35613415D318408E4DF7C37E1E8576175AB9378FAA";;
  '20.04') SHA="09AC03BDCD7C74A36807BECA62EB4CCFCA690BE1DC3936ED08A7B8F14FE0CFF9";;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

wget ${URL} -O ${DEB}
echo "${SHA} /tmp/powershell.deb" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
