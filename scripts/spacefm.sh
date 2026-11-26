#!/bin/bash

bailmsg()
{
  xmessage "$1" &
  exit 1
}

export DEBIAN_FRONTEND="noninteractive"
BINARY="spacefm"

# Most of the menu's apps aren't in the image, so this launcher installs its app when it's missing
MISSING="no"
which ${BINARY} >/dev/null || MISSING="yes"

if [ "${MISSING}" = "yes" ]; then
  OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
  case "${OSV}" in
    '18.04') PKGS="lsof sshfs spacefm-gtk3" ;;
    '20.04') PKGS="lsof sshfs spacefm-gtk3 yaru-theme-icon" ;;
    '22.04') PKGS="lsof sshfs spacefm-gtk3 yaru-theme-icon" ;;
    '24.04') PKGS="lsof sshfs spacefm-gtk3 yaru-theme-icon" ;;
    '26.04') PKGS="lsof sshfs spacefm-gtk3 yaru-theme-icon" ;;
          *) bailmsg "Ubuntu ${OSV} not supported!"
  esac

  xterm -T AptGetUpdate -g 100x30 -e sudo apt-get update
  xterm -T AptGetInstall -g 100x30 -e sudo apt-get install -y ${PKGS}
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
