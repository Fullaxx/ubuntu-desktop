#!/bin/bash
# https://slack.com/downloads/linux

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://downloads.slack-edge.com/linux_releases/slack-desktop-4.12.2-amd64.deb"
DEB="/tmp/slack.deb"

apt-get update
apt-get install -y wget libasound2

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
