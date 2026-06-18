#!/bin/bash
# https://www.dropbox.com/en/install-linux

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"
DEB="/tmp/dropbox.deb"

apt-get update

apt-get install -y gnupg2 software-properties-common apt-transport-https wget
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FC918B335044912E

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
