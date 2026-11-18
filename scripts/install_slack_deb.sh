#!/bin/bash
# https://slack.com/downloads/linux

set -e

export DEBIAN_FRONTEND="noninteractive"
# current release as of 2026-11; https://slack.com/api/desktop.latestRelease?arch=x64&variant=deb names the latest
URL="https://downloads.slack-edge.com/desktop-releases/linux/x64/4.53.287/slack-desktop-4.53.287-amd64.deb"
DEB="/tmp/slack.deb"

apt-get update
# libasound2t64: /usr/lib/slack/slack links libasound.so.2, but Slack's package doesn't depend on it
# (4.53.287 only recommends "pulseaudio | libasound2"); naming it also keeps apt from picking pulseaudio.
# libglib2.0-bin: Slack depends on one of kde-cli-tools | kde-runtime | trash-cli | libglib2.0-bin | gvfs-bin
# (tools to move files to the trash), and apt picks the first: kde-cli-tools pulled in 237 packages here
# on 26.04 (296 on noble), libglib2.0-bin leaves 48 (53)
apt-get install -y wget libasound2t64 libglib2.0-bin

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get install -y ${DEB}
rm ${DEB}
