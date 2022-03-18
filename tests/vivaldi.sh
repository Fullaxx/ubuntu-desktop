#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
DEB="/tmp/vivaldi.deb"
KEY="/tmp/vivaldi.pub"

VPKG=`curl https://vivaldi.com/download/ 2>/dev/null | tr '"' '\n' | grep vivaldi-stable | grep amd64.deb | head -n1`
VKEY="https://repo.vivaldi.com/stable/linux_signing_key.pub"

wget ${VPKG} -O ${DEB}
wget ${VKEY} -O ${KEY}
gpg --import ${KEY}
dpkg-sig --verify ${DEB}

