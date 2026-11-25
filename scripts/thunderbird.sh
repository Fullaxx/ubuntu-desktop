#!/bin/bash

BINARY="thunderbird"

# Check 1, MISSING: is there a thunderbird command at all? which prints nothing and fails when no thunderbird is
# on the PATH, as in a fresh container
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

# Check 2, SNAPSTUB: is the thunderbird package Ubuntu's own? Since 24.04, Ubuntu's archive has no Thunderbird of
# its own: its thunderbird package (version 2:1snap…) is a stub whose /usr/bin/thunderbird only hands over to the
# Thunderbird snap, and snaps don't run in a container. So it doesn't count as installed
SNAPSTUB="no"
dpkg-query -W -f='${Version}' ${BINARY} 2>/dev/null | grep -q '^2:1snap' && SNAPSTUB="yes"

# Either way, install_thunderbird.sh adds the Mozilla Team PPA (Firefox's) and installs its Thunderbird, replacing
# the stub if there is one, in one xterm window: xterm returns 0 whatever its command did, so separate windows
# couldn't stop after a failed step
if [ "${MISSING}" = "yes" ] || [ "${SNAPSTUB}" = "yes" ]; then
  xterm -T InstallThunderbird -g 100x30 -e sudo /app/scripts/install_thunderbird.sh
fi

${BINARY}
