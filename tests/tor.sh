#!/bin/bash

set -e

TORPKG=`curl https://www.torproject.org/download/ 2>/dev/null | grep 'Download for Linux' | tr '"' '\n' | grep x86_64`
TORSIG=`curl https://www.torproject.org/download/ 2>/dev/null | grep Signature | tr '"' '\n' | grep tar.xz.asc`

wget https://www.torproject.org/${TORPKG} -O /tmp/tor.tar.xz
wget https://www.torproject.org/${TORSIG} -O /tmp/tor.tar.xz.asc
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
gpg --verify /tmp/tor.tar.xz.asc /tmp/tor.tar.xz
