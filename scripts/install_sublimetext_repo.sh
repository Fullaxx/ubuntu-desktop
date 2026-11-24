#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# wget for the key below; no gnupg (apt reads the armored key itself), apt-transport-https
# (https is built into apt since 1.5) or software-properties-common (add-apt-repository isn't used)
apt-get install -y wget

# Sublime HQ's own setup (https://www.sublimetext.com/docs/linux_repositories.html): its key, and a deb822
# .sources file that names it in Signed-By, so the key is trusted for this repository only (for one-line
# sources without signed-by, apt 3's update suggests "apt modernize-sources")
install -d -m 0755 /etc/apt/keyrings
wget -q https://download.sublimetext.com/sublimehq-pub.gpg -O /etc/apt/keyrings/sublimehq-pub.asc
cat > /etc/apt/sources.list.d/sublime-text.sources <<EOF
Types: deb
URIs: https://download.sublimetext.com/
Suites: apt/stable/
Signed-By: /etc/apt/keyrings/sublimehq-pub.asc
EOF
# What this script wrote before (a one-line source, and a key apt trusted for every repository): next to
# the .sources file, apt would see the repository twice, with conflicting Signed-By values, and refuse to update
rm -f /etc/apt/sources.list.d/sublimetext.list /etc/apt/trusted.gpg.d/sublimetext.gpg

apt-get update
apt-get install -y sublime-text
