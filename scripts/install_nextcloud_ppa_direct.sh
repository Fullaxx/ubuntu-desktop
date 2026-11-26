#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

# Nextcloud from the Nextcloud team's PPA (ppa:nextcloud-devs/client, stable releases), not Ubuntu's archive:
# Ubuntu 24.04's nextcloud-desktop is 3.11.0, which crashes when started again while its first-run "Legacy import"
# box is open (upstream removed the box after 3.11.0). The PPA builds the current release for 24.04 and 26.04
# alike, against each release's own Qt, and ships only Nextcloud's own packages.
# The PPA is added by hand, as install_openshot_ppa_direct.sh adds OpenShot's: its signing key (fingerprint from
# Launchpad; RSA 4096) and a .sources file named as add-apt-repository names it. add-apt-repository itself would
# need software-properties-common, which pulls in packagekit, polkitd and unattended-upgrades; this needs only wget.
# If the PPA's signing key changes, apt-get update fails with a signature error, and PPAKEY needs the new
# fingerprint from the PPA's Launchpad page
PPAKEY="1FCD77DD0DBEF5699AD2610160EE47FBAD3DD469"
. /etc/os-release

apt-get update
apt-get install -y wget
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/nextcloud-devs-ubuntu-client.asc "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x${PPAKEY}"
cat > /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${VERSION_CODENAME}.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/nextcloud-devs/client/ubuntu/
Suites: ${VERSION_CODENAME}
Components: main
Signed-By: /etc/apt/keyrings/nextcloud-devs-ubuntu-client.asc
EOF

apt-get update
apt-get install -y nextcloud-desktop
