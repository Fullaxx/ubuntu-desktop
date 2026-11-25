#!/bin/bash

BINARY="firefox"

# Check 1, MISSING: is there a firefox command at all? which prints nothing and fails when no firefox is on the
# PATH, as in a fresh container
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

# Check 2, SNAPSTUB: is the firefox package Ubuntu's own? Since 22.04, Ubuntu's archive has no Firefox of its own:
# its firefox package (version 1:1snap…) is a stub whose /usr/bin/firefox only hands over to the Firefox snap, and
# snaps don't run in a container. So it doesn't count as installed, even though check 1 finds its /usr/bin/firefox.
# (Installing firefox from the archive, as the old three-window install did after a failed PPA step, leaves it.)
SNAPSTUB="no"
dpkg-query -W -f='${Version}' ${BINARY} 2>/dev/null | grep -q '^1:1snap' && SNAPSTUB="yes"

# Either way, install_firefox.sh adds the Mozilla Team PPA and installs its Firefox, replacing the stub if there
# is one. All its steps are in that one script, run in one xterm window: xterm returns 0 whatever its command did,
# so separate windows couldn't stop after a failed step
if [ "${MISSING}" = "yes" ] || [ "${SNAPSTUB}" = "yes" ]; then
  xterm -T InstallFirefox -g 100x30 -e sudo /app/scripts/install_firefox.sh
fi

${BINARY}
