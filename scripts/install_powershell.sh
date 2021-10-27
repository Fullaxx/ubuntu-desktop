#!/bin/bash

set -e

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.1.5/powershell_7.1.5-1.ubuntu.${OSV}_amd64.deb"
DEB="/tmp/powershell.deb"

case "${OSV}" in
  '16.04') SHA="a02649b1bada2a05fe40261af0311aa4cef01372ce37d8d158b5f0b598ef1138";;
  '18.04') SHA="79f4dd72bc66ed779da22c0a561de0b0cf341201fc970930d9da9144c2824559";;
  '20.04') SHA="4d0ee19617ebd696527e966a35a00f94ca3e83c850efdde10cd4b27369a17288";;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

wget ${URL} -O ${DEB}
echo "${SHA} /tmp/powershell.deb" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
