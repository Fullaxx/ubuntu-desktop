#!/bin/bash
# https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
# https://www.addictivetips.com/ubuntu-linux-tips/how-to-disable-firefox-snap-package-in-ubuntu-22-04-lts/
#
# prepare_, not install_: like prepare_mozilla_ppa_direct.sh, which this can stand in for, it only adds the
# PPA and its pin, and installs nothing itself (see the note there)

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y gnupg2 software-properties-common
add-apt-repository -y ppa:mozillateam/ppa

# The PPA's packages above Ubuntu's, and Ubuntu's own firefox (1:1snap…) and thunderbird (2:1snap…), stubs for
# snaps that a container can't run, never: when the PPA can't be reached (apt-get update only warns), installing
# either then fails instead of falling back to its stub
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1

Package: thunderbird
Pin: version 2:1snap*
Pin-Priority: -1
' | tee /etc/apt/preferences.d/mozilla-firefox
