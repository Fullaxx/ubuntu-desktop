#!/bin/bash
# One script, not a prepare_ script plus an install: 1) add our source, 2) install the package, 3) remove
# our source if the package set up its own anyway (it does on 26.04), so that the vendor's source has
# priority. Step 3 can only follow step 2, so the three can't be split the way prepare_mozilla_ppa_direct.sh
# and a later install are

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg to dearmor the key below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# What this script wrote before (a one-line source, and a key apt trusted for every repository): next to
# the .sources file below, apt would see the repository twice, with conflicting Signed-By values, and refuse
# to update
rm -f /etc/apt/sources.list.d/opera-archive.list /etc/apt/trusted.gpg.d/opera.gpg

# Opera's manual setup (https://deb.opera.com/manual.html) in deb822: its key in /usr/share/keyrings, and a
# .sources file that names it in Signed-By, so the key is trusted for this repository only (for one-line
# sources without signed-by, apt 3's update suggests "apt modernize-sources"). Not named opera-stable.*:
# opera-stable looks for its repository in other files and then adds no source of its own. None is written
# if its own opera-stable.sources is already there: for the same address with a second Signed-By value, apt
# would refuse to update
if [ ! -f /etc/apt/sources.list.d/opera-stable.sources ]; then
  wget -q https://deb.opera.com/archive.key -O- | gpg --dearmor > /usr/share/keyrings/opera-browser.gpg
  cat > /etc/apt/sources.list.d/opera-archive.sources <<EOF
Types: deb
URIs: https://deb.opera.com/opera-stable/
Suites: stable
Components: non-free
Signed-By: /usr/share/keyrings/opera-browser.gpg
EOF
fi

apt-get update
# gsettings-desktop-schemas: Opera reads the org.gnome.desktop.background schema at startup and aborts
# without it; its package doesn't depend on it
apt-get install -y opera-stable gsettings-desktop-schemas

# On 26.04 the package adds its opera-stable.sources anyway (during the install its check misses this file,
# though it finds it when run by hand): the package's own source then has priority, so drop ours
if [ -f /etc/apt/sources.list.d/opera-stable.sources ]; then
  rm -f /etc/apt/sources.list.d/opera-archive.sources /usr/share/keyrings/opera-browser.gpg
fi
