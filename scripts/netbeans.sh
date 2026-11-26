#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
BINARY="netbeans"

# Configure PATH for either netbeans location
if ! echo ${PATH} | grep -q ':/opt/netbeans/bin/'; then
  export PATH="${PATH}:/opt/netbeans/bin/"
fi

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '18.04') SOURCE="ubuntu" ;;
    '20.04') SOURCE="ubuntu" ;;
    '22.04') SOURCE="/app/scripts/install_netbeans.sh" ;;
          *) bailmsg "${BINARY} is not supported in Ubuntu ${OSV}" ;;
  esac

  if [ "${SOURCE}" == "ubuntu" ]; then
    xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
    xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${BINARY}
  else
    xterm -T AptGetUpdate -g 100x30 -e sudo ${SOURCE}
  fi
fi

# Check again, rather than trust the install: xterm returns 0 whatever its command did
# If the app isn't there (its install failed), say so instead of nothing happening
# exec turns this script into the app, so no shell is left waiting for it to close
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"
if [ "${MISSING}" = "no" ]; then
  exec ${BINARY}
else
  xmessage "${BINARY} not found!" &
fi
