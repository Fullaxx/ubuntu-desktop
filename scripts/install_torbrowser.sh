#!/bin/bash
# https://linuxconfig.org/how-to-install-tor-browser-in-ubuntu-18-04-bionic-beaver-linux
# https://linuxize.com/post/how-to-install-tor-browser-on-ubuntu-18-04/
# https://support.torproject.org/tbb/how-to-verify-signature/

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
apt-get install -y file gnupg2 libasound2 libgtk-3-0 libdbus-glib-1-2 wget xz-utils

TORPKG=`curl -s https://www.torproject.org/download/ 2>/dev/null | grep 'Download for Linux' | tr '"' '\n' | grep linux-x86_64 || true`
TORSIG=`curl -s https://www.torproject.org/download/ 2>/dev/null | grep Signature | tr '"' '\n' | grep tar.xz.asc || true`

if [ -z "${TORPKG}" ]; then
  echo "Hyperlinks have changed! TORPKG is not valid!"
  exit 1
fi

if [ -z "${TORSIG}" ]; then
  echo "Hyperlinks have changed! TORSIG is not valid!"
  exit 2
fi

# Download package
wget https://www.torproject.org/${TORPKG} -O /tmp/tor.tar.xz
wget https://www.torproject.org/${TORSIG} -O /tmp/tor.tar.xz.asc
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
gpg --verify /tmp/tor.tar.xz.asc /tmp/tor.tar.xz

# Install package
tar xf /tmp/tor.tar.xz -C /opt
if [ ! -d /opt/tor-browser ]; then
  echo "tor-browser not found under /tmp/tor.tar.xz!"
  exit 3
fi

# Tweak package
mv /opt/tor-browser /opt/tor
sed -e 's/"`id -u`" -eq 0/`false`/g' -i /opt/tor/Browser/start-tor-browser
sed -e 's/$SYSARCHITECTURE -ne $TORARCHITECTURE/"$SYSARCHITECTURE" != "$TORARCHITECTURE"/g' -i /opt/tor/Browser/start-tor-browser

# Clean-up
rm /tmp/tor.tar.xz /tmp/tor.tar.xz.asc
