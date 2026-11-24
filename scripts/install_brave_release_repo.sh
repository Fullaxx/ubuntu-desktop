#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# wget for the downloads below; no gnupg (Brave publishes its keyring ready for apt), apt-transport-https
# (https is built into apt since 1.5) or software-properties-common (add-apt-repository isn't used)
apt-get install -y wget

# Brave's own setup (https://brave.com/linux/): its keyring, and its deb822 .sources file, which names that
# keyring in Signed-By, so the key is trusted for this repository only (for one-line sources without
# signed-by, apt 3's update suggests "apt modernize-sources")
wget -q https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg -O /usr/share/keyrings/brave-browser-archive-keyring.gpg
wget -q https://brave-browser-apt-release.s3.brave.com/brave-browser.sources -O /etc/apt/sources.list.d/brave-browser-release.sources
# What this script wrote before (a one-line source, and a key apt trusted for every repository): next to
# the .sources file, apt would see the repository twice, with conflicting Signed-By values, and refuse to update
rm -f /etc/apt/sources.list.d/brave-browser-release.list /etc/apt/trusted.gpg.d/brave-browser-release.gpg

apt-get update
apt-get install -y brave-browser
