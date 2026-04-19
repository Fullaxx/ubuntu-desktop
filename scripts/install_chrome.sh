#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB="/tmp/chrome.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}
