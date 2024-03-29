#!/bin/bash
# https://linuxconfig.org/how-to-install-tor-browser-in-ubuntu-18-04-bionic-beaver-linux
# https://linuxize.com/post/how-to-install-tor-browser-on-ubuntu-18-04/

set -e

export DEBIAN_FRONTEND="noninteractive"
TORVERS="10.5.10"

apt-get update
apt-get install -y file libgtk-3-0 libdbus-glib-1-2 wget xz-utils

# Download package
SHA="8279652de22c9842755196cd861687ba73a3d46a1d5c94dc2c1253e104a46c57"
wget https://www.torproject.org/dist/torbrowser/${TORVERS}/tor-browser-linux64-${TORVERS}_en-US.tar.xz -O /tmp/tor.tar.xz

# Manual verification since key verification is borked
echo ${SHA} /tmp/tor.tar.xz | sha256sum -c

# Install package
tar xf /tmp/tor.tar.xz -C /opt
rm /tmp/tor.tar.xz

# Tweak package
mv /opt/tor-browser_* /opt/tor
sed -e 's/"`id -u`" -eq 0/`false`/g' -i /opt/tor/Browser/start-tor-browser
sed -e 's/$SYSARCHITECTURE -ne $TORARCHITECTURE/"$SYSARCHITECTURE" != "$TORARCHITECTURE"/g' -i /opt/tor/Browser/start-tor-browser
