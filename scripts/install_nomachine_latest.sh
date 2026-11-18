#!/bin/bash
# Install the current NoMachine Personal Edition release, after checking its MD5.
# Run this script as root
# (as VNCUSER: sudo /app/scripts/install_nomachine_latest.sh)
#
# Which release: NoMachine publishes no feed of its latest version, so this reads its
# Linux download page, where every package is an <h3> block holding its version, its
# MD5 signature and its download link. https vouches for the page and the package;
# the MD5 catches a corrupt or truncated download.
# install_nomachine_deb.sh installs a pinned version instead, as a backup.
#
# Since NoMachine 10, Personal Edition must be activated with a subscription or a
# 14-day trial license before it accepts remote connections.
#
# Usage: install_nomachine_latest.sh                download, verify and install
#        install_nomachine_latest.sh --verify-only  download and verify only (tests/nomachine.sh)

set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

NXPAGE="https://download.nomachine.com/download/?id=43&platform=linux"

die() {
  echo "ERROR: $*" >&2
  exit 1
}

# --speed-limit/--speed-time abort a stalled transfer (under 1 KB/s for a minute),
# which --retry then retries; without them curl waits on a stalled connection forever
fetch() {
  curl --proto '=https' --proto-redir '=https' -fL --retry 3 --retry-delay 5 \
    --connect-timeout 30 --speed-limit 1024 --speed-time 60 "$@"
}

VERIFYONLY="no"
if [ $# -eq 1 ] && [ "$1" == "--verify-only" ]; then
  VERIFYONLY="yes"
elif [ $# -ne 0 ]; then
  die "usage: ${0##*/} [--verify-only]"
fi

# Which release: the page's <h3> block that holds the amd64 .deb. It must name exactly
# one package and one MD5, so that a redesigned page fails here, loudly.
PAGE=$(fetch -sS "${NXPAGE}") || die "could not fetch ${NXPAGE}"
BLOCK=$(awk -v RS='<h3' '/_amd64\.deb/ { print; exit }' <<<"${PAGE}")
mapfile -t URLS < <(grep -o -E 'https://[a-z0-9.-]+\.nomachine\.com/download/[0-9.]+/Linux/nomachine[A-Za-z0-9._-]*_amd64\.deb' <<<"${BLOCK}" | sort -u)
mapfile -t MD5S < <(grep -o -i -E '\b[0-9a-f]{32}\b' <<<"${BLOCK}" | sort -u)
if [ "${#URLS[@]}" -ne 1 ]; then
  die "${NXPAGE} names ${#URLS[@]} amd64 .deb packages, not one: ${URLS[*]}"
fi
if [ "${#MD5S[@]}" -ne 1 ]; then
  die "${NXPAGE} gives ${#MD5S[@]} MD5 signatures for ${URLS[0]}, not one: ${MD5S[*]}"
fi
URL="${URLS[0]}"
MD5="${MD5S[0],,}"
DEBFILE="${URL##*/}"
NXVERS="${DEBFILE#*_}"
NXVERS="${NXVERS%_amd64.deb}"
echo "NoMachine's download page names NoMachine ${NXVERS}: ${URL}"

WORK=$(mktemp -d)
trap 'rm -rf "${WORK}"' EXIT
DEB="${WORK}/${DEBFILE}"

fetch -o "${DEB}" "${URL}" || die "could not fetch ${URL}"
DEBMD5=$(md5sum "${DEB}")
DEBMD5="${DEBMD5%% *}"
if [ "${DEBMD5}" != "${MD5}" ]; then
  die "${DEBFILE} has MD5 ${DEBMD5}, but ${NXPAGE} says ${MD5}"
fi
echo "MD5 OK: NoMachine ${NXVERS} (${MD5})"

if [ "${VERIFYONLY}" == "yes" ]; then
  exit 0
fi

# Install package: only now, so a page that no longer parses fails before any apt work
apt-get update
# NoMachine's package declares no dependencies (it bundles its own libraries); these add printing (cups)
# and PulseAudio volume control (pavucontrol, pamix) to its sessions
apt-get install -y cups pavucontrol pamix
# apt-get (not dpkg -i) resolves the package's dependencies before installing, and fails if it can't
# (dpkg -i || apt-get install -f removed an uninstallable package and still exited 0)
apt-get install -y "${DEB}"
echo "Installed NoMachine ${NXVERS}"
