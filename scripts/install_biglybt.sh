#!/bin/bash

set -e

BBTJAVAVERS=${BBTJAVAVERS:-11}
export DEBIAN_FRONTEND="noninteractive"
export BBTINSTSCR="/tmp/BiglyBT_Installer.sh"

if [ "$1" == "NOQUIET" ]; then
  unset BBTAUTOINST
else
  export BBTAUTOINST="-q"
fi

apt-get update
apt-get install -y --no-install-recommends openjdk-${BBTJAVAVERS}-jre-headless webkit2gtk-driver
if grep -q '^assistive_technologies' /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties; then
  sed -e 's/^assistive_technologies/#assistive_technologies/' -i /etc/java-${BBTJAVAVERS}-openjdk/accessibility.properties
fi

chown ${SUDO_UID}.${SUDO_GID} /opt
wget -q https://files.biglybt.com/installer/BiglyBT_Installer.sh -O ${BBTINSTSCR}
chmod +x ${BBTINSTSCR}
sudo -u ${SUDO_USER} app_java_home="/usr/lib/jvm/java-${BBTJAVAVERS}-openjdk-amd64/" ${BBTINSTSCR} ${BBTAUTOINST} -dir /opt/biglybt
rm ${BBTINSTSCR}
chown -R ${SUDO_UID}.${SUDO_GID} /opt/biglybt
