#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

apt-get update
# gnupg to dearmor the key below; no apt-transport-https (https is built into apt since 1.5)
# or software-properties-common (add-apt-repository isn't used)
# (no libgbm1/libasound2t64: VS Code's package declares them itself since 1.51.0 (2020-11) and 1.70.0 (2022-08))
apt-get install -y gnupg wget

# Microsoft's setup for VS Code: its key in /usr/share/keyrings, and a deb822 .sources file that names it in
# Signed-By, so the key is trusted for this repository only (for one-line sources without signed-by, apt 3's
# update suggests "apt modernize-sources"). VS Code's package finds its repository here and adds no source
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | gpg --dearmor > /usr/share/keyrings/microsoft.gpg
cat > /etc/apt/sources.list.d/vscode.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
# What this script wrote before: a one-line source (at the repository's older address, repos/vscode), and
# Microsoft's key where apt trusted it for every repository
rm -f /etc/apt/sources.list.d/vscode.list /etc/apt/trusted.gpg.d/microsoft.gpg

apt-get update
apt-get install -y code
