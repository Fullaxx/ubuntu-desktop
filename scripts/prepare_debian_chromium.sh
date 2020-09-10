#!/bin/bash

set -e
export DEBIAN_FRONTEND="noninteractive"
# https://askubuntu.com/questions/1179273/how-to-remove-snap-completely-without-losing-the-chromium-browser

xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y debian-archive-keyring

cat >/etc/apt/sources.list.d/debian-stable.list << EOFF
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.us.debian.org/debian/ stable main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.us.debian.org/debian/ stable main

deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://security.debian.org/ stable/updates main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://security.debian.org/ stable/updates main

# stable-updates, previously known as 'volatile'
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.us.debian.org/debian/ stable-updates main
deb-src [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] http://ftp.us.debian.org/debian/ stable-updates main
EOFF

cat >/etc/apt/preferences.d/debian-chromium << EOFF
Explanation: Prevent installing from debian repo.
Package: *
Pin: origin "*.debian.org"
Pin-Priority: 1

Explanation: Allow installing chromium from debian repo.
Package: chromium*
Pin: origin "*.debian.org"
Pin-Priority: 100
EOFF
