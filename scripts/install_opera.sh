#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
OPERA_VERS=`curl 'https://download3.operacdn.com/pub/opera/desktop/' | grep "\-2024 " | awk -F\" '{print $2}' | cut -d/ -f1 | tail -n1`
URL="https://download3.operacdn.com/pub/opera/desktop/${OPERA_VERS}/linux/opera-stable_${OPERA_VERS}_amd64.deb"
DEB="/tmp/opera.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y; apt-get install -y upower)
rm ${DEB}
