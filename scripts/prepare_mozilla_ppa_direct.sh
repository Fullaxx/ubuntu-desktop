#!/bin/bash
# https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
# https://www.addictivetips.com/ubuntu-linux-tips/how-to-disable-firefox-snap-package-in-ubuntu-22-04-lts/
#
# prepare_, not install_: this adds the Mozilla Team PPA and its pin, so that Firefox and Thunderbird can be
# installed from it, and installs nothing itself. Keep it that way, and keep the name. firefox.sh and
# thunderbird.sh install right after it, but other images' Dockerfiles run it in a RUN line of its own and
# install firefox later, together with the rest of their packages (ubuntu-desktop-xfce-biglybt,
# ubuntu-desktop-xfce-qbittorrent, and brettdev through its add_firefox_ppa.sh)

set -e

export DEBIAN_FRONTEND="noninteractive"

# Add ppa:mozillateam/ppa by hand: its signing key (fingerprint from Launchpad; RSA 4096) and a
# .sources file named as add-apt-repository names it. add-apt-repository itself would need
# software-properties-common, which pulls in packagekit, polkitd and unattended-upgrades
# (73 packages on noble, 85 on 26.04); this needs only wget.
# If the PPA's signing key changes, apt-get update fails with a signature error:
# prepare_mozilla_ppa.sh (add-apt-repository fetches the current key) still works,
# and PPAKEY needs the new fingerprint from the PPA's Launchpad page
PPAKEY="738BEB9321D1AAEC13EA9391AEBDF4819BE21867"
. /etc/os-release

apt-get update
apt-get install -y wget
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/mozillateam-ubuntu-ppa.asc "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x${PPAKEY}"
cat > /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-${VERSION_CODENAME}.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu/
Suites: ${VERSION_CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/mozillateam-ubuntu-ppa.asc
EOF

# The PPA's packages above Ubuntu's, and Ubuntu's own firefox (1:1snap…) and thunderbird (2:1snap…), stubs for
# snaps that a container can't run, never: when the PPA can't be reached (apt-get update only warns), installing
# either then fails instead of falling back to its stub
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1

Package: thunderbird
Pin: version 2:1snap*
Pin-Priority: -1
' | tee /etc/apt/preferences.d/mozilla-firefox
