#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
DBVERS="1.10.3"
URL="https://downloads.sourceforge.net/project/deadbeef/Builds/${DBVERS}/linux/deadbeef-static_${DBVERS}-1_x86_64.tar.bz2"
TARBALL="/tmp/deadbeef.tar.bz2"

wget ${URL} -O ${TARBALL}
tar xf ${TARBALL} -C /opt/
mv /opt/deadbeef-${DBVERS} /opt/deadbeef
rm ${TARBALL}
