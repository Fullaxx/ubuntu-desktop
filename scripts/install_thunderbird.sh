#!/bin/bash
# Installs Thunderbird: thunderbird.sh runs it in an xterm, through sudo. One script, so that set -e stops at the
# first failed step, as in install_firefox.sh: xterm returns 0 whatever its command did

set -e

export DEBIAN_FRONTEND="noninteractive"

OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
# The Mozilla Team PPA, Firefox's: since 24.04, Ubuntu's own thunderbird package is only a stub for the snap
# (prepare_firefox_ppa_direct.sh adds the PPA and its pins; 22.04's archive still has a real Thunderbird)
case "${OSV}" in
  '26.04') /app/scripts/prepare_firefox_ppa_direct.sh ;;
  '24.04') /app/scripts/prepare_firefox_ppa_direct.sh ;;
esac

apt-get update
# --allow-downgrades: if Ubuntu's stub is installed, the PPA's Thunderbird replaces it, though the stub's version
# is higher (epoch 2:, the PPA's is 1:)
apt-get install -y --allow-downgrades thunderbird
