#!/bin/bash
# https://linuxconfig.org/how-to-install-tor-browser-in-ubuntu-18-04-bionic-beaver-linux
# https://linuxize.com/post/how-to-install-tor-browser-on-ubuntu-18-04/
# https://support.torproject.org/tbb/how-to-verify-signature/

set -e

export DEBIAN_FRONTEND="noninteractive"
TORVERS="10.5.10"

apt-get update
apt-get install -y file libgtk-3-0 libdbus-glib-1-2 wget xz-utils gnupg2

# Download package
wget https://www.torproject.org/dist/torbrowser/${TORVERS}/tor-browser-linux64-${TORVERS}_en-US.tar.xz -O /tmp/tor.tar.xz
wget https://www.torproject.org/dist/torbrowser/${TORVERS}/tor-browser-linux64-${TORVERS}_en-US.tar.xz.asc -O /tmp/tor.tar.xz.asc
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
gpg --verify /tmp/tor.tar.xz.asc /tmp/tor.tar.xz

# Install package
tar xf /tmp/tor.tar.xz -C /opt
rm /tmp/tor.tar.xz /tmp/tor.tar.xz.asc

# Tweak package
mv /opt/tor-browser_* /opt/tor
sed -e 's/"`id -u`" -eq 0/`false`/g' -i /opt/tor/Browser/start-tor-browser
sed -e 's/$SYSARCHITECTURE -ne $TORARCHITECTURE/"$SYSARCHITECTURE" != "$TORARCHITECTURE"/g' -i /opt/tor/Browser/start-tor-browser
