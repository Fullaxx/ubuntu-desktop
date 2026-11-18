#!/bin/bash
# https://www.dropbox.com/en/install-linux

set -e

export DEBIAN_FRONTEND="noninteractive"
URL="https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2026.09.28_amd64.deb"
DEB="/tmp/dropbox.deb"

apt-get update

# python3-gpg lets the dropbox command verify the signature of the Dropbox daemon it downloads,
# and its download dialog uses GTK 3 (gir1.2-gtk-3.0), which the package doesn't depend on
# (no gnupg, apt-transport-https or software-properties-common: nothing here needs them)
apt-get install -y wget python3-gpg gir1.2-gtk-3.0
# no key step: the package's postinst installs Dropbox's key as /etc/apt/keyrings/dropbox.asc
# and adds dropbox.list (signed-by, this release's suite), so later upgrades come from Dropbox's repo

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get install -y ${DEB}
rm ${DEB}
