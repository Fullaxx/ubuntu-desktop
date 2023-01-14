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

BINARYLOC=`which ${BINARY}`
if [ "$?" -ne "0" ]; then
  set -e

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

${BINARY}
