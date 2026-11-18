#!/bin/bash
# Run this script as root
# (as VNCUSER: sudo /app/scripts/install_nomachine_deb.sh)

set -e

export DEBIAN_FRONTEND="noninteractive"
#URL="https://download.nomachine.com/download/8.15/Linux/nomachine_8.15.3_1_amd64.deb"
URL="https://web9001.nomachine.com/download/10.2/Linux/nomachine-personal-edition_10.2.3_1_amd64.deb"
DEB="/tmp/nomachine.deb"

apt-get update
# NoMachine's package declares no dependencies (it bundles its own libraries); these add printing (cups)
# and PulseAudio volume control (pavucontrol, pamix) to its sessions
apt-get install -y cups pavucontrol pamix

wget ${URL} -O ${DEB}
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get install -y ${DEB}
rm ${DEB}
