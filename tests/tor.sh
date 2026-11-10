#!/bin/bash
# Find, download and verify the current Tor Browser release with the installer's
# own code, so this test and scripts/install_torbrowser.sh cannot drift apart.

set -e

exec "$(dirname "$0")/../scripts/install_torbrowser.sh" --verify-only
