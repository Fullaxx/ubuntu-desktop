#!/bin/bash

BINARY="pwsh"

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  xterm -T InstallPowerShell -g 100x30 -e sudo /app/scripts/install_powershell_deb.sh
fi

# PowerShell has no window of its own, so it runs in an xterm: titled PowerShell (the install window
# above has its own title), in PowerShell's blue (Windows Terminal's "Campbell Powershell" colors),
# and with a TrueType monospace font instead of xterm's small bitmap default
xterm -T PowerShell -g 100x30 -bg '#012456' -fg '#CCCCCC' -cr '#FFFFFF' -fa Monospace -fs 11 -e ${BINARY}
