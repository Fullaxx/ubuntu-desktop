#!/bin/bash

BINARY="pwsh"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  xterm -T InstallPowerShell -g 100x30 -e sudo /app/scripts/install_powershell_deb.sh
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  # PowerShell has no window of its own, so it runs in an xterm: titled PowerShell (the install window
  # above has its own title), in PowerShell's blue (Windows Terminal's "Campbell Powershell" colors),
  # and with a TrueType monospace font instead of xterm's small bitmap default
  exec xterm -T PowerShell -g 100x30 -bg '#012456' -fg '#CCCCCC' -cr '#FFFFFF' -fa Monospace -fs 11 -e ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
