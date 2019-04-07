#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://github.com/PowerShell/PowerShell/releases/download/v6.2.0/powershell_6.2.0-1.ubuntu.18.04_amd64.deb"
SHA="38DCB2164C1FE3B4F0200ABA2D5969C4856526BAA1D8983F818CD06003C355CE"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} /tmp/powershell.deb" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
