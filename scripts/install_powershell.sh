#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
#URL="https://github.com/PowerShell/PowerShell/releases/download/v6.2.0/powershell_6.2.0-1.ubuntu.18.04_amd64.deb"
#SHA="38DCB2164C1FE3B4F0200ABA2D5969C4856526BAA1D8983F818CD06003C355CE"
URL="https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell-lts_7.0.3-1.ubuntu.18.04_amd64.deb"
SHA="F62E5E6FCF9E0590FB867F0A2231EDD76F54B8135D8220A632413D5BA7942733"
DEB="/tmp/powershell.deb"

wget ${URL} -O ${DEB}
echo "${SHA} /tmp/powershell.deb" | sha256sum -c
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
