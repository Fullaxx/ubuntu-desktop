#!/bin/bash
# Install the current Tor Browser release to /opt/tor, after checking its signature.
# https://support.torproject.org/tbb/how-to-verify-signature/
#
# Which release: the download-<platform>.json feed on Tor's update server, which names
# the current release, its tarball and its signature. (This used to scrape
# https://www.torproject.org/download/, which now redirects to download.torproject.org
# and links no tarballs.) The feed is not signed, so https is what vouches for which
# release it names; the signature vouches for the tarball.
#
# The signature must be good and made by Tor Browser's signing key. Its PRIMARY key is
# pinned below, so any of its subkeys is accepted: Tor signs with subkeys and rotates
# them (16.0 was signed by subkey 022DA248...D62D07D9, created 2026-08-11), so pinning
# a subkey would break at the next rotation.
#
# Usage: install_torbrowser.sh                download, verify and install
#        install_torbrowser.sh --verify-only  download and verify only (tests/tor.sh)

set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

TORKEYFPR="EF6E286DDA85EA2A4BA7DE684E2C6E8793298290"
# torbrowser@torproject.org via WKD: the advanced URL, then the direct one,
# in the order gpg's own WKD lookup tries them
TORKEYURLS=(
  "https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf"
  "https://torproject.org/.well-known/openpgpkey/hu/kounek7zrdx745qydx6p59t9mqjpuhdf"
)
INSTALLDIR="/opt/tor"

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

case "$(uname -m)" in
  x86_64)  TORARCH="linux-x86_64" ;;
  aarch64) TORARCH="linux-aarch64" ;;
  *)       die "Tor Browser has no Linux build for $(uname -m)" ;;
esac
TORFEED="https://aus1.torproject.org/torbrowser/update_3/release/download-${TORARCH}.json"

if [ "${VERIFYONLY}" == "no" ]; then
  # One install at a time: a second click on the menu item must not
  # swap a fresh ${INSTALLDIR} out from under the first
  exec 9>/run/lock/install_torbrowser.lock
  flock -n 9 || die "another Tor Browser install is already running"
  apt-get update
  apt-get install -y ca-certificates curl file gpgv jq libasound2t64 libdbus-glib-1-2 libgtk-3-0t64 xz-utils
fi

for CMD in curl gpgv jq; do
  command -v "${CMD}" >/dev/null || die "${CMD} is not installed"
done

WORK=$(mktemp -d)
STAGE=""
cleanup() {
  rm -rf "${WORK}"
  if [ -n "${STAGE}" ]; then
    rm -rf "${STAGE}"
  fi
}
trap cleanup EXIT

# Which release
FEED=$(fetch -sS "${TORFEED}") ||
  die "could not fetch Tor's release feed ${TORFEED}"
TORPKG=$(jq -er '.binary | select(type == "string" and startswith("https://"))' <<<"${FEED}") ||
  die "Tor's release feed ${TORFEED} names no https binary: ${FEED:0:300}"
TORSIG=$(jq -er '.sig | select(type == "string" and startswith("https://"))' <<<"${FEED}") ||
  die "Tor's release feed ${TORFEED} names no https signature: ${FEED:0:300}"
TORVERS=$(jq -r '.version // "unknown"' <<<"${FEED}")
echo "Tor's release feed names Tor Browser ${TORVERS}: ${TORPKG}"

# The key and the signature first: they are small, so a bad one fails before the tarball
for URL in "${TORKEYURLS[@]}"; do
  if fetch -sS -o "${WORK}/tor.keyring" "${URL}"; then
    break
  fi
  rm -f "${WORK}/tor.keyring"
done
[ -s "${WORK}/tor.keyring" ] || die "could not fetch Tor Browser's signing key"
fetch -sS -o "${WORK}/tor.tar.xz.asc" "${TORSIG}" || die "could not fetch ${TORSIG}"
fetch -o "${WORK}/tor.tar.xz" "${TORPKG}" || die "could not fetch ${TORPKG}"

# gpgv accepts a signature by ANY key in the keyring, and exits 0 for one made by an
# expired or revoked key. So also require GOODSIG (absent in those cases), and that
# every VALIDSIG names the pinned primary key in its last field.
mkdir -m 0700 "${WORK}/gnupg"
STATUS=$(gpgv --homedir "${WORK}/gnupg" --keyring "${WORK}/tor.keyring" --status-fd 1 \
  "${WORK}/tor.tar.xz.asc" "${WORK}/tor.tar.xz" 2>"${WORK}/gpgv.log") || {
  cat "${WORK}/gpgv.log" >&2
  die "gpgv rejected the signature on ${TORPKG}"
}
if ! grep -q '^\[GNUPG:\] GOODSIG ' <<<"${STATUS}"; then
  cat "${WORK}/gpgv.log" >&2
  die "no good signature on ${TORPKG}"
fi
SIGNER=$(awk '$2 == "VALIDSIG" { print $NF }' <<<"${STATUS}" | sort -u)
if [ "${SIGNER}" != "${TORKEYFPR}" ]; then
  die "${TORPKG} is signed by ${SIGNER:-an unknown key}, not by Tor Browser's key ${TORKEYFPR}"
fi
echo "Good signature on Tor Browser ${TORVERS} by ${TORKEYFPR}"

if [ "${VERIFYONLY}" == "yes" ]; then
  exit 0
fi

# Install package: unpack beside ${INSTALLDIR} and swap it in, so a failure never
# leaves a half-installed tree and a re-run never nests one tree inside another
STAGE=$(mktemp -d "${INSTALLDIR%/*}/.tor-install.XXXXXX")
tar -xJf "${WORK}/tor.tar.xz" -C "${STAGE}" --strip-components=1
TBSCRIPT="${STAGE}/Browser/start-tor-browser"
[ -x "${TBSCRIPT}" ] || die "Tor Browser ${TORVERS} has no Browser/start-tor-browser"

# Tweak package: allow running as root (this desktop's default user),
# and compare the architectures as strings
# shellcheck disable=SC2016
sed -e 's/"`id -u`" -eq 0/`false`/g' -i "${TBSCRIPT}"
# shellcheck disable=SC2016
sed -e 's/$SYSARCHITECTURE -ne $TORARCHITECTURE/"$SYSARCHITECTURE" != "$TORARCHITECTURE"/g' -i "${TBSCRIPT}"

# Tor ships every file root-owned and 0700/0600. Hand the tree to the desktop user
# (VNCUSER via sudo, otherwise root): it must be able to run it, and Tor Browser
# keeps its profile inside its own tree.
chown -R "${SUDO_UID:-0}:${SUDO_GID:-0}" "${STAGE}"

if [ -e "${INSTALLDIR}" ]; then
  OLDDIR="${INSTALLDIR}.old.$(date +%Y%m%d%H%M%S)"
  mv -T "${INSTALLDIR}" "${OLDDIR}"
  echo "Moved the previous ${INSTALLDIR} to ${OLDDIR}"
fi
mv -T "${STAGE}" "${INSTALLDIR}"
STAGE=""
echo "Installed Tor Browser ${TORVERS} to ${INSTALLDIR}"
