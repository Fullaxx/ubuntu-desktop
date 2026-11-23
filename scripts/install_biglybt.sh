#!/bin/bash

set -e

OSV=`grep VERSION_ID /etc/os-release | cut -d\" -f2`
case "${OSV}" in
  '26.04') WEBDRVPKG="webkitgtk-webdriver" ;;
        *) WEBDRVPKG="webkit2gtk-driver" ;;
esac


BBTJAVAVERS=${BBTJAVAVERS:-25}
DEBIAN_FRONTEND="noninteractive"
BBTLOCALINSTALLER="/app/installer/BiglyBT_Installer.sh"
BBTINSTSCR="/tmp/BiglyBT_Installer.sh"

if [ "${BBTGUIINSTALL}" == "1" ]; then
  OPENJDKPKG="openjdk-${BBTJAVAVERS}-jre"
  unset BBTQUIET
else
  OPENJDKPKG="openjdk-${BBTJAVAVERS}-jre-headless"
  BBTQUIET="-q"
fi

# Install java
apt-get update
apt-get install -y --no-install-recommends ${OPENJDKPKG} ${WEBDRVPKG}
if grep -q '^assistive_technologies' /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties
fi

# Download BiglyBT (if not provided locally)
if [ -x ${BBTLOCALINSTALLER} ]; then
  echo "Installing ${BBTLOCALINSTALLER} ..."
  cp -v ${BBTLOCALINSTALLER} ${BBTINSTSCR}
else
  wget https://files.biglybt.com/installer/BiglyBT_Installer.sh -O ${BBTINSTSCR}
  chmod +x ${BBTINSTSCR}
fi

# Install BiglyBT
chown ${SUDO_UID}:${SUDO_GID} /opt
sudo -u ${SUDO_USER} app_java_home="/usr/lib/jvm/java-${BBTJAVAVERS}-openjdk-amd64/" ${BBTINSTSCR} ${BBTQUIET} -dir /opt/biglybt
rm ${BBTINSTSCR}
chown -R ${SUDO_UID}:${SUDO_GID} /opt/biglybt
