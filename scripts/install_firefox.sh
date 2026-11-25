#!/bin/bash
# Installs Firefox: firefox.sh runs it in an xterm, through sudo. One script, so that set -e stops at the first
# failed step: xterm returns 0 whatever its command did, so with one xterm per step, apt-get went on after a
# failed PPA step and installed Ubuntu's firefox, a stub for the snap that a container can't run

set -e

export DEBIAN_FRONTEND="noninteractive"

OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
# The Mozilla Team PPA: Ubuntu's own firefox package is only that stub
# (prepare_mozilla_ppa.sh is the add-apt-repository version, kept for when the PPA's key changes)
case "${OSV}" in
  '26.04') /app/scripts/prepare_mozilla_ppa_direct.sh ;;
  '24.04') /app/scripts/prepare_mozilla_ppa_direct.sh ;;
  '22.04') /app/scripts/prepare_mozilla_ppa_direct.sh ;;
esac

apt-get update
# --allow-downgrades: if Ubuntu's stub is installed, the PPA's Firefox replaces it, though the stub's version is
# higher (epoch 1:)
apt-get install -y --allow-downgrades firefox
