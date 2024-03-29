#!/bin/bash
# https://linuxconfig.org/how-to-install-tor-browser-in-ubuntu-18-04-bionic-beaver-linux
# https://linuxize.com/post/how-to-install-tor-browser-on-ubuntu-18-04/
# https://support.torproject.org/tbb/how-to-verify-signature/

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y file libgtk-3-0 libdbus-glib-1-2 wget xz-utils gnupg2

TORPKG=`curl -s https://www.torproject.org/download/ 2>/dev/null | grep 'Download for Linux' | tr '"' '\n' | grep linux64`
TORSIG=`curl -s https://www.torproject.org/download/ 2>/dev/null | grep Signature | tr '"' '\n' | grep tar.xz.asc`

# Download package
wget https://www.torproject.org/${TORPKG} -O /tmp/tor.tar.xz
wget https://www.torproject.org/${TORSIG} -O /tmp/tor.tar.xz.asc
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
gpg --verify /tmp/tor.tar.xz.asc /tmp/tor.tar.xz

# Install package
tar xf /tmp/tor.tar.xz -C /opt
rm /tmp/tor.tar.xz /tmp/tor.tar.xz.asc

# Tweak package
mv /opt/tor-browser_* /opt/tor
sed -e 's/"`id -u`" -eq 0/`false`/g' -i /opt/tor/Browser/start-tor-browser
sed -e 's/$SYSARCHITECTURE -ne $TORARCHITECTURE/"$SYSARCHITECTURE" != "$TORARCHITECTURE"/g' -i /opt/tor/Browser/start-tor-browser
