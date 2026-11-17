#!/bin/bash
# Find, download and verify the current NoMachine release with the installer's
# own code, so this test and scripts/install_nomachine_latest.sh cannot drift apart.

set -e

exec "$(dirname "$0")/../scripts/install_nomachine_latest.sh" --verify-only
