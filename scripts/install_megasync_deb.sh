#!/bin/bash
# https://mega.io/desktop

set -e

export DEBIAN_FRONTEND="noninteractive"

# MEGA builds its .deb for each Ubuntu release, so the download follows this one
OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
URL="https://mega.nz/linux/repo/xUbuntu_${OSV}/amd64/megasync-xUbuntu_${OSV}_amd64.deb"
DEB="/tmp/megasync.deb"

apt-get update

# gnupg for the package's postinst, which dearmors MEGA's key with gpg, and wget for the download
# (no apt-transport-https or software-properties-common: nothing here needs them)
apt-get install -y gnupg wget
# no key step: the package's postinst installs MEGA's key as /etc/apt/keyrings/meganz-archive-keyring.gpg
# and adds megaio.sources (deb822, Signed-By, this release's repository), so later upgrades come from MEGA's repo

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
apt-get install -y ${DEB}
rm ${DEB}
