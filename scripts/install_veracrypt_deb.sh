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

# 1.26.31 (VeraCrypt's GitHub releases, linked from https://www.veracrypt.fr/en/Downloads.html)
# has builds for 22.04 and later; 1.25.9 stays for the older releases
case "${OSV}" in
  '18.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-18.04-amd64.deb" ;;
  '20.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-20.04-amd64.deb" ;;
  '21.04') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-21.04-amd64.deb" ;;
  '21.10') URL="https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-Ubuntu-21.10-amd64.deb" ;;
  '22.04') URL="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.31/veracrypt-1.26.31-Ubuntu-22.04-amd64.deb" ;;
  '24.04') URL="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.31/veracrypt-1.26.31-Ubuntu-24.04-amd64.deb" ;;
  '26.04') URL="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_1.26.31/veracrypt-1.26.31-Ubuntu-26.04-amd64.deb" ;;
        *) bailmsg "Ubuntu ${OSV} not supported!"
esac

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
