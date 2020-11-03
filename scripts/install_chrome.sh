#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB="/tmp/chrome.deb"

wget ${URL} -O ${DEB}
dpkg -i ${DEB} || (set -e; apt-get update; apt-get install -f -y)
rm ${DEB}

# for some reason the google chrome deb installs an apt sources list file that causes problems
# hopefully we can get rid of this hack in the future
/app/scripts/remove_chrome_key.sh
