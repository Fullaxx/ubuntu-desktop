#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

# Add ppa:openshot.developers/ppa (the stable releases) by hand: its signing key (fingerprint from
# Launchpad; RSA 4096) and a .sources file named as add-apt-repository names it. add-apt-repository
# itself would need software-properties-common, which pulls in packagekit, polkitd and
# unattended-upgrades (73 packages on noble, 85 on 26.04); this needs only wget.
# If the PPA's signing key changes, apt-get update fails with a signature error:
# install_openshot_ppa.sh (add-apt-repository fetches the current key; it uses the daily PPA)
# still works, and PPAKEY needs the new fingerprint from the PPA's Launchpad page
PPAKEY="B118F18F5C2AA998436F1603DC9E326890348C30"
. /etc/os-release

apt-get update
apt-get install -y wget
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/openshot_developers-ubuntu-ppa.asc "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x${PPAKEY}"
cat > /etc/apt/sources.list.d/openshot_developers-ubuntu-ppa-${VERSION_CODENAME}.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/openshot.developers/ppa/ubuntu/
Suites: ${VERSION_CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/openshot_developers-ubuntu-ppa.asc
EOF
# The nightly PPA (libopenshot-daily) has newer versions, so apt would keep preferring it
# if an older run of this script added it
rm -f /etc/apt/sources.list.d/openshot_developers-ubuntu-libopenshot-daily-*.sources

apt-get update
apt-get install -y openshot-qt
