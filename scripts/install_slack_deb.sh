#!/bin/bash
# https://slack.com/downloads/linux

set -e

export DEBIAN_FRONTEND="noninteractive"
# current release as of 2026-11; https://slack.com/api/desktop.latestRelease?arch=x64&variant=deb names the latest
URL="https://downloads.slack-edge.com/desktop-releases/linux/x64/4.53.287/slack-desktop-4.53.287-amd64.deb"
DEB="/tmp/slack.deb"

apt-get update
apt-get install -y wget libasound2t64

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
