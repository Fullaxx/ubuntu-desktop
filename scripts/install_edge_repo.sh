#!/bin/bash
# install_edge_repo.sh microsoft-edge-stable|microsoft-edge-beta|microsoft-edge-dev
# Installs that Edge package from Microsoft's repository (edge_stable.sh, edge_beta.sh and edge_dev.sh run it)
# One script, not a prepare_ script plus an install: 1) add our source, 2) install the package, 3) remove
# our source once the package has set up its own, so that the vendor's source has priority. Step 3 can only
# follow step 2, so the three can't be split the way prepare_mozilla_ppa_direct.sh and a later install are

set -e

export DEBIAN_FRONTEND="noninteractive"

# Each Edge package sets up its own repository when it installs: this file, for its own channel's address
# (packages.microsoft.com/repos/edge-<channel>) and with its own keyring in /usr/share/keyrings
PKG="$1"
case "${PKG}" in
  microsoft-edge-stable) PKGSOURCES="microsoft-edge.sources" ;;
  microsoft-edge-beta)   PKGSOURCES="microsoft-edge-beta.sources" ;;
  microsoft-edge-dev)    PKGSOURCES="microsoft-edge-dev.sources" ;;
  *) echo "Usage: $0 microsoft-edge-stable|microsoft-edge-beta|microsoft-edge-dev" >&2; exit 1 ;;
esac

apt-get update
# gnupg to dearmor the key below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
apt-get install -y gnupg wget

# What prepare_edge_repo.sh wrote before: a one-line source for the repository the bootstrap below uses
rm -f /etc/apt/sources.list.d/microsoft-edge.list

# So this script's source is only a bootstrap: a deb822 .sources file for Microsoft's repository of all
# three channels, signed by a key file of its own, and removed again below
install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | gpg --dearmor > /etc/apt/keyrings/microsoft-edge-bootstrap.gpg
cat > /etc/apt/sources.list.d/microsoft-edge-bootstrap.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/edge
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/microsoft-edge-bootstrap.gpg
EOF

apt-get update
apt-get install -y "${PKG}"

# The package's own source has priority: drop the bootstrap
if [ -f "/etc/apt/sources.list.d/${PKGSOURCES}" ]; then
  rm -f /etc/apt/sources.list.d/microsoft-edge-bootstrap.sources /etc/apt/keyrings/microsoft-edge-bootstrap.gpg
fi
