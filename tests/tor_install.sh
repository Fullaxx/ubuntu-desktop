#!/bin/bash
# Install Tor Browser inside the ubuntu-desktop image with the real installer, as root (the
# image's default user), and check what tests/tor.sh cannot: that the installer's packages
# still exist on noble, that the tarball still unpacks, that the root-check patch still
# applies, and that the bundled browser and tor still run. Used by monthly.yml:
#   docker run --rm -v "$PWD/tests:/tests:ro" IMAGE /tests/tor_install.sh

set -euo pipefail

die() {
  echo "FAIL: $*" >&2
  exit 1
}

# It installs into /opt: never on a developer's machine
if [ ! -f /.dockerenv ] && [ ! -f /run/.containerenv ]; then
  die "run this inside the ubuntu-desktop image, not on a host (see the header)"
fi

/app/scripts/install_torbrowser.sh

TB="/opt/tor/Browser"
[ -x "${TB}/start-tor-browser" ] || die "${TB}/start-tor-browser was not installed"

# Without this patch Tor Browser refuses to run as root
# shellcheck disable=SC2016
grep -q '^if \[ `false` \]; then$' "${TB}/start-tor-browser" ||
  die "upstream changed start-tor-browser's root check, so the sed in scripts/install_torbrowser.sh no longer applies"

"${TB}/firefox.real" --version || die "the bundled browser does not run"
LD_LIBRARY_PATH="${TB}/TorBrowser/Tor" "${TB}/TorBrowser/Tor/tor" --version ||
  die "the bundled tor does not run"

echo "OK: Tor Browser installs, is patched to run as root, and runs"
