#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

# Add ppa:jonaski/strawberry by hand: its signing key (fingerprint from Launchpad; RSA 4096) and a
# .sources file named as add-apt-repository names it. add-apt-repository itself would need
# software-properties-common, which pulls in packagekit, polkitd and unattended-upgrades
# (73 packages on noble, 85 on 26.04); this needs only wget.
# If the PPA's signing key changes, apt-get update fails with a signature error:
# install_strawberry_ppa.sh (add-apt-repository fetches the current key) still works,
# and PPAKEY needs the new fingerprint from the PPA's Launchpad page
PPAKEY="BE5ED0F9261CAAD9A1E5B1A4CD6289E999EA819D"
. /etc/os-release

apt-get update
apt-get install -y wget
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/jonaski-ubuntu-strawberry.asc "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x${PPAKEY}"
cat > /etc/apt/sources.list.d/jonaski-ubuntu-strawberry-${VERSION_CODENAME}.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu/
Suites: ${VERSION_CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/jonaski-ubuntu-strawberry.asc
EOF

apt-get update
apt-get install -y strawberry
