#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
ZBVERS="1.0.1-a.4"
URL="https://github.com/zen-browser/desktop/releases/download/${ZBVERS}/zen.linux-specific.tar.bz2"

cd /opt
wget ${URL}
tar xf zen.linux-specific.tar.bz2
rm zen.linux-specific.tar.bz2

cd /usr/bin
ln -s /opt/zen/zen

