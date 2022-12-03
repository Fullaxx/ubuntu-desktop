#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
#PMVERS=`curl -s http://linux.palemoon.org/download/mainline/ | grep -A 5 'Download x64 - GTK3 tarball' | grep 'Version:' | awk '{print $2}' | cut -d\< -f1`
PMFILE=`curl -s http://linux.palemoon.org/download/mainline/ | grep 'Download x64 - GTK3 tarball' | cut -d\" -f2`
SHA=`curl -s http://linux.palemoon.org/download/mainline/ | grep -A 5 'Download x64 - GTK3 tarball' | grep 'SHA-256:' | awk '{print $2}' | cut -d\< -f1`
URL="http://linux.palemoon.org/${PMFILE}"
TARBALL="/tmp/palemoon.tar.xz"

sudo apt-get update
sudo apt-get install -y libasound2 libdbus-glib-1-2 libgtk-3-0 libnss3 yaru-theme-icon xz-utils

wget ${URL} -O ${TARBALL}
echo "${SHA} ${TARBALL}" | sha256sum -c
tar xf ${TARBALL} -C /opt/
ln -s /opt/palemoon/palemoon /usr/bin/palemoon
chown -R ${SUDO_UID}:${SUDO_GID} /opt/palemoon
rm ${TARBALL}

#If you want Pale Moon to use the dictionaries from hunspell, run the following:
#rm -r /opt/palemoon/dictionaries
#ln -s /usr/share/hunspell /opt/palemoon/dictionaries
