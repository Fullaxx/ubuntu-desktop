#!/bin/bash
# Run this script as root
# (as VNCUSER: sudo /app/scripts/install_nomachine_deb.sh)

set -e

export DEBIAN_FRONTEND="noninteractive"
#URL="https://download.nomachine.com/download/8.15/Linux/nomachine_8.15.3_1_amd64.deb"
URL="https://web9001.nomachine.com/download/10.2/Linux/nomachine-personal-edition_10.2.3_1_amd64.deb"
DEB="/tmp/nomachine.deb"

apt-get update
apt-get install -y cups pavucontrol pamix

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
